#!/usr/bin/awk -f

# ./pooldump-dot.awk pooldump.stdout > pooldump.dot
# dot -Tsvg pooldump.dot -o pooldump.svg

BEGIN {
    FS=","
    print "digraph G {"
    print "  rankdir=LR;"
    print "  node [shape=box];"
    print "  edge [dir=forward];"
}

NR > 1 {
    gsub(/"/, "", $2)  # thread name
    gsub(/"/, "", $4)  # pool address
    gsub(/"/, "", $6)  # object address
    gsub(/"/, "", $7)  # class name

    thread_id=$1
    thread_name=$2
    pool_id=$3
    pool_addr=$4
    obj_addr=$6
    class_name=$7
    rc=$8

    # Store thread info
    threads[thread_id] = thread_name

    # Track pool addresses for each thread
    if (!seen_pool[thread_id, pool_addr]) {
        pool_sequence[thread_id, ++pool_count[thread_id]] = pool_addr
        seen_pool[thread_id, pool_addr] = 1
    }

    # Store object relationships
    pool_objects[pool_addr, obj_addr] = class_name
    retain_counts[obj_addr] = rc
    if (rc > 1) {
        all_objects[obj_addr] = class_name
    }
}

END {
    # Create thread nodes
    for (tid in threads) {
        print "  \"thread_" tid "\" [shape=none,label=<"
        print "    <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"
        print "    <TR><TD>Thread</TD></TR>"
        print "    <TR><TD>" threads[tid] "</TD></TR>"
        print "    </TABLE>"
        print "  >];"

        # Process pools in sequence
        for (i = 1; i <= pool_count[tid]; i++) {
            pool_addr = pool_sequence[tid, i]

            print "  \"pool_" pool_addr "\" [shape=none,label=<"
            print "    <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"
            print "    <TR><TD COLSPAN=\"2\">Pool " pool_addr "</TD></TR>"
            print "    <TR><TD>Class</TD><TD>Address</TD></TR>"

            for (obj_key in pool_objects) {
                split(obj_key, obj_arr, SUBSEP)
                if (obj_arr[1] == pool_addr) {
                    print "    <TR><TD>" pool_objects[obj_key] "</TD><TD PORT=\"" obj_arr[2] "\">" obj_arr[2] "</TD></TR>"
                }
            }
            print "    </TABLE>"
            print "  >];"

            # Connect pools in sequence
            if (i == 1) {
                print "  \"thread_" tid "\" -> \"pool_" pool_addr "\";"
            } else {
                prev_pool = pool_sequence[tid, i-1]
                print "  \"pool_" prev_pool "\" -> \"pool_" pool_addr "\";"
            }
        }
    }

    # Create objects table
    print "  objects [shape=none,label=<"
    print "    <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"
    print "    <TR><TD COLSPAN=\"3\">Objects</TD></TR>"
    print "    <TR><TD>Address</TD><TD>Class</TD><TD>RC</TD></TR>"

    n = asorti(all_objects, sorted_addrs)
    for (i = 1; i <= n; i++) {
        addr = sorted_addrs[i]
        print "    <TR><TD PORT=\"" addr "\">" addr "</TD><TD>" all_objects[addr] "</TD><TD>" retain_counts[addr] "</TD></TR>"
    }
    print "    </TABLE>"
    print "  >];"

    # Create edges from pools to objects only if they are in the global objects table
    for (key in pool_objects) {
        split(key, arr, SUBSEP)
        pool_addr = arr[1]
        obj_addr = arr[2]
        if (retain_counts[obj_addr] > 1) {
            print "  \"pool_" pool_addr "\":\"" obj_addr "\" -> \"objects\":\"" obj_addr "\";"
        }
    }
    
    print "}"
}

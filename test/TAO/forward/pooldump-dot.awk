#!/usr/bin/awk -f

BEGIN {
    FS = ","

    show_all_objects = 1  # Default to showing only objects with rc > 1

    # Parse command-line arguments
    for (i = 1; i < ARGC; i++) {
        if (ARGV[i] == "--hide-rc-1") {
            show_all_objects = 0
            # Remove the argument from ARGV to prevent awk from treating it as a file
            for (j = i; j < ARGC; j++) {
                ARGV[j] = ARGV[j + 1]
            }
            ARGC--
            break
        }
    }

    print "digraph G {"
    print "  rankdir=LR;"
    print "  node [shape=box];"
    print "  edge [dir=forward];"
}

NR == 2 {
    num_fields = NF
}

function html_escape( str) {
    gsub(/&/, "\\&amp;", str)
    gsub(/</, "\\&lt;", str)
    gsub(/>/, "\\&gt;", str)
    gsub(/"/, "\\&quot;", str)
    gsub(/'/, "\\&#39;", str)
    return str
}


NR > 1 {
    gsub(/"/, "", $2)  # thread name
    gsub(/"/, "", $4)  # pool name
    gsub(/"/, "", $6)  # object name
    gsub(/"/, "", $7)  # class name

    thread_id = $1
    thread_name = html_escape( $2)
    pool_id = $3
    pool_name = html_escape( $4)
    obj_id = $5
    obj_name = html_escape( $6)
    class_name = html_escape( $7)
    rc = $8

    if (num_fields >= 10) {
        gsub(/"/, "", $9)  # owner id
        gsub(/"/, "", $10) # owner name
        owner_id = $9
        owner = $10
    }

    threads[thread_id] = thread_name

    if (!seen_pool[thread_id, pool_id]) {
        pool_sequence[thread_id, ++pool_count[thread_id]] = pool_id
        pool_names[pool_id] = pool_name
        seen_pool[thread_id, pool_id] = 1
    }

    pool_objects[pool_id, obj_id] = class_name
    retain_counts[obj_id] = rc
    obj_names[obj_id] = obj_name

    if (show_all_objects || rc > 1) {
        all_objects[obj_id] = class_name
        if (num_fields >= 10) {
            object_owners[obj_id] = owner_id
            owner_names[obj_id] = owner
        }
    }
}

END {
    # Create a subgraph for thread nodes to align them in the left column
    print "  subgraph cluster_threads {"
    print "    rank=same;"
    print "    style=invis;"  # Make the subgraph box invisible

    for (tid in threads) {
        print "    \"thread_" tid "\" [shape=none,label=<"
        print "      <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"
        print "      <TR><TD COLSPAN=\"2\">Thread</TD></TR>"
        print "      <TR><TD>Address</TD><TD>Name</TD></TR>"
        print "      <TR><TD>" tid "</TD><TD>" threads[tid] "</TD></TR>"
        print "      </TABLE>>];"
    }

    print "  }"

    # Create a subgraph for pool nodes to align them in the center column
    print "  subgraph cluster_pools {"
    print "    rank=same;"
    print "    style=invis;"  # Make the subgraph box invisible

    for (tid in threads) {
        for (i = 1; i <= pool_count[tid]; i++) {
            pool_id = pool_sequence[tid, i]
            print "    \"pool:" pool_id "\" [shape=none,label=<"
            print "      <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"
            print "      <TR><TD COLSPAN=\"2\">Pool " pool_id " (" pool_names[pool_id] ")</TD></TR>"
            print "      <TR><TD>Address</TD><TD>Class</TD></TR>"

            for (obj_key in pool_objects) {
                split(obj_key, obj_arr, SUBSEP)
                if (obj_arr[1] == pool_id) {
                    print "      <TR><TD PORT=\"" obj_arr[2] "\">" obj_arr[2] "</TD><TD>" pool_objects[obj_key] "</TD></TR>"
                }
            }

            print "      </TABLE>>];"

            # Connect thread to each pool in sequence
            if (i == 1) {
                print "  \"thread_" tid "\" -> \"pool:" pool_id "\";"
            } else {
                prev_pool_id = pool_sequence[tid, i-1]
                print "  \"pool:" prev_pool_id "\" -> \"pool:" pool_id "\";"
            }
        }
    }

    print "  }"

    # Create the objects table and place it in the right column
    print "  subgraph cluster_objects {"
    print "    rank=same;"
    print "    style=invis;"  # Make the subgraph box invisible

    print "    objects [shape=none,label=<"
    print "      <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\">"

    if (num_fields >= 10) {
        print "      <TR><TD COLSPAN=\"6\">Objects</TD></TR>"
        print "      <TR><TD>Address</TD><TD>Class</TD><TD>Name</TD><TD>RC</TD><TD>Owner ID</TD><TD>Owner</TD></TR>"
    } else {
        print "      <TR><TD COLSPAN=\"4\">Objects</TD></TR>"
        print "      <TR><TD>Address</TD><TD>Class</TD><TD>Name</TD><TD>RC</TD></TR>"
    }

    n = asorti(all_objects, sorted_addrs)
    for (i = 1; i <= n; i++) {
        obj_id = sorted_addrs[i]
        if (num_fields >= 10) {
            print "      <TR><TD PORT=\"" obj_id "\">" obj_id "</TD><TD>" all_objects[obj_id] "</TD><TD>" obj_names[obj_id] "</TD><TD>" retain_counts[obj_id] "</TD><TD PORT=\"owner_" obj_id "\">" object_owners[obj_id] "</TD><TD>" owner_names[obj_id] "</TD></TR>"
        } else {
            print "      <TR><TD PORT=\"" obj_id "\">" obj_id "</TD><TD>" all_objects[obj_id] "</TD><TD>" obj_names[obj_id] "</TD><TD>" retain_counts[obj_id] "</TD></TR>"
        }
    }

    print "      </TABLE>>];"
    print "  }"

    # Create edges from pools to objects
    for (key in pool_objects) {
        split(key, arr, SUBSEP)
        pool_id = arr[1]
        obj_id = arr[2]
        print "  \"pool:" pool_id "\":\"" obj_id "\" -> \"objects\":\"" obj_id "\";"
    }

    # Create ownership arrows if owner data exists
    if (num_fields >= 10) {
        for (obj_id in all_objects) {
            owner_id = object_owners[obj_id]
            if (owner_id != "NULL" && owner_id != -1 && owner_id != 0) {
                print "  \"objects\":\"owner_" obj_id "\" -> \"thread_" owner_id "\" [color=\"blue\",style=\"dashed\"];"
            }
        }
    }

    print "}"
}

#! /usr/bin/env mulle-bash

# Check if at least one SVG file is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 file1.csv file2.csv ... fileN.csv"
    exit 1
fi


output_stacktrace()
{
   log_entry "output_stacktrace" "$@"

   local address
   local segment_offset
   local symbol_offset
   local symbol_address
   local symbol_name
   local segment_address
   local segment_name

   local i
   local line
   local boring_line
   local function_name
   local location

   local source_file
   local line_number

   # Skip the header line

   while IFS=',' read -r address segment_offset symbol_offset symbol_address symbol_name segment_address segment_name
   do
      if [ "${address}" = 'address' ]
      then
         continue
      fi

      segment_name="${segment_name//\"/}"
      segment_offset="${segment_offset//0x/}"

      # ignore runtime code
      case "${segment_name}" in
         *mulle-objc-runtime.*)
            continue
         ;;
      esac

      i=0
      while IFS= read -r line
      do
         case $i in
            0) boring_line="$line" ;;
            1) function_name="$line" ;;
            2) location="$line" ;;
         esac
         ((i++))
      done < <(rexekutor addr2line -f -e "${segment_name}" -a "${segment_offset}")

      IFS=':' read -r source_file line_number <<< "${location}"

      printf "%s:%s %s\n" "${source_file#${MULLE_USER_PWD}/}" "${line_number:0}" "${function_name}"
   done
}


output_html()
{
    log_entry "output_html" "$@"

    local first_file="$1"

    local first_file_name

    # Start HTML file
    cat <<EOF > animation.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SVG Animation</title>
    <style>
        #svg-container {
            width: 95%;
            height: 300px;
            margin: 0 auto;
            text-align: center;
        }
        button {
            margin: 10px;
        }
        code {
            display: block;
            text-align: center;
            margin: 10px 0;
            font-size: 1.2em;
        }
        pre {
            width: 80%;
            margin: 10px auto;
            background-color: #f5f5f5;
            padding: 10px;
            border-radius: 4px;
            overflow-x: auto;
        }
        .text-content { display: none; }
        .text-content.active { display: block; }
    </style>
</head>
<body>
    <div id="titles"></div>
    <div id="commands"></div>
    <div style="text-align: center;">
        <button id="prev-btn">Previous</button>
        <button id="next-btn">Next</button>
    </div>
    <div id="svg-container">
        <img id="svg-display" src="${first_file}" alt="SVG Animation" width="100%" height="100%">
    </div>
    <div id="traces"></div>
    <script>
        const svgFiles = [
EOF

    # Add SVG files array
    local svg

    for svg in "$@"; do
        echo "            '$svg'," >> animation.html
    done
    echo "        ];" >> animation.html

    # Add number divs
    echo "        const titles = [" >> animation.html
    for svg in "$@"
    do
         echo "            '${svg%.svg}'," >> animation.html
    done
    echo "        ];" >> animation.html

    # Add title divs
    echo "        const commands = [" >> animation.html
    for svg in "$@"
    do
        txt_file="${svg%.svg}.txt"
        if [ -f "$txt_file" ]
        then
            title=$(head -n1 "$txt_file")
            echo "            '$title'," >> animation.html
        else
            echo "            ''," >> animation.html
        fi
    done
    echo "        ];" >> animation.html

    # Add stack traces
    echo "        const traces = [" >> animation.html
    for svg in "$@"; do
        trc_file="${svg%.svg}.trc"
        if [ -f "$trc_file" ]
        then
            trace=$(output_stacktrace < "$trc_file" | sed 's/"/\\"/g' | tr '\n' '\\' | sed 's/\\/\\n/g')
            echo "            '$trace'," >> animation.html
        else
            echo "            ''," >> animation.html
        fi
    done
    echo "        ];" >> animation.html

    # Complete the HTML file
    cat <<EOF >> animation.html

        let currentIndex = 0;
        const svgDisplay = document.getElementById('svg-display');
        const titlesDiv = document.getElementById('titles');
        const commandsDiv = document.getElementById('commands');
        const tracesDiv = document.getElementById('traces');
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');

        titles.forEach((title, index) => {
            const codeEl = document.createElement('h1');
            codeEl.className = 'text-content' + (index === 0 ? ' active' : '');
            codeEl.textContent = title;
            titlesDiv.appendChild(codeEl);
        });

        // Create title and trace elements
        commands.forEach((title, index) => {
            const codeEl = document.createElement('code');
            codeEl.className = 'text-content' + (index === 0 ? ' active' : '');
            codeEl.textContent = title;
            commandsDiv.appendChild(codeEl);

            const preEl = document.createElement('pre');
            preEl.className = 'text-content' + (index === 0 ? ' active' : '');
            preEl.textContent = traces[index];
            tracesDiv.appendChild(preEl);
        });

        function updateDisplay() {
            svgDisplay.src = svgFiles[currentIndex];
            document.querySelectorAll('.text-content').forEach(el => el.classList.remove('active'));
            titlesDiv.children[currentIndex].classList.add('active');
            commandsDiv.children[currentIndex].classList.add('active');
            tracesDiv.children[currentIndex].classList.add('active');
        }

        prevBtn.addEventListener('click', () => {
            currentIndex = (currentIndex > 0) ? currentIndex - 1 : svgFiles.length - 1;
            updateDisplay();
        });

        nextBtn.addEventListener('click', () => {
            currentIndex = (currentIndex < svgFiles.length - 1) ? currentIndex + 1 : 0;
            updateDisplay();
        });
    </script>
</body>
</html>
EOF
}


create_svg_file()
{
   log_entry "create_svg_file" "$@"

   local csv="$1"
   local dot="$2"
   local svg="$3"

   pooldump-dot.awk "${csv}" > "${dot}" \
   && dot -Tsvg -o "${svg}" "${dot}"
}


output()
{
   log_entry "output_csv" "$@"

   local svg_files

   svg_files=()

   local csv
   local dot
   local svg

   for csv in "$@"
   do
      r_extensionless_basename "${csv}"
      dot="${RVAL}.dot"
      svg="${RVAL}.svg"

      create_svg_file "${csv}" "${dot}" "${svg}" &

      svg_files+=("${svg}")
   done

   wait

   output_html "${svg_files[@]}"
}

r_dirname "${MULLE_EXECUTABLE}"
PATH="${PATH}:${RVAL}"

output "$@"


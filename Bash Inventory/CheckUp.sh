#!/bin/bash
dir=$(pwd)
time=($date)
bash ./baseInv.sh -c
unset -v latest
for file in "$dir"/*; do
  if [$file == "*Scan.txt"]; then
    [[ $file -nt $latest ]] && latest=$file
  fi
done
diff "*-Base-Scan.txt" "$latest" >> "Checked-$time.txt"
wall "Scan completed, please check the new differences file."

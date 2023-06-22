#!/bin/bash
#
# ref: https://gist.github.com/g105b/34ec96a305b74087d5a64db27d1b9fec
#
target=${1:-"http://127.0.0.1:80"}
while true
do
  curl $target && echo
  sleep 1
done

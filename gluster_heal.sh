#!/bin/bash

failed_count=0

volumes=$(sudo gluster volume list)
for volume in $volumes; do
    #number="$(sudo gluster volume heal $volume statistics heal-count 2>&1 | grep 'Number of entries' | awk '{print $NF}')"
    #number="$(sudo gluster volume heal $volume statistics | tail -n 3 |  egrep -i 'split-brain' | egrep -v '0|-')"
    number=$(sudo gluster volume heal $volume info $1 2>&1 | grep 'Number of entries' | awk '{print $NF}')
    for num in $number; do
        failed_count=$(expr $num + $failed_count)
    done
done

echo $failed_count

#!/bin/bash

function check_brick_offline()
{
    failed_bricks=$(gluster volume status $1 2>&1 | grep -A2 "Brick" | awk '{print $4}' | grep -c N)
    echo $failed_bricks
}

#check the offline bricks
ret=$(check_brick_offline)
if [[ $ret -gt 0 ]]; then
    echo $ret 'bricks down'

    #acquire the recovery lock, make sure there is no recovery task ongoing
    if [[ ! -e /tmp/brick_recovery_lock ]]; then
        touch /tmp/brick_recovery_lock
        #try to recover the offline bricks
        volumes=$(sudo gluster volume list)
        for volume in $volumes; do
            ret=$(check_brick_offline $volume)
            if [[ $ret -gt 0 ]]; then
                 sudo gluster volume start $volume force >/dev/null
            fi
        done

        #remove the lock when task completes
        rm -f /tmp/brick_recovery_lock
    fi
else
    echo $ret
fi

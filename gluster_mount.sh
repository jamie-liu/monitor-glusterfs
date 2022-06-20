#!/bin/bash

function check_mounts()
{
    staticmounts=$( cat /etc/fstab 2>&1 | grep brick | grep -c heketi)
    dynamicmounts=$( cat /proc/mounts 2>&1 | grep brick | grep -c heketi)

    if [[ $dynamicmounts -ne $staticmounts ]]; then
        echo $[$dynamicmounts - $staticmounts]
    else
        echo 0
    fi
}

ret=$(check_mounts)
if [[ $ret -ne 0 ]]; then
    mount -a
    ret=$(check_mounts)
fi

echo $ret

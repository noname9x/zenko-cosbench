#!/bin/bash

# set -e stops the execution of a script if a command or pipeline has an error
set -e

# modifying controller.conf

# DRIVERS var can accept comma separated values
if [[ "$DRIVERS" ]]; then
    IFS="," read -ra HOST_NAMES <<< "$DRIVERS"
    for host in "${HOST_NAMES[@]}"; do
	crudini --set controller.conf ${host} name ${host}
	crudini --set controller.conf ${host} url http://${host}:18088/driver
    done
    crudini --set controller.conf controller drivers ${DRIVERS}
    echo "Host name has been modified to ${HOST_NAMES[@]}"
    echo "Note: In your /etc/hosts file on Linux, OS X, or Unix with root permissions, make sure to associate 127.0.0.1 with ${HOST_NAMES[@]}"
fi

if [[ "$LOG_LEVEL" ]]; then
    if [[ "$LOG_LEVEL" == "info" || "$LOG_LEVEL" == "debug" || "$LOG_LEVEL" == "trace" ]]; then
	crudini --set controller.conf controller log_level ${LOG_LEVEL}
        echo "Log level has been modified to $LOG_LEVEL"
    else
        echo "The log level you provided is incorrect (info/debug/trace)"
    fi
fi

exec "$@"
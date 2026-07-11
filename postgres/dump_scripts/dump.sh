#!/bin/bash

echo "start with sleep 15s";
sleep 15s;
while true; do
    datetime=$(date "+%Y-%m-%d_%H-%M-%S-%N");
    echo "=======================";
    echo "datetime ${datetime}";
    dumpName="/dump/${POSTGRES_PROJECT_DB}-${datetime}.gz";
    echo "creating dump ${dumpName}";
    pg_dump --dbname="${DUMP_DB_URL}" | gzip > "${dumpName}";

    if [ "${PIPESTATUS[0]}" == 0 ]; then
        echo "dump is created succeeded";
    else
        echo "fail created dump";
    fi

    oldDumps=$(find /dump -type f -mtime +7);

    if [ -n "${oldDumps}" ]; then
        echo "deleting old dumps";

        for t in ${oldDumps}; do
            echo "deleting old dump ${t}";
            rm -f "${t}";

            if [ "${PIPESTATUS[0]}" == 0 ]; then
                echo "dump is deleted succeeded";
            else
                echo "fail deleted dump";
            fi
        done

        echo "old dumps is deleted";
    else
        echo "old dumps not found";
    fi

    echo "=======================";
    sleep 24h;
done

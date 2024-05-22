#!/bin/sh
#HOST_NUMBER must be set (for opal1 it's 1, etc)
TABNAMES=`cat names`

for TABNAME in $TABNAMES; do
    opal file -up "${TABNAME}_${HOST_NUMBER}.csv" /home/administrator -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  -v
    cat "variables_${TABNAME}.json" | opal rest -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /datasource/test/tables --content-type "application/json" -v
    opal import-csv --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination test --path /home/administrator/"${TABNAME}_${HOST_NUMBER}.csv" --tables $TABNAME --type PARTICIPANT
    opal perm-table --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --type USER --project test --subject guest  --permission view --add --tables $TABNAME
done


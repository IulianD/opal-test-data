#!/bin/sh
podman cp /home/idragan/opal-test-data/brca/CpGs_2.csv  opal-rock_opal1_2:/srv/
podman cp /home/idragan/opal-test-data/brca/variables_CpGs.json  opal-rock_opal1_2:/srv/

 opal file -up "CPGS_2.csv" /home/administrator -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  -v
 cat "variables_CPGS.json" | opal rest -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /datasource/test/tables --content-type "application/json" -v
 opal import-csv --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination test --path /home/administrator/CPGS_2.csv --tables CPGS --type PARTICIPANT
 opal perm-table --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --type USER --project test --subject guest  --permission view --add --tables CPGS

 opal delete-table -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  --project test --tables CpGs -v


 opal file -up "MRNA_2.csv" /home/administrator -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  -v
 cat "variables_MRNA.json" | opal rest -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /datasource/test/tables --content-type "application/json" -v
 opal import-csv --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination test --path /home/administrator/MRNA_2.csv --tables MRNA --type PARTICIPANT
 opal perm-table --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --type USER --project test --subject guest  --permission view --add --tables MRNA

 opal delete-table -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  --project test --tables miRNA -v


 opal file -up "MIRNA_2.csv" /home/administrator -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD  -v
 cat "variables_MIRNA.json" | opal rest -o http://localhost:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /datasource/test/tables --content-type "application/json" -v
 opal import-csv --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination test --path /home/administrator/MIRNA_2.csv --tables MIRNA --type PARTICIPANT
 opal perm-table --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --type USER --project test --subject guest  --permission view --add --tables MIRNA
 
 opal project --o http://localhost:8080 --u administrator --password $OPAL_ADMINISTRATOR_PASSWORD --name test




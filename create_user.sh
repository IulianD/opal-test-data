opal user --opal http://localhost:8080 --user administrator --password password --add --name guest --upassword Guest#1234 --groups WP2
opal project --opal http://localhost:8080 --user administrator --password password --name test
opal project --opal http://localhost:8080 --user administrator --password password --delete --name test
opal project --opal http://localhost:8080 --user administrator --password password --add --name test --database postgresdb
opal perm-project --opal http://localhost:8080 --user administrator --password password --type GROUP --subject WP2 --project test --permission administrate --add -v
###
### test datashield.login:
# curl -v  --user "administrator:password" https://podmandev.vital-it.ch/opal1/ws/system/subject-profile/_current/
###

~                     

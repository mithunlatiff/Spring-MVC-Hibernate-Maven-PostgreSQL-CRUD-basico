#!/bin/sh
cd /tmp
HOOK_RETRIES=200000000
set PGPASSWORD=$POSTGRESQL_PASSWORD
curl -s  https://raw.githubusercontent.com/dsubires/Spring-MVC-Hibernate-Maven-PostgreSQL-CRUD-basico/master/postgreSQL.sql -o /tmp/postgreSQL.sql
while [ "$HOOK_RETRIES" != 0 ]; do
    echo "Checking if db is up"
    if  PGPASSWORD=$POSTGRESQL_PASSWORD psql  -h db -U $POSTGRESQL_USER  -p 5432 -d $POSTGRESQL_DATABASE &>/dev/null; then 
    echo "Database is up"
    break
    else
    echo "Db down"
    let HOOK_RETRIES=HOOK_RETRIES-1
    fi
done

if [ "$HOOK_RETRIES" = 0 ]; then
  echo 'Too many tries, giving up'
  exit 1
fi
if PGPASSWORD=$POSTGRESQL_PASSWORD psql -h db -U $POSTGRESQL_USER  -p 5432 -d $POSTGRESQL_DATABASE < /tmp/postgreSQL.sql; then
   echo "Database initialized"
else 
    echo "Failed"
    exit 2
fi
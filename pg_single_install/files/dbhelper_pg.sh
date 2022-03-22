#!/bin/sh
# DataBase Helper script for Linux 
# v 1.0 by ABurtsev (13.12.2021) 
#	- create

# Get OS info
OS=$(grep PRETTY /etc/os-release | sed -e 's/PRETTY_NAME="//' -e 's/"//')
# Get uptime
UPTIME=$(uptime | awk -F'( |,|:)+' '{print $6,$7",",$8,"hours,",$9,"minutes."}')

### Output ###
echo ''
echo -e '\033[44m=====DataBase Helper for PostgreSQL=====\033[0m'
echo ''
echo -e '\033[44m# OS information:\033[0m'
echo -e 'Operating system---------------' ${OS}
echo -e 'Hostname-----------------------' ${HOSTNAME}
echo -e 'This system works--------------' ${UPTIME}
echo ''
echo -e '\033[44m# PostgreSQL information:\033[0m'
for env_file in $(find ${HOME} -maxdepth 1 -type f -name '*.env'); do

    . $env_file
    pg_isready -q -p ${PGPORT} -U ${PGUSER} -d ${PGDATABASE} 2> /dev/null

    if [ $? -eq 0 ]
    then                                                                                               
        echo -e 'Cluster name------------------' $(echo $env_file | cut -d '/' --output-delimiter=" " -f 1- | awk '{print $NF}' | cut -d '.' -f 1)
        echo -e 'PostgreSQL version------------' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SHOW server_version;")
        echo -e 'Cluster uptime----------------' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SELECT now()-pg_postmaster_start_time();" | sed 's/:[^:]*//2g')
        echo -e 'Data directory----------------' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SHOW data_directory;")
        echo -e 'Logfile directory-------------' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SHOW log_directory;")
        echo -e 'Cluster port------------------' ${PGPORT}
        #echo -e 'PostgreSQL in recovery mode?--' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SELECT pg_is_in_recovery();")
        if [ $(psql -U $PGUSER -p ${PGPORT} -d $PGDATABASE -t -c "SELECT pg_is_in_recovery();") == t ]
        then echo -e 'PostgreSQL in recovery mode. This is \033[33mreplica\033[0m-server.'
             echo -e 'Replica lag is' $(psql -U ${PGUSER} -p ${PGPORT} -d ${PGDATABASE} -t -c "SELECT now()-pg_last_xact_replay_timestamp();")
            elif [ $(psql -U $PGUSER -p ${PGPORT} -d $PGDATABASE -t -c "SELECT pg_is_in_recovery();") == f ]
        then echo -e 'PostgreSQL not in recovery mode. This is \033[33mmaster\033[0m-server.'
            else
        echo 'Not information about recovery mode'
        fi
        echo -e '\033[34m==============================\033[0m'
    else
        echo -e 'Cluster name' $(echo $env_file | cut -d '/' --output-delimiter=" " -f 1- | awk '{print $NF}' | cut -d '.' -f 1) 'is offline'
        echo -e '\033[34m==============================\033[0m'
    fi
done
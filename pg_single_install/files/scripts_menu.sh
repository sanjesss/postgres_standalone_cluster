#!/bin/bash 
 
echo -en "This script is needed to use scripts for PostgreSQL. Launch it?\n(yes/no)\n" 
read ANSWER 
 
case $ANSWER in 
 
        yes) 
        echo -en "What'll we do?\n1. Check replica\n2. Show locks tree\nEnter number:" 
        read NUM 
 
        case $NUM in 
 
                1) 
                echo -ne "Check replica...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -x -c "select * from pg_stat_replication;" 
                ;; 

                2) 
                echo -ne "Show locks tree...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/show_locks.sql" 
                ;; 

                3) 
                echo -ne "Show DB activity...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/db_activity.sql" 
                ;; 

                4) 
                echo -ne "Show DB size...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/db_size.sql" 
                ;; 

                5) 
                echo -ne "Show relations size...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/rel_size.sql" 
                ;; 

                6) 
                echo -ne "Show CPU stats...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/query_stat_cpu_time.sql" 
                ;; 

                7) 
                echo -ne "Show IO stats...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/query_stat_io_time.sql" 
                ;; 

                8) 
                echo -ne "Show rows stats...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/query_stat_rows.sql" 
                ;; 

                9) 
                echo -ne "Show time stats...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/query_stat_time.sql" 
                ;; 

                10) 
                echo -ne "Show redundant indexes...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/redundant_indexes.sql" 
                ;; 

                11) 
                echo -ne "Show temp files query...\n" 
                /usr/pgsql-{{ PG_VERSION_NUMBER }}/bin/psql -a -f "/var/lib/pgsql/scripts/temp_files_query.sql" 
                ;; 

                *) 
                echo -n "Wrong number" 
                ;; 
        esac 
        ;; 
 
        no) 
        echo -ne "Script stopped\n" 
        ;; 
 
        *) 
        echo -ne "Wrong answer\n" 
        ;; 
esac
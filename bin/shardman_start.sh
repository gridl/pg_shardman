#!/bin/bash

script_dir=`dirname "$(readlink -f "$0")"`
source "${script_dir}/common.sh"

cd "${script_dir}/.."
make clean

restart_nodes # make sure nodes run
for port in $master_port "${worker_ports[@]}"; do
    psql -p $port -c "drop extension if exists pg_shardman;"
done

restart_nodes
make install
for port in $master_port "${worker_ports[@]}"; do
    psql -p $port -c "create extension pg_shardman cascade;"
done

# to restart master bgw
restart_nodes

run_demo

psql

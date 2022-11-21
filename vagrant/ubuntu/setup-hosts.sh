#! /bin/bash


# If give error exit
set -ex

# Input Data
NIC_NAME=$1
LOAD_BALANCER_IP_START=$2
MASTER_IP_START=$3
WORKER_IP_START=$4
NUMBER_OF_MASTER_NODE=$5
NUMBER_OF_WORKER_NODE=$6


# Get address & network
ADDRESS="$(ip -4 addr show eth1 | grep 'inet' | awk '{print $2}' | cut -d/ -f1)"
NETWORK="$(echo $ADDRESS | awk 'BEGIN {FS="."} ; {printf("%s.%s.%s", $1, $2, $3)}')"

# Change the address
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu2004 entry
sed -e '/^.*ubuntu2004.*/d' -i /etc/hosts
# sed -e "/^.*${HOSTNAME}.*/d" -i /etc/hosts

# Set all node domain names
# LoadBalancer
echo ${NETWORK}.${LOAD_BALANCER_IP_START}  loadbalancer >> /etc/hosts

# Master Nodes
for (( i=1; i<=$NUMBER_OF_MASTER_NODE; i++))
do
    echo ${NETWORK}.$((MASTER_IP_START+i)) master-${i} >> /etc/hosts
done

# Worker Nodes
for (( i=1; i<=$NUMBER_OF_WORKER_NODE; i++))
do
    echo ${NETWORK}.$((WORKER_IP_START+i)) worker-${i} >> /etc/hosts
done

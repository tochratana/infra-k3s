#!/bin/bash

# K3s High Availability Embedded etcd Setup Script

# Set variables
K3S_VERSION="v1.25.0+k3s1"  # Set your desired K3s version
TOKEN=$(openssl rand -hex 16)  # Generate a random token
MASTER1_IP="10.148.0.5"  # Replace with your first server's IP
MASTER2_IP="10.148.0.6"  # Replace with your second server's IP
MASTER3_IP="10.148.0.7"  # Replace with your third server's IP

# Function to install K3s on a node
install_k3s() {
    local node_ip=$1
    local is_first=$2

    if [ "$is_first" = true ]; then
        curl -sfL https://get.k3s.io | sh -s - server \
            --cluster-init \
            --tls-san $MASTER1_IP \
            --tls-san $MASTER2_IP \
            --tls-san $MASTER3_IP \
            --node-ip $node_ip \
            --token $TOKEN
    else
        curl -sfL https://get.k3s.io | sh -s - server \
            --server https://${MASTER1_IP}:6443 \
            --token $TOKEN \
            --node-ip $node_ip
    fi
}

# Function to wait for K3s to be ready
wait_for_k3s() {
    echo "Waiting for K3s to be ready..."
    while ! kubectl get nodes &>/dev/null; do
        sleep 5
    done
    echo "K3s is ready!"
}

# Install K3s on the first master node
echo "Installing K3s on the first master node..."
install_k3s $MASTER1_IP true
wait_for_k3s

# Get the node-token from the first master
NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Install K3s on the second and third master nodes
for ip in $MASTER2_IP $MASTER3_IP; do
    echo "Installing K3s on master node $ip..."
    ssh root@$ip "curl -sfL https://get.k3s.io | sh -s - server \
        --server https://${MASTER1_IP}:6443 \
        --token $NODE_TOKEN \
        --node-ip $ip"
done

echo "K3s HA cluster with embedded etcd has been set up successfully!"

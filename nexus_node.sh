#!/bin/bash

# Prompt user for the number of nodes
read -p "Enter the number of nodes to create: " NUM_NODES

# Validate input (must be a number)
if ! [[ "$NUM_NODES" =~ ^[0-9]+$ ]]; then
    echo "? Please enter a valid integer!"
    exit 1
fi

# Create and store Node IDs
echo "?? Please enter a unique Node ID for each node:"
NODE_ID_LIST=()

for ((i=1; i<=NUM_NODES; i++))
do
    read -p "Enter Node ID for node$i: " NODE_ID
    echo "$NODE_ID" > "node-id$i"
    NODE_ID_LIST+=("$NODE_ID")
    echo "? Created node-id$i with Node ID: $NODE_ID"
done

# Pull the latest image
echo "?? Pulling the latest Nexus prover image..."
docker pull macthanhlongg/nexus-prover

# Create docker-compose.yml file
echo "?? Generating docker-compose.yml..."

cat <<EOF > docker-compose.yml
version: '3.8'

services:
EOF

for ((i=1; i<=NUM_NODES; i++))
do
cat <<EOF >> docker-compose.yml
  node$i:
    image: macthanhlongg/nexus-prover:lastest
    container_name: node$i
    volumes:
      - ./node-id$i:/root/.nexus/node-id
      - ./start.sh:/app/start.sh
      - ./run_cli.exp:/app/run_cli.exp
    tty: true
    stdin_open: true

EOF
done

echo "? docker-compose.yml has been created with $NUM_NODES nodes!"

# Start all nodes using docker-compose
echo "?? Starting $NUM_NODES nodes..."
docker-compose up -d

echo "? All nodes are running! Use 'docker ps' to check their status."

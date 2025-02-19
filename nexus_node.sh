#!/bin/bash

# Prompt user for the number of nodes
read -p "Enter the number of nodes to create: " NUM_NODES

# Validate input (must be a number)
if ! [[ "$NUM_NODES" =~ ^[0-9]+$ ]]; then
    echo "❌ Please enter a valid integer!"
    exit 1
fi

# Prompt user for Node ID
read -p "Enter Node ID: " NODE_ID

# Create a single node-id file
echo "$NODE_ID" > node-id
echo "✅ Created node-id file with Node ID: $NODE_ID"

# Pull the latest image
echo "🚀 Pulling the latest Nexus prover image..."
docker pull macthanhlongg/nexus-prover

# Create docker-compose.yml file
echo "✅ Generating docker-compose.yml..."

cat <<EOF > docker-compose.yml
version: '3.8'

services:
EOF

for ((i=1; i<=NUM_NODES; i++))
do
cat <<EOF >> docker-compose.yml
  node$i:
    image: macthanhlongg/nexus-prover:latest
    container_name: node$i
    volumes:
      - ./node-id:/root/.nexus/node-id
      - ./start.sh:/app/start.sh
      - ./run_cli.exp:/app/run_cli.exp
    tty: true
    stdin_open: true

EOF
done

echo "✅ docker-compose.yml has been created with $NUM_NODES nodes!"

# Start all nodes using docker-compose
echo "🚀 Starting $NUM_NODES nodes..."
docker-compose up -d

echo "✅ All nodes are running! Use 'docker ps' to check their status."

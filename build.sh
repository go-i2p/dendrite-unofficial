#! /usr/bin/env sh

git clone https://github.com/element-hq/dendrite
cd dendrite
go build -o bin/ ./cmd/...

# Generate a Matrix signing key for federation (required)
./bin/generate-keys --private-key matrix_key.pem

# Generate a self-signed certificate (optional, but a valid TLS certificate is normally
# needed for Matrix federation/clients to work properly!)
./bin/generate-keys --tls-cert server.crt --tls-key server.key

# Copy and modify the config file - you'll need to set a server name and paths to the keys
# at the very least, along with setting up the database connection strings.
cp dendrite-sample.yaml dendrite.yaml

# Build and run the server:
./bin/dendrite --tls-cert server.crt --tls-key server.key --config dendrite.yaml

# Create an user account (add -admin for an admin user).
# Specify the localpart only, e.g. 'alice' for '@alice:domain.com'
./bin/create-account --config dendrite.yaml --username alice
#!/bin/sh
set -e

# validate subscription status
API_URL="https://agent.api.stepsecurity.io/v1/github/$GITHUB_REPOSITORY/actions/subscription"

# Set a timeout for the curl command (3 seconds)
RESPONSE=$(curl --max-time 3 -s -w "%{http_code}" "$API_URL" -o /dev/null) || true
CURL_EXIT_CODE=$?

# Decide based on curl exit code and HTTP status
if [ $CURL_EXIT_CODE -ne 0 ]; then
  echo "Timeout or API not reachable. Continuing to next step."
elif [ "$RESPONSE" = "200" ]; then
  :
elif [ "$RESPONSE" = "403" ]; then
  echo "Subscription is not valid. Reach out to support@stepsecurity.io"
  exit 1
else
  echo "Timeout or API not reachable. Continuing to next step."
fi

mount=""
if [ -n "$3" ] || [ -n "$4" ]; then
  config_dir="/github/workspace/$(dirname $3)"
  mount="-v $config_dir:/opt/aerospike/etc"
fi

if [ -n "$4" ]; then
  feature_key_file=$(basename $4)
  image="-e \"FEATURE_KEY_FILE=/opt/aerospike/etc/$feature_key_file\" aerospike/aerospike-server-enterprise:$2"
else
  image="aerospike/aerospike-server:$2"
fi

if [ -n "$3" ]; then
  config_file=$(basename $3)
  docker_cmd="docker run -d --name gha_aerospike -p $1:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 \
  $mount --config-file /opt/aerospike/etc/$config_file $image"
else
  docker_cmd="docker run -d --name gha_aerospike -p $1:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 $image"
fi

echo $docker_cmd

sh -c "$docker_cmd"
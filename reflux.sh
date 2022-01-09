#!/bin/bash

# post data
NAMESPACE="flux-system"
WORKLOAD="funky-darts-api"
KIND="deployment"
URI="https://reflux.funkyd.art/release"

while getopts ":n:s:t:" opt; do
    case $opt in
        n)
            NONCE=$OPTARG
            ;;
        s)
            SECRET=$OPTARG
            ;;
        t)
            VERSION=$OPTARG
            ;;
        *)
            echo "-t flag is required"
            ;;
    esac
done

# auth data
TIMESTAMP=$(date +%s)
BODY="{\"namespace\": \"$NAMESPACE\", \"workload\": \"$WORKLOAD\", \"kind\": \"$KIND\", \"tag\": \"$VERSION\"}"
MESSAGE=$(printf "%s-%s-%s-%s" "$NONCE" "$TIMESTAMP" "$URI" "$BODY")
HMAC_HASH=$(printf %s "$MESSAGE" | openssl dgst -sha256 -hmac "$SECRET" | sed 's/^.*= //')

# update image policy
curl -v -H "X-Authorization-Nonce: $NONCE" \
    -H "X-Authorization-Timestamp: $TIMESTAMP" \
    -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
    -d "$BODY" "$URI"

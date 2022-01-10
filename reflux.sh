#!/bin/bash

set -e

create_release() {
    OUTPUT_FILE=$(mktemp)
    HTTP_CODE=$(
        curl -H "X-Authorization-Nonce: $NONCE" \
            -H "X-Authorization-Timestamp: $TIMESTAMP" \
            -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
            -o "$OUTPUT_FILE" -w "%{http_code}" \
            -s -d "$BODY" "$URI"
    )
    if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
        ERROR_NOT_FOUND="not found"
        if [[ $(cat "$OUTPUT_FILE") =~ .*"$ERROR_NOT_FOUND".* ]]; then
            create_imagepolicy
        fi
    fi
    cat "$OUTPUT_FILE"
    rm "$OUTPUT_FILE"
}

create_imagepolicy() {
    IMAGEPOL_OUTPUT_FILE=$(mktemp)
    HTTP_CODE=$(
        curl -H "X-Authorization-Nonce: $NONCE" \
            -H "X-Authorization-Timestamp: $TIMESTAMP" \
            -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
            -o "$OUTPUT_FILE" -w "%{http_code}" \
            -s -d "$BODY" "$URI"
    )
    if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
        >&2 cat "$IMAGEPOL_OUTPUT_FILE"
        exit 1
    fi
    cat "$IMAGEPOL_OUTPUT_FILE"
    rm "$IMAGEPOL_OUTPUT_FILE"
}

# post data
NAMESPACE="flux-system"
WORKLOAD="funky-darts-api"
KIND="deployment"

while getopts ":e:n:s:t:" opt; do
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
        e)
            case $OPTARG in
                'dev')
                    URI="https://reflux.dev.funkyd.art/release"
                    ;;
                'test')
                    URI="https://reflux.test.funkyd.art/release"
                    ;;
                'prod')
                    URI="https://reflux.funkyd.art/release"
                    ;;
                *)
                    echo "valid environments are [dev, test, prod]"
                    ;;
            esac
            ;;
        *)
            echo "-e -n -s and -t flags are required"
            ;;
    esac
done

# auth data
TIMESTAMP=$(date +%s)
BODY="{\"namespace\": \"$NAMESPACE\", \"workload\": \"$WORKLOAD\", \"kind\": \"$KIND\", \"tag\": \"$VERSION\"}"
MESSAGE=$(printf "%s-%s-%s-%s" "$NONCE" "$TIMESTAMP" "$URI" "$BODY")
HMAC_HASH=$(printf %s "$MESSAGE" | openssl dgst -sha256 -hmac "$SECRET" | sed 's/^.*= //')

# update image policy
create_release

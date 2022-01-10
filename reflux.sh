#!/bin/bash

set -e

BASE_URI="funkyd.art"
RELEASE_ENDPOINT="/release"
IMAGEPOL_ENDPOINT="/imagepolicy/create"
STATUS_ENDPOINT="/release/status"
SLEEP_BETWEEN_STATUS_CHECKS=15
MAX_STATUS_CHECKS=10

create_release() {
    OUTPUT_FILE=$(mktemp)
    RELEASE_URI=$(printf "$URI%s" "$RELEASE_ENDPOINT")
    MESSAGE=$(printf "%s-%s-%s-%s" "$NONCE" "$TIMESTAMP" "$RELEASE_URI" "$BODY")
    echo "$MESSAGE"
    HMAC_HASH=$(printf %s "$MESSAGE" | openssl dgst -sha256 -hmac "$SECRET" | sed 's/^.*= //')

    HTTP_CODE=$(
        curl -H "X-Authorization-Nonce: $NONCE" \
            -H "X-Authorization-Timestamp: $TIMESTAMP" \
            -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
            -o "$OUTPUT_FILE" -w "%{http_code}" \
            -s -d "$BODY" "$RELEASE_URI"
    )
    if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
        ERROR_NOT_FOUND="not found"
        if [[ $(cat "$OUTPUT_FILE") =~ .*"$ERROR_NOT_FOUND".* ]]; then
            # if imagepolicy is not found, create it
            create_imagepolicy
        else
            cat "$OUTPUT_FILE"
            echo "Status Code: $HTTP_CODE"
            exit 1
        fi
    fi
    cat "$OUTPUT_FILE"
    echo ""
    rm "$OUTPUT_FILE"
    check_release_status
}

create_imagepolicy() {
    IMAGEPOL_OUTPUT_FILE=$(mktemp)
    IMAGEPOL_URI=$(printf "$URI%s" "$IMAGEPOL_ENDPOINT")
    MESSAGE=$(printf "%s-%s-%s-%s" "$NONCE" "$TIMESTAMP" "$IMAGEPOL_URI" "$BODY")
    HMAC_HASH=$(printf %s "$MESSAGE" | openssl dgst -sha256 -hmac "$SECRET" | sed 's/^.*= //')

    HTTP_CODE=$(
        curl -H "X-Authorization-Nonce: $NONCE" \
            -H "X-Authorization-Timestamp: $TIMESTAMP" \
            -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
            -o "$IMAGEPOL_OUTPUT_FILE" -w "%{http_code}" \
            -s -d "$BODY" "$IMAGEPOL_URI"
    )
    if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
        >&2 cat "$IMAGEPOL_OUTPUT_FILE"
        echo "Status Code: $HTTP_CODE"
        exit 1
    fi
    cat "$IMAGEPOL_OUTPUT_FILE"
    echo ""
    rm "$IMAGEPOL_OUTPUT_FILE"
    check_release_status
}

check_release_status() {
    STATUS_OUTPUT_FILE=$(mktemp)
    STATUS_URI=$(printf "$URI%s" "$STATUS_ENDPOINT")
    BODY="{\"namespace\": \"$WORKLOAD_NAMESPACE\", \"workload\": \"$WORKLOAD\", \"kind\": \"$KIND\", \"tag\": \"$VERSION\"}"
    MESSAGE=$(printf "%s-%s-%s-%s" "$NONCE" "$TIMESTAMP" "$STATUS_URI" "$BODY")
    HMAC_HASH=$(printf %s "$MESSAGE" | openssl dgst -sha256 -hmac "$SECRET" | sed 's/^.*= //')

    HTTP_CODE=$(
        curl -H "X-Authorization-Nonce: $NONCE" \
            -H "X-Authorization-Timestamp: $TIMESTAMP" \
            -H "X-Authorization-Content-Sha256: $HMAC_HASH" \
            -o "$STATUS_OUTPUT_FILE" -w "%{http_code}" \
            -s -d "$BODY" "$STATUS_URI"
    )
    if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
        >&2 cat "$STATUS_OUTPUT_FILE"
        echo ""
        echo "Status Code: $HTTP_CODE"
        exit 1
    fi
    cat "$STATUS_OUTPUT_FILE"

    # loop until release is ready (200)
    counter="$MAX_STATUS_CHECKS"
    while [ "$HTTP_CODE" != 200 ] && [ "$counter" -gt 0 ]
    do
        counter=$(( counter - 1 ))
        sleep "$SLEEP_BETWEEN_STATUS_CHECKS"
        check_release_status
    done
}

# post data
FLUX_NAMESPACE="flux-system"

while getopts ":c:e:k:n:s:t:w:" opt; do
    case $opt in
        c)
            NONCE=$OPTARG
            ;;
        e)
            case $OPTARG in
                'dev')
                    URI=$(printf "https://reflux.dev.%s" "$BASE_URI")
                    ;;
                'test')
                    URI=$(printf "https://reflux.test.%s" "$BASE_URI")
                    ;;
                'prod')
                    URI=$(printf "https://reflux.%s" "$BASE_URI")
                    ;;
                *)
                    echo "valid environments are [dev, test, prod]"
                    ;;
            esac
            ;;
        k)
            KIND=$OPTARG
            ;;
        n)
            WORKLOAD_NAMESPACE=$OPTARG
            ;;
        s)
            SECRET=$OPTARG
            ;;
        t)
            VERSION=$OPTARG
            ;;
        w)
            WORKLOAD=$OPTARG
            ;;
        *)
            echo "-e -n -s and -t flags are required"
            ;;
    esac
done

# auth data
TIMESTAMP=$(date +%s)
BODY="{\"namespace\": \"$FLUX_NAMESPACE\", \"workload\": \"$WORKLOAD\", \"kind\": \"$KIND\", \"tag\": \"$VERSION\"}"

# update image policy
create_release

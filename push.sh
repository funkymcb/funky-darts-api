#!/bin/bash
iflag=false
mflag=false

usage () {
    echo "USAGE: ./push.sh -i <increment> (required) -m <commit-message> (required)"
    echo "  -i must be one of the following"
    echo "      <major> (i+1.0.0)"
    echo "      <minor> (0.i+1.0)"
    echo "      <patch> (0.0.i+1)"
    echo
    echo "EXAMPLE: ./push.sh -i patch -m \"solved millennium problem\""
}

error () {
    echo "ERROR: $1"; echo; usage; exit 1;
}

join() {
    echo "$*"
}

while getopts ":i:m:" opt; do
    case $opt in
        i)
            increment=$OPTARG;
            iflag=true;
            ;;
        m)
            message=$OPTARG;
            mflag=true;
            ;;
        \?)
            error "invalid option: -$OPTARG";
            ;;
        :)
            error "option -$OPTARG requires an argument";
            ;;
    esac
done

# no flag was passed
if [ $OPTIND -eq 1 ]; then
    usage;
    exit 1;
fi

shift $((OPTIND-1))

# check if both flags were passed
if [ "$iflag" == false ] || [ "$mflag" == false ]; then
    error "both flags are required";
fi

# check if increment flag has one of the allowed values
case $increment in
    "major" | "minor" | "patch")
        ;;
    *)
        echo "increment needs to be 'major', 'minor' or 'patch'"
        echo
        usage;
        exit 1;
esac

version=$(grep " VERSION:" < .github/workflows/pipeline.yaml | sed 's/  VERSION: //')
echo "current version: $version"

IFS='.'
read -r -a verarr <<< "$version"
case $increment in
    "major")
        verarr[0]=$(( verarr[0]+1 ))
        verarr[1]="0"
        verarr[2]=0
        ;;
    "minor")
        verarr[1]=$(( verarr[1]+1 ))
        verarr[2]=0
        ;;
    "patch")
        verarr[2]=$(( verarr[2]+1 ))
        ;;
esac

upgraded_version=$(join "${verarr[@]}")

echo "upgraded version: $upgraded_version"

# remove '' if you do not run this script on a mac
sed -i '' "s/$version/$upgraded_version/" .github/workflows/pipeline.yaml

current_branch=$(git symbolic-ref -q HEAD)
current_branch=$(echo "$current_branch" | sed 's/refs\/heads\///')
git add --all && git commit -m "$message" && git push origin "$current_branch"

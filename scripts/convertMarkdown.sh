#!/bin/bash
set -e
IFS=$'\n'
mkdir -p _dist
DATE=$(TZ=Australia/Sydney date +%Y-%m-%d--%H-%M)
FORMATS=(docx pdf plain epub rst html odt)
echo "$DATE" > ./theDate
for f in $(find . | grep 'md$'); do
    for FORMAT in ${FORMATS[@]}; do
        FNAME=$(basename -s ".md" "$f")
        DIRNAME=$(dirname "$f")
        mkdir -p "_dist/$DIRNAME"
        EXT="$FORMAT"
        if [ "$FORMAT" == "pdf" ]; then
            FORMAT="ms"
            EXT="pdf"
        fi
        if [ "$FORMAT" = "plain" ]; then
            EXT="txt"
        fi
        LAST_EDIT=$(TZ=Australia/Sydney date -d @$(git log --format=%at -- "$f" | head -1) +%Y-%m-%d--%H-%M)
        OUTNAME="_dist/$DIRNAME/$FNAME.last-edited.$LAST_EDIT.$EXT"
        echo "$FNAME" "<- FNAME"
        pandoc --from gfm --to $FORMAT $f -o $OUTNAME &
    done
done
wait

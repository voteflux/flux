#!/bin/bash
set -e
IFS=$'\n'
mkdir -p _dist
DATE=$(TZ=Australia/Sydney date +%Y-%m-%d--%H-%M)
FORMATS=(docx pdf txt epub rst html odt rtf)
echo "$DATE" > ./theDate
for f in $(find . | grep 'md$'); do
    for FORMAT in $FORMATS; do
        FNAME=$(basename -s "$f")
        DIRNAME=$(dirname "$f")
        EXT="$FORMAT"
        if [ "$FORMAT" == "pdf" ]; then
            FORMAT="html5"
            EXT="pdf"
        fi
        LAST_EDIT=$(TZ=Australia/Sydney date -d @$(git log --format=%at -- %f | head -1) +%Y-%m-%d--%H-%M)
        OUTNAME="_dist/$DIRNAME/$FNAME.last-edited.$LAST_EDIT.$EXT"
        pandoc --from gfm --to $FORMAT $f -o $OUTNAME &
    done
done
wait

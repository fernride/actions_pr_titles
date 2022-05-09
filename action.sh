#!/bin/bash

# This takes the title, and replaces things like that:
# "fs 234" becomes "FS-234"
# "Fs 234" becomes "FS-234"
# "Fs 2345,fs 234" becomes "FS-2345,FS-234"
# etc.
title=$(curl -H "Accept: application/vnd.github.v3+json" --header "Authorization: Bearer ${REPO_TOKEN}" https://api.github.com/repos/${REPO_NAME}/pulls/${PR_NUMBER} | grep -Po '"title":.*?[^\\]",')
title=$(sed "s/.*title\": \"\(.*\)\",/\1/g" <<< "${title}")
title=$(sed "s/\(fs\|FS\|Fs\|fS\)[ -]*\([0-9]*\)/FS-\2/g" <<< "${title}")
curl -X PATCH -H "Accept: application/vnd.github.v3+json" --header "Authorization: Bearer ${REPO_TOKEN}" "https://api.github.com/repos/${REPO_NAME}/pulls/${PR_NUMBER}" -d "{\"title\":\"$title\"}"

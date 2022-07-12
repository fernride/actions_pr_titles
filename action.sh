#!/bin/bash

# This takes the title, and replaces things like that:
# "fs 234" becomes "FS-234"
# "Fs 234" becomes "FS-234"
# "Fs 2345,fs 234" becomes "FS-2345,FS-234"
# etc.
title=$(curl -H "Accept: application/vnd.github.v3+json" --header "Authorization: Bearer ${REPO_TOKEN}" https://api.github.com/repos/${REPO_NAME}/pulls/${PR_NUMBER} | grep -Po '"title":.*?[^\\]",')
title_orig=${title}

# check if title contains Jira ID already, otherwise use branch name (Github often uses a commit message for the PR title)
if ! grep -o -E "[a-zA-Z0-9,\.\_\-]+-[0-9]+" <<<"${title}"; then
    echo "Current automatic PR title does not contain Jira Ticket ID, using branch name '${BRANCH_NAME}' instead!"
    title="${BRANCH_NAME}"
fi

title=$(sed "s/.*title\": \"\(.*\)\",/\1/g" <<<"${title}")
title=$(sed "s/\(fs\|FS\|Fs\|fS\)[ -]*\([0-9]*\)/FS-\2/g" <<<"${title}")

# get JIRA id from title and set as output for next step
jira_id=$(grep -o -E "[A-Z0-9]+-[0-9]+" <<<"${title}")
echo ::set-output name=jira_id::"${jira_id}"
echo "Jira id is '${jira_id}'."

if curl -i --fail -X PATCH -H "Accept: application/vnd.github.v3+json" --header "Authorization: Bearer ${REPO_TOKEN}" "https://api.github.com/repos/${REPO_NAME}/pulls/${PR_NUMBER}" -d "{\"title\":\"$title\"}"; then
    echo "Updated title from '${title_orig}' to '${title}'."
else
    echo "Failed to update PR title from '${title_orig}' to '${title}'."
fi

# actions_beautify
A github composite action to beautify PR titles.

Sample usage:
```
(...)
on: pull_request
jobs:
  update_pr:
    runs-on: [self-hosted, X64, can]
    steps:
      - uses: fernride/actions_beautify@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
```
        

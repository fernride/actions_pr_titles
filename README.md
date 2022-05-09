# actions_beautify

A github composite action to beautify PR titles.

Sample usage:

```yaml
(...)
on: pull_request
jobs:
  update_pr:
    runs-on: [self-hosted, X64, can]
    steps:
      - uses: fernride/actions_beautify@v1
```

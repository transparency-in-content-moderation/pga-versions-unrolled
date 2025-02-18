Unrolling the Versions from Platform Governance Archive
=======================================================

The [PGA v2 dataset Git repository](https://github.com/OpenTermsArchive/pga-versions) of the [Platform Governance Archive](https://www.platformgovernancearchive.org/) archives the versions of community guidelines, terms of service, privacy policies (and more) from 20+ social media platforms.

This project is a collection of scripts to
- "unroll" the policy versions from the Git history into a temporary directory
- clean the version history from versions which only change the formatting
- get some preliminary metrics from the cleaned version history.


## Updating to the Latest Version of PGA-Versions

The PGA-Versions repository is incorporated as a Git submodule. Updating is done by:

    git submodule update pga-versions

The "unroll" will also perform an update.


## Unroll

To unpack all versions of the policies run the shell script [unroll-pga-versions.sh](./unroll-pga-versions.sh).
The versions are written into the directory `tmp-pga-versions-history`.


## Deduplication and Metrics

The PGA-Versions include duplicates where markup or links are different but the textual content is the same.
Running the notebook [PGA-Versions-History](./PGA-Versions-History.ipynb) will extract the plain text, perform the deduplication and calculate some metrics. The metrics are written to [pga-versions-history.csv](./pga-versions-history.csv).

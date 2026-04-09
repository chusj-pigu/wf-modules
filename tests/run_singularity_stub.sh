#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

nextflow run tests/main.nf \
  -stub-run \
  -c tests/nextflow.config \
  -profile singularity \
  "$@"

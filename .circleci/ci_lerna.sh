#!/bin/bash
#
# Wrapper script that runs lerna with the "right" concurrency setting for the machine it's running on.
# For non-docker machines, lerna's defaults will "simply work".
# For CircleCI docker containers, we have to get clever and provide a --concurrency argument because the docker environment confuses lerna (and most other tools)
# ...but if someone sets the LERNA_CONCURRENCY variable then we'll use that instead.
set -eu
set -o pipefail

function weAreOnDocker() {
  grep -q docker </proc/1/cgroup >/dev/null 2>&1 && [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ]
}

function calcConcurrencyForDocker() {
  # This logic came from CircleCI
  # Feature request CCI-I-578,
  # aka https://ideas.circleci.com/cloud-feature-requests/p/have-nproc-accurately-reporter-number-of-cpus-available-to-container
  # had a suggestion from Sebastian Lerna at 2022-12-15T17:11 which provided Node code to divide cpu quota by period.
  # However, this doesn't always give you the answer you expect because sometimes (often?) docker containers are given more (e.g. 2x) CPU than you'd expect.
  # This is "expected behaviour" because CircleCI are (randomly) generous when there's extra CPU going spare.
  local quota
  local period
  quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
  period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)
  echo $((quota / period))
}

if [ -n "${LERNA_CONCURRENCY:-}" ]; then
  echo "$0: env var LERNA_CONCURRENCY is set to ${LERNA_CONCURRENCY}"
elif weAreOnDocker; then
  LERNA_CONCURRENCY="$(calcConcurrencyForDocker)"
  echo "$0: we are on docker with ${LERNA_CONCURRENCY} CPUs"
else
  echo "$0: we are using defaults, $(lerna --help | grep ' --concurrency ' | sed -e 's,^.*\([[]default:.*\),\1,g')"
fi

if [ -n "${LERNA_CONCURRENCY:-}" ]; then
  echo "$0: lerna --concurrency ${LERNA_CONCURRENCY}" "$@"
  exec lerna --concurrency "${LERNA_CONCURRENCY}" "$@"
else
  echo "$0: lerna" "$@"
  exec lerna "$@"
fi

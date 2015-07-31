#!/bin/bash
#
# Merge to branch 'master' automatically when running in CircleCI.


# Test, if we're running in CircleCI environment.
if [[ -z "${CIRCLECI}" || "${CIRCLECI}" != 'true' ]] ; then
  echo 'Not running in CircelCI environment.'
  exit 1
fi

# If the branch being tested is not 'dev', we exit immediately.
if [[ -z "${CIRCLE_BRANCH}" || "${CIRCLE_BRANCH}" != 'dev' ]] ; then
  echo 'Merge to master is allowed only, if running on dev.'
  exit 1
fi

# Do we have a commit id?
if [[ -z "${CIRCLE_SHA1}" ]] ; then
  echo 'No commit id was injected.'
  exit 1
else
  # Merge to master and push to upstream.
  echo 'Switching to branch master...'
  git checkout master || exit 1
  # We only need to merge and push, if the local master branch is not on the
  # commit we are about to merge.
  echo 'Checking, if we can skip the merge and push, b/c local master already has the commit...'
  LAST_COMMIT_OF_LOCAL_MASTER="`git log -n1 --pretty=oneline | awk '{ print $1 }'`"
  if [[ "${LAST_COMMIT_OF_LOCAL_MASTER}" != "${CIRCLE_SHA1}" ]] ; then
    echo "Merging tested commit ${CIRCLE_SHA1}..."
    git merge "${CIRCLE_SHA1}" || exit 1
    echo 'Pushing local master to upstream...'
    git push git@github.com:kayabendroth/docker-oracle-jdk8.git master:master
  else
    echo 'Local master is on the commit we were asked to merge already.'
  fi
fi


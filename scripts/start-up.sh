#!/bin/bash

# Setup pre-commit
pre-commit install > start_up.log 2>&1;
pre-commit install --hook-type commit-msg >> start_up.log 2>&1;
# Setup git config
git submodule update;
git config --global commit.gpgsign true;
cp /workspaces/lighthouse-github-actions/scripts/hooks/prepare-commit-msg /workspaces/lighthouse-github-actions/.git/hooks


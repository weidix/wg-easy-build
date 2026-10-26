#!/bin/sh
set -eu
apk add --no-cache git python3 make g++
npm install --global corepack@latest
corepack enable
cd /upstream/src
pnpm install --frozen-lockfile
pnpm build
# Match upstream's separate libsql runtime stage, without pnpm add in source.
mkdir -p /tmp/libsql-runtime
cd /tmp/libsql-runtime
npm install --no-save --omit=dev libsql
cd /upstream/src
mkdir -p .output/server/database .output/cli
cp -R server/database/migrations .output/server/database/
cp cli/cli.sh .output/cli/cli.sh
cp -R /tmp/libsql-runtime/node_modules .output/server/
node --check .output/server/index.mjs
# Includes dotfiles as well as the CLI and database migrations.
cp /upstream/LICENSE .output/LICENSE
tar -czf /dist/wg-easy-output.tar.gz -C .output .
tar -tzf /dist/wg-easy-output.tar.gz | grep -q './server/index.mjs'

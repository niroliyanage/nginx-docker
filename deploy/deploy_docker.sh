#!/bin/sh

set -xe

cd "$(dirname "$0")"
cd ..

mv nginx.env nginx.tf
cd deploy
 ./plan.sh
 ./apply.sh

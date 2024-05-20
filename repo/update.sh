#!/bin/bash
set -e

rm -rf *.db*
rm -rf *.files*

repo-add nanoarch.db.tar.gz *.tar.zst

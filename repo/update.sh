#!/bin/bash
set -e

rm -rf *.db*
rm -rf *.files*

repo-add nanoarch-kernels.db.tar.gz *.tar.zst

#!/bin/bash

# Synch folders : We may DROP folders. The resize script cant recurse through folders hence flatten folders into root folder
cd /catalog/original
find /catalog/original/ -name '*.*' -exec cp '{}' ./ \;
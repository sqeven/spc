#!/bin/bash

/usr/local/coreseek/bin/indexer --all > /var/sphinx/log/indexer.log

echo "Starting Sphinx"
/usr/local/coreseek/bin/searchd --nodetach


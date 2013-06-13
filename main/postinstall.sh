#!/bin/sh
node_modules/coffee-script/bin/coffee -c ./;
node_modules/jade/bin/jade . -c -r;

export NODE_ENV=production;

#!/bin/sh
pegjs peg.pegjs
node parse.js
pegjs -e Peg peg.pegjs

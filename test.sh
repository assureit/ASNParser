#!/bin/sh
pegjs peg.pegjs
node parse.js
pegjs -e 'var module = module ? module : {}; module.exports = Peg' peg.pegjs

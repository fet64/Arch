#!/bin/sh

amixer sget Master | awk -F"[][]" '/dB/ { print $2 }'

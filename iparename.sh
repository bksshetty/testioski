#!/bin/sh
value=`cat version.txt`
echo "$value"
mv $CIRCLE_ARTIFACTS/AW17.ipa $CIRCLE_ARTIFACTS/$value
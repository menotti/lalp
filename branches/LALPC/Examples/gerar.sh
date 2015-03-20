#!/bin/bash
FILES=`ls -p | grep "/"`
for f in $FILES
do
  echo "Processing $f..."
  cd $f
  make
  cd ..
done

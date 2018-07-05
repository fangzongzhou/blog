#! /bin/bash
git add .
git branch | grep '*'
git commit -m $1
echo $1
git push


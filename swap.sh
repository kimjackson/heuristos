#!/bin/sh
grep -rl $1 . | xargs perl -pi -e "s/$1/$2/g"

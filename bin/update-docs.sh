#!/usr/bin/env bash

source _env.sh

if [[ ! $(command -v terraform-docs) ]]; then
  echo "terraform-docs is missing"
  exit 1
fi


for i in $(find $PROJECT_DIR/src/ -path $PROJECT_DIR/src/.terraform -prune -o -type f  -name main.tf |sed 's/\/main.tf//g'); do
  BPATH="docs/$(echo $i | sed "s,$PROJECT_DIR/src,,")"
  if test -f "$i/main.tf" ; then
    mkdir -p $BPATH
    terraform-docs md $i > $BPATH/README.md
  fi
done

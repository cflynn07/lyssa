#!/bin/bash
#for f in ./*.js ./**/*.js ./**/partials/*.js ; do
#  rm $f;
#done;

for f in ./*.html ./**/*.html ./**/partials/*.html ; do
  echo $f;
  html2jade -d < $f > "${f%.html}.jade";
done;

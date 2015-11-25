#!/bin/sh

find ./build -name *.ipa -or -name *.dSYM.zip | xargs ./Scripts/app-dist-upload.py

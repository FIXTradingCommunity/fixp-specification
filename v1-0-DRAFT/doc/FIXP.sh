#!/bin/bash

echo Compilation started...
# Script is expected to start running in the folder where it is located (together with the source files)
SOURCE="$PWD"
# There is only one disclaimer and style docx file for all FIX Technical Standards and it is stored with the FIX Session Layer
# FIXP Repository has local copies with the specific names and dates of the standard
DISCLAIMER="FIXDisclaimerTechStd.md"
STYLE="FIX_TechStd_Style_MASTER.docx"
TARGET="$SOURCE/target"
YAML="$SOURCE/FIXP.yaml"
FILES="01Introduction.md 02Requirements.md 03CommonFeatures.md 04PointToPointSessionProtocol.md 05MulticastSessionProtocol.md 06SummaryOfSessionMessages.md 07UsageExamples.md 08RulesOfEngagement.md"
WPFOLDER="/wp-content/uploads/2020/03/"

# Create document version with disclaimer
pandoc "$DISCLAIMER" $FILES -o "$TARGET/docx/FIX Performance Session Layer V1.0.docx" --reference-doc="$STYLE" --metadata-file="$YAML" --toc --toc-depth=4
echo FIXP document version created

# Create base online version without disclaimer
pandoc $FILES -s -o "$TARGET/debug/FIXPONLINE.html" -s --metadata-file="$YAML" --toc --toc-depth=2

# Create separate online versions for production and test website by including appropriate link prefixes
sed 's,img src="media/,img src="https://www.fixtrading.org'$WPFOLDER',g' "$TARGET/debug/FIXPONLINE.html" > "$TARGET/html/FIXPONLINE_PROD.html"
sed s/www.fixtrading.org/www.technical-fixprotocol.org/ "$TARGET/html/FIXPONLINE_PROD.html" > "$TARGET/html/FIXPONLINE_TEST.html"
echo FIXP ONLINE version created for PROD and TEST

echo Compilation ended!

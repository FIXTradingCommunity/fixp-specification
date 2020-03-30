#!/bin/bash

# This script must be run in the directory where you want the generated output to be.
# This should not be the directory of the GitHub clone as the repository should not contain generated content.
TARGET="$PWD"

echo Compilation started...
LOCAL="<INSERT YOUR LOCAL PATH TO THE GITHUB CLONE DIRECTORY HERE>"
ROOT="$LOCAL/GitHub/fixp-specification/v1-1-DRAFT/doc"
# There is only one disclaimer and style docx file for all FIX Technical Standards and it is stored with the FIX Session Layer
DISCLAIMER="$LOCAL/GitHub/fix-session-layer-standards/FIXDisclaimerTechStd.md"
STYLE="$LOCAL/GitHub/fix-session-layer-standards/FIX_TechStd_Style_MASTER.docx"
SOURCE="$ROOT"
YAML="$SOURCE/FIXP.yaml"
FILES="01Introduction.md 02Requirements.md 03CommonFeatures.md 04PointToPointSessionProtocol.md 05MulticastSessionProtocol.md 06SummaryOfSessionMessages.md 07UsageExamples.md 08RulesOfEngagement.md"
WPFOLDER="/wp-content/uploads/2020/03/"
cd "$SOURCE"

# Create document version with disclaimer
pandoc "$DISCLAIMER" $FILES -o "$TARGET/FIX Performance Session Layer V1.1.docx" --reference-doc="$STYLE" --metadata-file="$YAML" --toc --toc-depth=4
echo FIXP document version created

# Create base online version without disclaimer
pandoc $FILES -o "$TARGET/FIXPONLINE.html"

# Switch back to target directory for changing content of generated output with SED utility
cd "$TARGET"

# Create separate online versions for production and test website by including appropriate link prefixes
sed 's,img src="media/,img src="https://www.fixtrading.org'$WPFOLDER',g' FIXPONLINE.html > FIXPONLINE_PROD.html
sed 's,img src="media/,img src="https://www.technical-fixprotocol.org'$WPFOLDER',g' FIXPONLINE.html > FIXPONLINE_TEST.html
#sed s/"img src=\"media\/"/"img src=\"https:\/\/www.fixtrading.org\/$WPFOLDER\/"/g FIXPONLINE.html > FIXPONLINE_PROD.html
#sed s/"img src=\"media\/"/"img src=\"https:\/\/www.technical-fixprotocol.org\/$WPFOLDER\/"/g FIXPONLINE.html > FIXPONLINE_TEST.html

# Change remaining links to production website in test version to test website
sed -i '.bak' s/www.fixtrading.org/www.technical-fixprotocol.org/ FIXPONLINE_TEST.html
echo FIXP ONLINE version created for PROD and TEST

echo Compilation ended!

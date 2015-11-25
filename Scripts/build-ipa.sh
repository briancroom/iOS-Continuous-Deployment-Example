#!/bin/sh

set -euf -o pipefail

PROJECT_NAME=iOS-Continuous-Deployment-Example.xcodeproj
SCHEME=iOS-Continuous-Deployment-Example
BUILD_NAME="${SCHEME}_$(git rev-parse --short HEAD)"

OUTPUT_DIR=./build
ARCHIVE_PATH="$OUTPUT_DIR/Archives/$BUILD_NAME.xcarchive"
IPA_PATH="$OUTPUT_DIR/$BUILD_NAME.ipa"
DSYM_NAME="$BUILD_NAME.dSYM.zip"

# 1. Make the archive
xcodebuild archive -project "$PROJECT_NAME" -scheme "$SCHEME" -archivePath "$ARCHIVE_PATH"
# 2. Export the IPA
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportPath "$OUTPUT_DIR" -exportOptionsPlist "Scripts/export-options.plist"
mv "$OUTPUT_DIR/$(basename `find "$ARCHIVE_PATH" -name *.app` .app).ipa" "$IPA_PATH"
# 3. Zip the dSYM
cd "$ARCHIVE_PATH/dSYMS" && zip -r -9 "$DSYM_NAME" $(find . -name "*.dSYM") >/dev/null && mv "$DSYM_NAME" ../../../ && cd -

echo "** Built IPA at: $IPA_PATH **"

#!/bin/sh

set -eu -o pipefail

KEYCHAIN=ios-build.keychain

# Initialize keychains
security create-keychain -p travis $KEYCHAIN
security default-keychain -s $KEYCHAIN
security unlock-keychain -p travis $KEYCHAIN
security -v set-keychain-settings -lut 86400 $KEYCHAIN

# Download and import certificates and keys
curl 'https://developer.apple.com/certificationauthority/DeveloperIDCA.cer' -s -o ./Scripts/travis/DeveloperIDCA.cer
security import ./Scripts/travis/DeveloperIDCA.cer -k $KEYCHAIN -T /usr/bin/codesign
security import ./Scripts/travis/developer.p12 -k $KEYCHAIN -P "$SIGNING_KEY_PASSWORD" -T /usr/bin/codesign

# Put the provisioning profile where Xcode can find it
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
ls ./Scripts/travis
cp ./Scripts/travis/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

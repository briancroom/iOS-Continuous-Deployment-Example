#!/bin/sh

UPLOAD_OUTPUT_PATH="./build/upload-output.txt"
BUILD_URL=$(egrep -o "http(s)?://[^[:space:]]+" "$UPLOAD_OUTPUT_PATH" | tail -n1)

if [[ $BUILD_URL && $SLACK_WEBHOOK_URL ]]; then
	curl -s -X POST --data-urlencode "payload={\"text\": \"A new build is ready for download <${BUILD_URL}|here>!\"}" "$SLACK_WEBHOOK_URL" >/dev/null && echo "Successfully notified Slack about the new build!"
fi

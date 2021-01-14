#!/bin/bash
set -x
set -e

find . -name "gstreamer-*.tar.xz"

echo "Renaming asset to a descriptive filename"
export BUILD_TIME=`date +%F_%H-%M-%S`
export FILENAME=/cerbero/gstreamer-1.0-android-universal-$GST_VERSION-${BUILD_TIME}-${DRONE_COMMIT_SHA:0:8}.tar.xz
export FILENAME_RUNTIME=/cerbero/gstreamer-1.0-android-universal-$GST_VERSION-runtime-${BUILD_TIME}-${DRONE_COMMIT_SHA:0:8}.tar.xz
export GST_VERSION=$(./cerbero-uninstalled packageinfo gstreamer-1.0 | grep Version | grep -Eo "[0-9.]+")
mv /cerbero/gstreamer-1.0-android-universal-$GST_VERSION.tar.xz $FILENAME
mv /cerbero/gstreamer-1.0-android-universal-$GST_VERSION-runtime.tar.xz $FILENAME_RUNTIME
echo "New filename: " $FILENAME

echo "Some useful env info"
curl --version
ls -l $FILENAME
ls -l $FILENAME_RUNTIME

echo "Uploading gstreamer android tarballs to Artifactory"
curl --user "ci-cerbero:$ARTIFACTORY_PASSWORD" --upload-file $FILENAME "https://artifactory.mersive.xyz/artifactory/mersive-gstreamer/${DRONE_SOURCE_BRANCH}/"
curl --user "ci-cerbero:$ARTIFACTORY_PASSWORD" --upload-file $FILENAME_RUNTIME "https://artifactory.mersive.xyz/artifactory/mersive-gstreamer/${DRONE_SOURCE_BRANCH}/"

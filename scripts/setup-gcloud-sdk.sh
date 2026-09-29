#!/bin/bash

set -euf -o pipefail

if which gcloud >/dev/null; then
  echo GCloud found, no need to install
else
  export GCLOUD_SDK_PATH=${HOME}/google-cloud-sdk
  export GCLOUD_FILENAME="google-cloud-cli-408.0.1-linux-x86_64.tar.gz"
  export GCLOUD_SHA256="8c07c8eb564e75acda941a37f82a8792cc6ec68757660f3adf0c0bbb1e9cc0a5"
  curl -o ${HOME}/${GCLOUD_FILENAME} https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_FILENAME}
  # Verify before extracting: this runs in jobs that hold the GCP key.
  echo "${GCLOUD_SHA256}  ${HOME}/${GCLOUD_FILENAME}" | sha256sum -c
  cd ${HOME}
  tar zxf ./${GCLOUD_FILENAME}

  echo "Listing the google-cloud-sdk directory"
  ls -la /home/circleci/google-cloud-sdk/

  chmod +x ${GCLOUD_SDK_PATH}/install.sh
  ${GCLOUD_SDK_PATH}/install.sh -q
  # No extra components: these jobs only need auth + configure-docker, and
  # `gcloud components install` would pull artifacts the sha256 above doesn't cover.
  export PATH=${GCLOUD_SDK_PATH}/bin:${PATH}
fi

echo -n ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json
gcloud --quiet config set project ${GOOGLE_PROJECT_ID}
gcloud auth configure-docker --quiet
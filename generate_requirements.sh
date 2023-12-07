#!/bin/bash

#
# This script creates the missing layer zip into the dist directory
#

set -e

START_DIR="${pwd}"
CURRENT_DIRECTORY="$(dirname $(realpath $0))"
OUTPUT_DIRECTORY="${CURRENT_DIRECTORY}/dist"
mkdir -p ${OUTPUT_DIRECTORY}

LAYER_NAME=api-docs-requirements

virtualenv --clear --python=python3.11 "${CURRENT_DIRECTORY}/venv-${LAYER_NAME}";
. "${CURRENT_DIRECTORY}/venv-${LAYER_NAME}/bin/activate" && python -m pip install -r "${CURRENT_DIRECTORY}/src/api-docs/requirements.txt"
deactivate

mkdir -p "/tmp/python"
cd "venv-${LAYER_NAME}/lib/python3.11/site-packages"
cp -r . "/tmp/python/"

cd "/tmp"
zip -r9 "${OUTPUT_DIRECTORY}/${LAYER_NAME}.zip" python

rm -rf "/tmp/python"
rm -rf "${CURRENT_DIRECTORY}/venv-${LAYER_NAME}"
cd "${START_DIR}"

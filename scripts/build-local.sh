#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Set DEVELOPER_DIR when xcode-select points to standalone Command Line Tools.
xcodebuild \
  -workspace SelfControl.xcworkspace \
  -scheme SelfControl \
  -configuration Debug \
  -derivedDataPath build/DerivedData \
  CODE_SIGN_IDENTITY="${SELFCONTROL_SIGN_IDENTITY:-Apple Development}" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM=RSNC24Q9XR \
  GCC_PRECOMPILE_PREFIX_HEADER=NO \
  MACOSX_DEPLOYMENT_TARGET=12.0 \
  build

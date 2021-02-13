CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo "\n${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 [-a app-version]"
  echo "  -a, --app-version   App version no"
  echo "  -b, --build-no      Build no"
  echo "\nExample:\n$0 --app-version 1.2 --build-no 123\n"
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -a|--app-version) APP_VERSION="$2"; shift;shift;;
  -b|--build-no) BUILD_NO="$2"; shift;shift;;
  -v|--verbose) VERBOSE=1;shift;;
  *) usage "Unknown parameter passed: $1"; shift;shift;;
esac; done

# verify params
if [ -z "${APP_VERSION}" ]; then usage "Please specify the app version number to submit"; fi;
if [ -z "${BUILD_NO}" ]; then usage "Please specify the build number to submit"; fi;

cd $(dirname $0)/..
bundle install
bundle exec fastlane submit_for_review app_version:${APP_VERSION} build_no:${BUILD_NO}

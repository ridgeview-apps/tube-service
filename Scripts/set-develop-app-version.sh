CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo "\n${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 [-a app-version]"
  echo "  -a, --app-version   App version no"
  echo "\nExample:\n$0 --app-version 1.2\n"
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -a|--app-version) APP_VERSION="$2"; shift;shift;;
  -v|--verbose) VERBOSE=1;shift;;
  *) usage "Unknown parameter passed: $1"; shift;shift;;
esac; done

# verify params
if [ -z "${APP_VERSION}" ]; then usage "Please specify the app version no"; fi;

cd $(dirname $0)/..
ROOT_PROJECT_DIR=`pwd`
echo "\n *** Setting ROOT_PROJECT_DIR to: ${ROOT_PROJECT_DIR}\n"

echo "\n*** Switching to develop branch ***\n"
git checkout develop && git pull

echo "\n*** Setting the app version on develop no to ${APP_VERSION}.dev ***\n"
bundle install
bundle exec fastlane run increment_version_number version_number:${APP_VERSION}.dev

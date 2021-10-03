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

function commitAndPush() {
    git commit -a -m "Bumped app version no: $APP_VERSION"
    git push origin release/$APP_VERSION
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

echo "\n*** Pulling release and master branches ***\n"
git fetch origin
git checkout develop
git checkout -b release/${APP_VERSION}

echo "\n*** Bumping app version no to ${APP_VERSION} ***\n"
bundle install
bundle exec fastlane run increment_version_number version_number:${APP_VERSION}
git --no-pager diff

while true; do
    read -p "Commit & push release/${APP_VERSION}?:" yn
    case $yn in
        [Yy]* ) commitAndPush; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
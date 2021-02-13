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

function tagAndPush() {
  git push origin master
  git tag -a v${APP_VERSION} -m "Release ${APP_VERSION}" 
  git push origin --tags
  git checkout develop
  git branch -D release/${APP_VERSION}
  git push origin :release/${APP_VERSION}
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

echo "\n*** Merging release/${APP_VERSION} -> master branch ***\n"
git fetch origin
git checkout release/${APP_VERSION} && git branch -u origin/release/${APP_VERSION} && git pull
git checkout master && git branch -u origin/master && git pull
git merge release/${APP_VERSION}

while true; do
    read -p "\n*** Tag the release and push all changes (this will also delete release branches)?:" yn
    case $yn in
        [Yy]* ) tagAndPush; break;;
        [Nn]* ) echo "Please tag and push all changes manually";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
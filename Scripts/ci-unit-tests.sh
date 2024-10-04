export XCODE_CONFIG=Debug

cd $(dirname $0)/..

# Git secret
echo "🔓 Unlocking secrets..."
brew install git-secret
echo -n "$GPG_PRIVATE_KEY" | base64 --decode | gpg --import
git secret reveal

bundle install
bundle update fastlane
bundle exec fastlane unit_tests
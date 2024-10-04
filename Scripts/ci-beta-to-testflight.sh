export XCODE_CONFIG=Beta

cd $(dirname $0)/..

# Git secret
echo "🔓 Unlocking secrets..."
brew install git-secret
echo -n "$GPG_PRIVATE_KEY" | base64 --decode | gpg --import
git secret reveal

bundle install
bundle update fastlane
# bundle exec fastlane unit_tests
bundle exec fastlane add_badge_overlay
bundle exec fastlane build
bundle exec fastlane distribute
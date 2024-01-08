cd $(dirname $0)/..
bundle install
bundle exec fastlane upload_screenshots

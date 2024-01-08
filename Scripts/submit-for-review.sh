cd $(dirname $0)/..
bundle install
bundle exec fastlane submit_for_review

#!/bin/sh

echo "//"
echo "// *******************************"
echo "// Generated file - DO NOT EDIT"
echo "// *******************************"
echo "//"
echo "// This file should be git-ignored"
echo "//"

echo "\nimport Foundation\n"

echo "enum BuildSettings { \n"

env |\
grep "APP_SETTING_" | \
sed "s/APP_SETTING_/    static let /" |\
sed -E 's/=(.*)/ = "\1"/' | \
sed -E 's/"http.*/URL(string: &)!/'

echo "\n}"

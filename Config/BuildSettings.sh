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
grep "codeConstant_" | \
sed "s/codeConstant_/    static let /" |\
sed -E 's/=(.*)/ = "\1"/' | \
sed -E 's/"http.*/URL(string: &)!/'

echo "\n}"

#!/bin/bash
set -e

# Ensure we're in the project directory
cd "$(dirname "$0")"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: You have uncommitted changes. Commit them first."
    exit 1
fi

# Get version bump type (patch, minor, major)
VERSION_TYPE=${1:-patch}

echo "Building..."
npm run build

echo "Bumping version ($VERSION_TYPE)..."
npm version $VERSION_TYPE

echo "Pushing to git..."
git push && git push --tags

echo "Publishing to npm..."
npm publish --auth-type=web

VERSION=$(node -p "require('./package.json').version")
echo "Done! Published v$VERSION"

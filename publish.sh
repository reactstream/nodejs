#!/bin/bash
# publish.sh - Script for updating version and publishing to npm

# Ensure script fails on any error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting publication process...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check requirements
if ! command_exists npm; then
    echo -e "${RED}Error: npm is not installed${NC}"
    exit 1
fi

if ! command_exists git; then
    echo -e "${RED}Error: git is not installed${NC}"
    exit 1
fi

# Clean build artifacts
echo -e "${BLUE}Cleaning previous build artifacts...${NC}"
rm -rf node_modules/.cache
rm -rf dist
rm -rf build
rm -rf .reactstream

# Check if we're in a clean git state
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}Warning: Git working directory is not clean${NC}"
    echo "You may want to commit your changes first"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Publication aborted${NC}"
        exit 1
    fi
fi

# Get current version from package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo -e "${BLUE}Current version: ${YELLOW}$CURRENT_VERSION${NC}"

# Default to patch version update
VERSION_TYPE="patch"

# Check if version type is specified as argument
if [ "$1" != "" ]; then
    case $1 in
        patch|minor|major)
            VERSION_TYPE="$1"
            ;;
        *)
            echo -e "${RED}Invalid version type: $1${NC}"
            echo "Valid options are: patch, minor, major"
            exit 1
            ;;
    esac
else
    # Ask for version type if not provided as argument
    echo -e "${BLUE}What kind of version update is this?${NC}"
    echo "1) patch (bug fixes) [DEFAULT]"
    echo "2) minor (new features)"
    echo "3) major (breaking changes)"
    echo "4) custom (specify version)"
    read -p "Enter your choice [1-4] or press Enter for patch: " VERSION_CHOICE

    # Default to patch if no input
    VERSION_CHOICE=${VERSION_CHOICE:-1}

    case $VERSION_CHOICE in
        1|"")
            VERSION_TYPE="patch"
            ;;
        2)
            VERSION_TYPE="minor"
            ;;
        3)
            VERSION_TYPE="major"
            ;;
        4)
            read -p "Enter custom version (e.g., 1.2.3): " CUSTOM_VERSION
            VERSION_TYPE="$CUSTOM_VERSION"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
fi

# Update version in package.json
if [[ $VERSION_CHOICE -eq 4 ]]; then
    echo -e "${BLUE}Setting version to ${YELLOW}$VERSION_TYPE${NC}"
    npm version $VERSION_TYPE --no-git-tag-version
else
    echo -e "${BLUE}Updating ${YELLOW}$VERSION_TYPE${NC} version"
    npm version $VERSION_TYPE --no-git-tag-version
fi

# Get new version from package.json
NEW_VERSION=$(node -p "require('./package.json').version")
echo -e "${GREEN}Updated version: ${YELLOW}$NEW_VERSION${NC}"

# Run linting
echo -e "${BLUE}Running linting...${NC}"
npm run lint || {
    echo -e "${YELLOW}Linting found issues.${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Publication aborted${NC}"
        exit 1
    fi
}

# Commit changes
echo -e "${BLUE}Committing version update...${NC}"
git add package.json package-lock.json
git commit -m "Version bump to $NEW_VERSION"

# Create git tag
echo -e "${BLUE}Creating git tag v$NEW_VERSION...${NC}"
git tag -a "v$NEW_VERSION" -m "Version $NEW_VERSION"

# Push to GitHub
echo -e "${BLUE}Pushing changes and tags to GitHub...${NC}"
git push origin main
git push origin --tags

# Publish to npm
echo -e "${BLUE}Publishing to npm...${NC}"
npm publish --access=public

echo -e "${GREEN}Successfully published version $NEW_VERSION${NC}"

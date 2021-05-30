#!/bin/sh

set -e

error() {
  echo "🚨 $1"
  exit 1
}

is_valid_version() {
  case $1 in
  patch) ;;
  minor) ;;
  major) ;;
  *) error "🚨 Invalid version >> $1" ;;
  esac
}

assert_ready_to_publish() {
  is_valid_version "$1"
  if [ ! -d dist ]; then
    error "Need build first"
  fi
}

# TODO cleanup the dist folder to publish
prepare_folder() {
  echo "Prepare folder"
  #  rm dist/tsc/**/*.js*
  mkdir dist/types
  cp dist/tsc/**/*.d.ts dist/types
}

publish() {
  echo "Publish $1"
  npm publish "$1"
}

NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
  while true; do
    echo "Specify an version increase (patch minor major) "
    read -r answer
    case $answer in
    patch)
      NEW_VERSION="patch"
      break
      ;;
    minor)
      NEW_VERSION="minor"
      break
      ;;
    major)
      NEW_VERSION="major"
      break
      ;;
    *)
      echo "Only patch minor or major, please."
      ;;
    esac
  done
fi

assert_ready_to_publish $NEW_VERSION
prepare_folder
#publish $NEW_VERSION

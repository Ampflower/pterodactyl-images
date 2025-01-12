#!/usr/bin/env bash

# Ensures the build folder exists.
mkdir -p build

# Hardlinks the entrypoint into the build folder so Docker can find it.
ln -f entrypoint.sh build/entrypoint.sh

# Determine the Java package to get; argument 1 must be set.
case $1 in
  8-jre)openjdk="openjdk-8-jre-headless";;
  8-jdk)openjdk="openjdk-8-jdk-headless";;
  11-jre)openjdk="openjdk-11-jre-headless";;
  11-jdk)openjdk="openjdk-11-jdk-headless";;
  17-jre)openjdk="openjdk-17-jre-headless";;
  17-jdk)openjdk="openjdk-17-jdk-headless";;
  *)echo "Unknown OpenJDK variant $1";exit 1;;
esac

# Replace @OPENJDK@ with the package and create a new docker file in build.
sed -e "s/@OPENJDK@/$openjdk/g" < Dockerfile > build/Dockerfile
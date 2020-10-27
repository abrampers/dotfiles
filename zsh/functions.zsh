jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  if [ -z "$2" ]; then
    java -version
  fi
}


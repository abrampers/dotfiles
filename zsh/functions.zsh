jdk() {
  version=$1
  export java_home=$(/usr/libexec/java_home -v"$version");
  if [ -z "$2" ]; then
    java -version
  fi
}


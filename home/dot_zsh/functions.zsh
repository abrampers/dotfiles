jdk() {
  if [[ "list" == $1 ]]; then
    /usr/libexec/java_home -V
  else
    version=$1
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    if [ -z "$2" ]; then
      java -version
    fi
  fi

}


# Open a frame of the single Emacs server (started at login) on a path.
ec() {
  emacsclient -c -n -a '' "${@:-.}"
}

# Write a git-ignored .envrc based on what the repo contains, then allow it.
envrc-init() {
  local f=.envrc
  : > $f
  [[ -f go.mod ]] && echo 'use gvm_project' >> $f
  [[ -f .nvmrc ]] && echo 'use nvm_project' >> $f
  [[ -f project.clj || -f deps.edn || -f pom.xml || -f build.gradle ]] && echo 'use jdk_project' >> $f
  if [[ ! -s $f ]]; then
    echo "envrc-init: no go.mod/.nvmrc/JDK project file found; nothing written."
    rm -f $f; return 1
  fi
  direnv allow
}

toolchain-install() {
  "$HOME/.scripts/toolchain-install" "$@"
}

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Editor
export EDITOR='nvim'

# GO
export GOPATH=$HOME/Go

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export JUNIT_HOME=/Library/JUNIT
export JDEPEND_HOME=/Library/jdepend-2.9.1
export CLASSPATH=$CLASSPATH:$JUNIT_HOME/junit-4.10.jar:.
export CLASSPATH=$CLASSPATH:$JDEPEND_HOME/lib/jdepend-2.9.1.jar

# Maven
export M2_HOME=/usr/local/apache-maven/apache-maven-3.5.3
export M2=$M2_HOME/bin
export MAVEN_OPTS=-Xms256m #-Xmx512m

export PGDATABASE=postgres

# Kubernetes Editor
export KUBE_EDITOR="nvim"

# Sqlite
export LDFLAGS="-L/usr/local/opt/sqlite/lib"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

# Locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export CLICOLOR=true
#!/usr/bin/env bash

print_warning()
{
  printf "
[0;33mWarning[0m: $1
"
}

print_error_and_exit()
{

  printf "
[0;31mError[0m: $1
"
  seed_print_usage
  exit 1
}

seed_initialize_installer()
{
  [ ! -z $SEED_EXECUTABLE_NAME ] || SEED_EXECUTABLE_NAME=seed
  [ ! -z $SEED_SOURCE_REPO     ] || SEED_SOURCE_REPO=git@github.com:sublimeguile/seed.git
  [ ! -z $SEED_REPO_DIR        ] || SEED_REPO_DIR=$HOME/.seed
  [ ! -z $SEED_BIN_DIR         ] || SEED_BIN_DIR=/usr/local/bin
  [ ! -z $SEED_EXECUTABLE      ] || SEED_EXECUTABLE=$SEED_BIN_DIR/$SEED_EXECUTABLE_NAME
}

seed_echo_config()
{
  echo "SEED_EXECUTABLE_NAME: $SEED_EXECUTABLE_NAME"
  echo "SEED_SOURCE_REPO:     $SEED_SOURCE_REPO"
  echo "SEED_REPO_DIR:        $SEED_REPO_DIR"
  echo "SEED_BIN_DIR:         $SEED_BIN_DIR"
  echo "SEED_EXECUTABLE:      $SEED_EXECUTABLE"
}


seed_clone_repo()
{
  if
    [[ -d $SEED_REPO_DIR ]]
  then
    print_warning "$SEED_EXECUTABLE_NAME repo already exists at [0;32m$SEED_REPO_DIR[0m"
  else
    git clone $SEED_SOURCE_REPO $SEED_REPO_DIR
  fi
}

seed_print_usage()
{
  printf "
  To update seed:
    $ $SEED_EXECUTABLE_NAME update

  To reinstall seed:
    $ $SEED_EXECUTABLE_NAME reinstall

  To uninstall seed:
    $ $SEED_EXECUTABLE_NAME reinstall

"
}

seed_add_to_bin()
{
  if [ ! -e "$SEED_EXECUTABLE" ] || [ "$OVERWRITE_EXECUTABLE" == "true" ]
  then
    printf "#!/usr/bin/env bash

# Get config from the initial install:
SEED_EXECUTABLE_NAME=$SEED_EXECUTABLE_NAME
SEED_REPO_DIR=$SEED_REPO_DIR
SEED_EXECUTABLE=$SEED_EXECUTABLE
SEED_INSTALLER=$SEED_REPO_DIR/install.sh
SEED_TEMPLATE=$SEED_REPO_DIR/seed.rb

export SEED_DIR=\$SEED_REPO_DIR

case \"\$1\" in
  update)
    echo \"Updating [0;32m\$SEED_REPO_DIR[0m...\"
    cd \$SEED_REPO_DIR
    git pull
    \$SEED_INSTALLER update
    ;;
  uninstall)
    echo \"
To uninstall, just remove:
    \$SEED_REPO_DIR
    \$SEED_EXECUTABLE
\"
    ;;
  new)
    echo \"[0;34mRunning:[0m rails new \$2 -m \$SEED_TEMPLATE\"
    rails new \$2 -m \$SEED_TEMPLATE
    ;;
esac

" > $SEED_EXECUTABLE

    chmod +x $SEED_EXECUTABLE

    printf "
[0;32m$SEED_EXECUTABLE_NAME[0m installed at [0;32m$SEED_EXECUTABLE[0m

"
  else
    print_error_and_exit "$SEED_EXECUTABLE_NAME already installed at $SEED_EXECUTABLE"
  fi
}

seed_install()
{
  #seed_echo_config
  seed_initialize_installer
  seed_clone_repo
  seed_add_to_bin
}

seed_update()
{
  seed_initialize_installer
  OVERWRITE_EXECUTABLE=true
  seed_add_to_bin
}

case "$1" in
  update)
    seed_update
    ;;
  *)
    seed_install "$@"
    ;;
esac

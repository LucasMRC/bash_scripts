#!/bin/bash

#############################
# :Warning: In order for any
# of this to work, you will
# need npm installed.
############################

# Default AEM project root folder
AEM_ROOT="<<PROJECT_FOLDER>>"

# This will set the root folder from where the aemx script will push the content.
# It's useful for when you have to switch between aem repos.
aemroot() {
    AEM_ROOT=$(pwd)
}

# This function is in charge of pushing folders from the AEM_ROOT project
# to the AEM instance.
#
# - `aemx apps blog` will push the `blog` folder from inside the
# `ui.apps/.../jcr_root/apps/` folder.
#
# - `aemx content dam` will push the `dam` folder from inside the
# `ui.content/.../jcr_root/content/` folder
#
# - `aemx config blog` will push the `blog` folder from inside the
# `ui.content/.../jcr_root/conf/` folder
#
# Those are actually the more common use cases. If the codebase or you
# just want to be more specific about which folder to push, you can do something
# like
# - `aemx apps blog/components/content/separator`

aemx() {
    while getopts ":h" option; do
        case $option in
            h) # Display Help
               echo "Pushes folders to a local AEM instance"
               echo
               echo "Syntax: aemx [apps|content|config] <path-to-folder>"
               echo
               echo "The path to folder must be written without the precedent"
               echo "forward slash."
               echo "For more indications on how to use this utility, read the"
               echo "comments in the script."
               echo
               echo "options:"
               echo "-h     Print this Help."
               echo
               ;;
        esac
    done
    case $1 in
        content)
            CONTENT_FOLDER=$AEM_ROOT/ui.content/src/main/content/jcr_root/content
            npx aemsync -v -p "$CONTENT_FOLDER/$2";;
        apps)
            APPS_FOLDER="$AEM_ROOT/ui.apps/src/main/content/jcr_root/apps"
            npx aemsync -v -p "$APPS_FOLDER/$2";;
        config)
            CONFIG_FOLDER="$AEM_ROOT/ui.content/src/main/content/jcr_root/conf"
            npx aemsync -v -p "$CONFIG_FOLDER/$2";;
    esac
}

# This npm package syncs the local folder with the AEM repo, so any changes happening
# inside a `jcr_root` folder will be automatically pushed to the instance on save.
# It will try to find some jcr_root folder on launch, so it's better to run it inside
# the project you are working on.
# If you have multiple projects in the same folder, this will sync changes on all of
# them.
alias aemsync="npx aemsync"

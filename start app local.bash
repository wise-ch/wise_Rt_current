#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

Rscript -e "shiny::runApp('app', launch.browser = TRUE)"
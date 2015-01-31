#!/bin/bash

set -e

declare -r log_dir=/var/log/ghostbusters15
declare -r log_file_basename="fix-GHOST_CVE-2015-0235-update-packages"
declare -r target_package_name='glibc*'

exec 1> >(tee "${log_dir}/${log_file_basename}-stdout.log")
exec 2> >(tee "${log_dir}/${log_file_basename}-stderr.log")
  
# check for update
cat << __EOD__
# --------------------
# check for update
# --------------------
__EOD__
sudo yum -v clean all
declare es=0
sudo yum -v check-update "${target_package_name}" || es=$?

case $es in

  0 ) # latest packages installed
    cat << __EOD__
# --------------------
# no packages available for an update
# --------------------
__EOD__
    ;;

  100 ) # packages available for an update
    # yum update
    cat << __EOD__
# --------------------
# yum update
# --------------------
__EOD__

    sudo yum --assumeyes update "${target_package_name}"
    es=$?
    ;;

  * ) exit $es ;;

esac

exit $es


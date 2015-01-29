#!/bin/bash

set -e

declare -r log_dir=/var/log/ghostbusters15
declare -r log_file_basename="fix-GHOST_CVE-2015-0235-check-installed-packages"
declare -r target_package_name='glibc*'

exec 1> >(tee "${log_dir}/${log_file_basename}-stdout.log")
exec 2> >(tee "${log_dir}/${log_file_basename}-stderr.log")

function query_packages {

  echo "check for installed packages ... : '${target_package_name}' via RPM Package Manager"

  local -r __IFS="$IFS"

  IFS=$'\n' # edit IFS temporary
  local -r target_packages=$(rpm -qa "${target_package_name}")
  local -ar target_packages_a=( ${target_packages} )

  cat << __EOD__

# --------------------"
# ${#target_packages_a[*]} packages found"
${target_packages}"
# --------------------"
__EOD__

  for pkg in "${target_packages_a[@]}"; do
    echo
    rpm -qi "${pkg}"
  done
  IFS="$__IFS" # revert to original IFS

}

# query for installed packages
query_packages


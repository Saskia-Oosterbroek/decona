#!/bin/bash
set -Eeuo pipefail

function usage {
    echo "Installs Decona and its dependencies in a Python (conda) environment."
    echo
    echo "Specify either a prefix (i.e. install directory) to install to a"
    echo "custom location. Or specify an environment name to install to the"
    echo "default location with this name."
    echo
    echo "Specifying neither installs the environment to the default location"
    echo "with the name 'decona'."
    echo
    echo "Options:"
    echo "    -p, --prefix    Directory to install Decona in"
    echo "    -n, --name      Name of the environment to create"
    echo "    -h, --help      Show this message"
}

function check_git {
  if ! command -v git &> /dev/null; then
    echo "Could not find 'git' command, please install it (in Ubuntu: sudo apt install git)."
    exit 2
  fi
}

function check_cdhit_dependencies {
  # We need a C++ compiler and zlib.
  if ! command -v g++ &> /dev/null; then
    echo "Could not find 'g++' command, please install it (in Ubuntu: sudo apt install g++)."
    exit 2
  fi
  # Attempt to compile a small test program that includes a zlib header and
  # try to link zlib (with -lz option to g++). If this fails, we cannot build CD-HIT.
  program=$'#include <zlib.h>\nint main() {}'
  if ! echo "$program" | g++ -o /dev/null -lz -x c++ - > /dev/null; then
    echo "Could not find 'zlib' library, please install it (in Ubuntu: sudo apt install zlib1g-dev)."
    exit 79
  fi
}

# Parse input arguments
name=''
prefix=''
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -p|--prefix)
      prefix="$2"
      shift
      shift
      ;;
    -n|--name)
      name="$2"
      shift
      shift
      ;;
    -*)
      echo "Invalid command line option: '$1'"
      exit 1
      ;;
  esac
done

if [ -n "$name" ] && [ -n "$prefix" ]; then
    echo "Specify either a name or a prefix, but not both."
    exit 1
fi

if [ -z "$name" ]; then
    name='decona'
fi

# Check for potential errors before we start.
if ! type conda &> /dev/null; then
    echo "Please install Miniconda (https://docs.conda.io/en/latest/miniconda.html), and make sure it is on your PATH and initialised." >&2
    exit 2
fi
if [ -d "$prefix" ]; then
    echo "Install directory '$prefix' already exists, please select another directory with -p <directory> or --prefix <directory>." >&2
    exit 17
fi
if conda env list | grep -qE "(^|[[:space:]]+)$name\*?([[:space:]]+|$)"; then
    echo "Environment with the name '$name' already exists, please specify a custom environment name or prefix." >&2
    exit 17
fi

# Get the location of this script's path to determine where we find the environment definition and the decona executable.
script_path=$(dirname "$(realpath "$0")")

echo "Creating Conda environment and installing packages, this might take some time..."
env_file="$script_path/decona.yml"
if [ -z "$prefix" ]; then
    # Use conda's default environment location.
    conda create medaka=1.11.3 python=3.8.10 cutadapt=4.8 racon=1.4.20 NanoFilt=2.8.0 cd-hit=4.8.1 blast=2.15.0 --channel conda-forge --channel bioconda --name "$name" > /dev/null
    # Get the path of the newly created environment.
    prefix=$(conda env list | grep -Po "(?<=$name).*$" | tr -d ' ')
    activation_name="$name"
else
    # Create environment in the specified location.
    conda create --prefix "$prefix" medaka=1.11.3 python=3.8.10 cutadapt=4.8 racon=1.4.20 NanoFilt=2.8.0 cd-hit=4.8.1 blast=2.15.0 --channel conda-forge --channel bioconda > /dev/null
    activation_name="$prefix"
fi

echo "Integrating Decona with the Python environment..."
ln -s "$script_path/../decona" "$prefix/bin/decona"

echo "Installed Decona and created a new Python environment; use 'conda activate $activation_name' to activate it, then run 'decona'."

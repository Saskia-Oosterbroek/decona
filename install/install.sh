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

# Build CD-HIT before trying to make the environment, we want to see any errors from this build before starting the
# lengthy process of generating an Anaconda environment.
echo "Building CD-HIT..."
cd_hit_path="$script_path/../external/cdhit"
cd "$cd_hit_path" && make > /dev/null
if [ $? != 0 ]; then
    echo "Failed to build CD-HIT, did you clone the repository without --recurse-submodules?"
    echo "In that case, try running 'git submodule update --init' to also retrieve CD-HIT."
fi

echo "Creating Python environment and installing packages, this might take a long time..."
env_file="$script_path/decona.yml"
if [ -z "$prefix" ]; then
    # Use conda's default environment location.
    conda env create -f "$env_file" --name "$name" > /dev/null
    # Get the path of the newly created environment.
    prefix=$(conda env list | grep -Po "(?<=$name).*$" | tr -d ' ')
    activation_name="$name"
else
    # Create environment in the specified location.
    conda env create --prefix "$prefix" -f "$env_file" > /dev/null
    activation_name="$prefix"
fi

echo "Integrating CD-HIT and Decona with the Python environment..."
ln -s "$script_path/../decona" "$prefix/bin/decona"

# The following CD-HIT executables are used in Decona.
ln -s "$script_path/../external/cdhit/cd-hit-est" "$prefix/bin"
ln -s "$script_path/../external/cdhit/plot_len1.pl" "$prefix/bin"
ln -s "$script_path/../external/cdhit/make_multi_seq.pl" "$prefix/bin"

echo "Installed Decona and created a new Python environment; use 'conda activate $activation_name' to activate it, then run 'decona'."

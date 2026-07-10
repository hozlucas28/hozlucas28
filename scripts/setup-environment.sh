#! /bin/bash

# Parse options
options=$(getopt -o "s:h" --long "system:,help" -- "$@")

if [ $? -ne 0 ]; then
	echo -e "\e[31mAn error occurred on parsing options.\e[0m" >&2
	exit 1
fi

eval set -- "$options"

while true; do
	case "$1" in
		"-s" | "--system")
			system="$2"
			shift 2
			;;

		"-h" | "--help")
			need_help="true"
			shift 1
			break
			;;

		"--")
			shift
			break
			;;

		*)
			echo -e "\e[31mAn internal error occurred!\e[0m" >&2
			exit 1
			;;
	esac
done

# Show help if needed
if [[ -n "$need_help" ]]; then
	printf "Usage: $0 [OPTIONS]...

Set up all the tools and configurations needed for a new machine.

Options:
	-s, --system     'windows', 'macos', or 'linux' (required)
	-h, --help       display this help and exit
"
	exit 0
fi

# Validate system option
if [[ -z "$system" ]]; then
	echo -e "\e[31m\`-s\` | \`--system\` option is required.\e[0m" >&2
	exit 1
elif [[ "$system" != "windows" && "$system" != "macos" && "$system" != "linux" ]]; then
	echo -e "\e[31mInvalid \`-s\` | \`--system\` option. It's value must be 'windows', 'macos', or 'linux'.\e[0m" >&2
	exit 1
fi

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	echo -e "\e[31mFailed to change directory to project root.\e[0m" >&2
	exit 1
fi

# Exit on any command failure
set -e

# Install tools and set configurations
case "$system" in
	"windows")
		# TODO: Tools installation for Windows
		# Git
		cp git/.gitconfig ~/.gitconfig
		cp git/.gitconfig-windows.local ~/.gitconfig.local
        echo -e "\e[32m- Git configured.\e[0m"
		;;

	"macos" | "linux")
		# TODO: Tools installation for macOS and Linux
		# Git
		cp git/.gitconfig ~/.gitconfig
		cp git/.gitconfig-macos.local ~/.gitconfig.local
        echo -e "\e[32m- Git configured.\e[0m"
		;;
esac

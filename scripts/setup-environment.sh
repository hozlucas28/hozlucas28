#! /bin/bash

# Parse options
while [[ $# -gt 0 ]]; do
	case "$1" in
		-s | --system)
			system="$2"
			shift 2
			;;

		-s=* | --system=*)
			system="${1#*=}"
			shift 1
			;;

		-h | --help)
			need_help='true'
			shift 1
			break
			;;

		--)
			shift 1
			break
			;;

		-*)
			printf "\e[31mAn invalid option was found!\e[0m\n" >&2
			exit 1
			;;
            
        *)
            break
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
	printf "\e[31m\`-s\` | \`--system\` option is required.\e[0m\n" >&2
	exit 1
elif [[ "$system" != "windows" && "$system" != "macos" && "$system" != "linux" ]]; then
	printf "\e[31mInvalid \`-s\` | \`--system\` option. It's value must be 'windows', 'macos', or 'linux'.\e[0m\n" >&2
	exit 1
fi

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	printf "\e[31mFailed to change directory to project root.\e[0m\n" >&2
	exit 1
fi

# Exit on any command failure
set -e

# Install tools and set configurations
case "$system" in
	windows)
		# TODO: Tools installation for Windows
		# Git
		cp git/.gitconfig ~/.gitconfig
		cp git/.gitconfig-windows.local ~/.gitconfig.local
        printf "\e[32m- Git configured.\e[0m\n"
		;;

	macos | linux)
		# TODO: Tools installation for macOS and Linux
		# Git
		cp git/.gitconfig ~/.gitconfig
		cp git/.gitconfig-macos.local ~/.gitconfig.local
        printf "\e[32m- Git configured.\e[0m\n"
		;;
esac

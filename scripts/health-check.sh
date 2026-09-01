#! /bin/bash

# Parse options
while [[ $# -gt 0 ]]; do
	case "$1" in
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

Perform a health check of the tools needed to this project.

Options:
	-h, --help     display this help and exit
"
	exit 0
fi

# Gets command version
command_version() {
	local version

	if version=$("$@" 2> /dev/null); then
		echo "v$(echo "$version" | grep -E -o '[0-9]+(\.[0-9]+){0,2}' | head -n 1)"
	else
		return 1
	fi
}

# Change from script directory to project root directory
cd $(cd "$(dirname "$0")/.." && pwd)

if [[ $? -ne 0 ]]; then
	printf "\e[31mFailed to change directory to project root.\e[0m\n" >&2
	exit 1
fi

# Exit on any command failure
set -e

exit_code=0


if command -v uv > /dev/null 2>&1; then
	printf "\e[32m- uv $(command_version uv --version) installed.\e[0m\n"
else
	printf "\e[31m- uv is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v python > /dev/null 2>&1; then
	printf "\e[32m- Python $(command_version python --version) installed.\e[0m\n"
else
	printf "\e[31m- Python is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v fnm > /dev/null 2>&1; then
	printf "\e[32m- fnm $(command_version fnm --version) installed.\e[0m\n"
else
	printf "\e[31m- fnm is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v node > /dev/null 2>&1; then
	printf "\e[32m- Node.js $(command_version node --version) installed.\e[0m\n"
else
	printf "\e[31m- Node.js is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v ruff > /dev/null 2>&1; then
	printf "\e[32m- Ruff $(command_version ruff --version) installed.\e[0m\n"
else
	printf "\e[31m- Ruff is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v zizmor > /dev/null 2>&1; then
	printf "\e[32m- Zizmor $(command_version zizmor --version) installed.\e[0m\n"
else
	printf "\e[31m- Zizmor is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v rendercv > /dev/null 2>&1; then
	printf "\e[32m- RenderCV $(command_version rendercv --version) installed.\e[0m\n"
else
	printf "\e[31m- RenderCV is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v oxfmt > /dev/null 2>&1; then
	printf "\e[32m- Oxfmt $(command_version oxfmt --version) installed.\e[0m\n"
else
	printf "\e[31m- Oxfmt is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v lefthook > /dev/null 2>&1; then
	printf "\e[32m- Lefthook $(command_version lefthook --version) installed.\e[0m\n"
else
	printf "\e[31m- Lefthook is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi

if command -v gh > /dev/null 2>&1; then
	printf "\e[32m- GitHub CLI $(command_version gh --version) installed.\e[0m\n"
else
	printf "\e[31m- GitHub CLI is not installed or not found in PATH.\e[0m\n" >&2
	exit_code=1
fi


exit $exit_code

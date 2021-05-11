#!/bin/sh
# This script is intended to be fully posix compliant.

error() {
	printf "%s" "$1"
	exit 1
}

# Go to home.
script_path=$(readlink -f "$0")
home_dir=$(dirname "$(dirname "$script_path")")
cd "$home_dir" || error "could not go to home"

files="$1"
modified() {
	case "$files" in
	*$1*) return 1 ;;
	*) return 0 ;;
	esac
}

modified ".go" || (
	printf "lint go\\n"
	./utils/lint-go.sh || error "lint go failed"

	printf "test go\\n"
	./utils/test-go.sh || error "test go failed"
)

modified ".sh" || (
	printf "lint shell\\n"
	./utils/lint-shell.sh || error "lint shell failed"
)

modified ".js$" || (
	npm run lint-js || error "lint js failed"
	printf "test js\\n"
	./utils/test-js.sh || error "test js failed"

)

modified ".css" || (
	npm run lint-css || error "lint css failed"
)

printf "all passed!\\n"

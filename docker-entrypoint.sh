#!/bin/bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		file_env_error "Both $var and $fileVar are set (but are exclusive)"
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env_error() {
	echo ERROR "$@" >&2
	exit 1
}

docker_setup_env() {

	# Initialize values that might be stored in a file
    file_env 'DB_HOST'
    file_env 'DB_NAME'
    file_env 'DB_USER'
    file_env 'DB_PASS'

}

docker_setup_env

gunicorn -w 4 -b 0.0.0.0:5000 app:app

#!/usr/bin/env sh
set -eu

OPTIONS=/data/options.json

json() {
  jq -r "$1 // empty" "${OPTIONS}"
}

export DATABASE_USER="$(json '.database_user')"
export DATABASE_PASS="$(json '.database_pass')"
export DATABASE_NAME="$(json '.database_name')"
export DATABASE_HOST="$(json '.database_host')"
export DATABASE_PORT="$(json '.database_port')"
export DATABASE_SSL="$(json '.database_ssl')"
export DATABASE_TIMEOUT="$(json '.database_timeout')"
export ENCRYPTION_KEY="$(json '.encryption_key')"
export MQTT_HOST="$(json '.mqtt_host')"
export MQTT_PORT="$(json '.mqtt_port')"
export MQTT_USERNAME="$(json '.mqtt_user')"
export MQTT_PASSWORD="$(json '.mqtt_pass')"
export MQTT_TLS="$(json '.mqtt_tls')"
export MQTT_NAMESPACE="$(json '.mqtt_namespace')"
export DISABLE_MQTT="$(json '.disable_mqtt')"
export TESLAMATE_HOST="$(json '.teslamate_host')"
export TESLAMATE_PORT="$(json '.teslamate_port')"
export TESLAMATE_SSL="$(json '.teslamate_ssl')"
export TZ="$(json '.timezone')"
export API_TOKEN="$(json '.api_token')"
export API_TOKEN_DISABLE="$(json '.api_token_disable')"
export DEBUG_MODE="$(json '.debug_mode')"
export ENABLE_COMMANDS="$(json '.enable_commands')"
export COMMANDS_ALL="$(json '.commands_all')"

exec /opt/app/app

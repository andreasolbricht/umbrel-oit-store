# Sourced by Umbrel before compose. Do not put tokens or other secrets here.
# Umbrel replaces this file on update. Set HA_TOKEN and the other app tokens
# in the Umbrel app settings, which inject them into the terminal service.

if [ ! -S /var/run/docker.sock ]; then
  echo "oit-open-terminal: /var/run/docker.sock is not a socket" >&2
  exit 1
fi

DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || true)
case "${DOCKER_SOCK_GID}" in
  ''|*[!0-9]*)
    echo "oit-open-terminal: could not read a numeric group from /var/run/docker.sock" >&2
    exit 1
    ;;
esac
export DOCKER_SOCK_GID

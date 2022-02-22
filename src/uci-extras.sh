# Configure profile
mkdir -p /etc/profile.d
cat << "EOF" > /etc/profile.d/uci.sh
uci() {
local UCI_CMD="${1}"
case "${UCI_CMD}" in
(validate|diff) uci_"${@}" ;;
(*) command uci "${@}" ;;
esac
}

uci_validate() {
local UCI_CONF="${@:-/etc/config/*}"
for UCI_CONF in ${UCI_CONF}
do if ! uci show "${UCI_CONF}" > /dev/null
then echo "${UCI_CONF}"
fi
done
}

uci_diff() {
local UCI_OCONF="${1:?}"
local UCI_NCONF="${2:-${1}-opkg}"
local UCI_OTEMP="$(mktemp -t uci.XXXXXX)"
local UCI_NTEMP="$(mktemp -t uci.XXXXXX)"
uci export "${UCI_OCONF}" > "${UCI_OTEMP}"
uci export "${UCI_NCONF}" > "${UCI_NTEMP}"
diff -a -b -d -y "${UCI_OTEMP}" "${UCI_NTEMP}"
rm -f "${UCI_OTEMP}" "${UCI_NTEMP}"
}
EOF
. /etc/profile.d/uci.sh

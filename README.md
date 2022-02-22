# uci-extras
uci-extas.sh
Originaly proposed by @vgaetera

REFS:
- https://openwrt.org/license
- https://openwrt.org/docs/guide-user/advanced/uci_extras

====== UCI extras ======
{{section>meta:infobox:howto_links#cli_skills&noheader&nofooter&noeditbutton}}

===== Introduction =====
  * This instruction extends the functionality of [[docs:guide-user:base-system:uci|UCI]].
  * Follow the [[docs:guide-user:advanced:uci_extras#automated|automated]] section for quick setup.

===== Features =====
  * Validate and compare UCI configurations.

===== Implementation =====
  * Wrap UCI calls to provide a seamless invocation method.
  * Rely on [[docs:guide-user:base-system:uci|UCI]] to validate configurations.
  * Rely on [[man>diff(1)|diff]] to identify configuration changes.

===== Commands =====
| Sub-command | Description |
| --- | --- |
| ''**validate** [<confs>]'' | Validate UCI configurations. |
| ''**diff** <oldconf> [<newconf>]'' | Compare UCI configurations, requires [[packages:pkgdata:diffutils]]. |

===== Instructions =====
```
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
```
  
===== Examples =====
```
  # Install packages
opkg update
opkg install diffutils

# Validate UCI configurations
uci validate

# Compare UCI configurations
opkg newconf
uci diff dhcp
```
  
===== Automated =====
```
uclient-fetch -O uci-extras.sh "https://openwrt.org/_export/code/docs/guide-user/advanced/uci_extras?codeblock=0"
. ./uci-extras.sh
```

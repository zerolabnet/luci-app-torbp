# Copyright 2018-2020 Alex D (https://gitlab.com/Nooblord/)
# Copyright 2022 ZeroChaos (https://github.com/zerolabnet/)
# Copyright 2023 Daixiao
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-torbp
PKG_VERSION:=1.1
PKG_RELEASE:=1
PKG_MAINTAINER:=Daixiao <dx20100505@gmail.com>

LUCI_TITLE:=LuCI support for torbp
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+tor +tor-geoip +obfs4proxy
  
define Package/$(PKG_NAME)/description
Tor with SOCKS 5 proxy with a UI for the ability to add bridges
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/torbp
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	# Copy config
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/torbp $(1)/etc/config/torbp

	# Copy LuCI Description and ACL
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./files/usr/share/luci/menu.d/luci-app-torbp.json \
	$(1)/usr/share/luci/menu.d/luci-app-torbp.json
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/usr/share/rpcd/acl.d/luci-app-torbp.json \
	$(1)/usr/share/rpcd/acl.d/luci-app-torbp.json

	# Copy web stuff
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/torbp.lua \
	$(1)/usr/lib/lua/luci/controller/torbp.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/torbp.lua \
	$(1)/usr/lib/lua/luci/model/cbi/torbp.lua

	# Copy translation
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/i18n/torbp.ru.lmo $(1)/usr/lib/lua/luci/i18n/
endef

define Package/luci-app-torbp/postinst
	#!/bin/sh
	if [ -z "$${IPKG_INSTROOT}" ]; then
		rm -f /tmp/luci-indexcache* 2>/dev/null
	fi
	exit 0
endef

$(eval $(call BuildPackage,luci-app-torbp))

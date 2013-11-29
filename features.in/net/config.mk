+nm: use/net/nm/nodelay; @:

use/net: use/services
	@$(call add_feature)
	@$(call add,THE_PACKAGES,etcnet)
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/net/dhcp: use/net
	@$(call add,THE_PACKAGES,dhcpcd)

use/net/nm: use/net
	@$(call add,THE_LISTS,$(call tags,desktop nm))
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,DEFAULT_SERVICES_ENABLE,NetworkManager ModemManager)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-save-nfs) # don't reconfig

use/net/nm/nodelay: use/net/nm
	@$(call add,DEFAULT_SERVICES_DISABLE,NetworkManager-wait-online)

use/net/connman: use/net
	@$(call add,THE_PACKAGES,connman)
	@$(call add,DEFAULT_SERVICES_ENABLE,connman)

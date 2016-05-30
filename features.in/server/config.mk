use/server: use/power/acpi/button
	@$(call add_feature)

use/server/base: use/server use/firmware/server \
	use/net-ssh use/syslinux/timeout/600
	@$(call add,THE_LISTS,server-base)
	@$(call add,THE_KMODULES,e1000e igb)
	@$(call add,STAGE1_KMODULES,e1000e igb)
	@$(call add,INSTALL2_PACKAGES,installer-feature-server-raid-fixup-stage2)

use/server/mini: use/server/base
	@$(call add,THE_LISTS,\
		$(call tags,base && (network || security || pkg)))
	@$(call add,THE_LISTS,$(call tags,extra && (server || network)))
	@$(call add,MAIN_LISTS,osec)
	@$(call add,DEFAULT_SERVICES_DISABLE,messagebus lvm2-lvmetad)

use/server/ovz-base: use/server
	@$(call set,STAGE1_KFLAVOUR,std-def)
	@$(call set,KFLAVOURS,std-def ovz-el)
	@$(call add,BASE_PACKAGES,lftp wget)
	@$(call add,BASE_LISTS,$(call tags,base openvz))

use/server/ovz: use/server/ovz-base
	@$(call add,MAIN_KMODULES,ipset ipt-netflow opendpi pf_ring)
	@$(call add,MAIN_KMODULES,xtables-addons)	# t6/branch
	@$(call add,MAIN_KMODULES,drbd83 kvm)
	@$(call add,MAIN_KMODULES,staging)
	@$(call add,BASE_LISTS,$(call tags,server openvz))

# NB: examine zabbix-preinstall package, initialization is NOT automatic!
use/server/zabbix: use/server use/services use/control
	@$(call add,THE_LISTS,$(call tags,server zabbix))
	@$(call add,DEFAULT_SERVICES_ENABLE,zabbix_mysql zabbix_agentd)
	@$(call add,DEFAULT_SERVICES_ENABLE,httpd2 mysqld postfix)
	@$(call add,CONTROL,postfix:server)

use/server/groups/tools: use/server
	@$(call add,MAIN_GROUPS,diag-tools ipmi monitoring)

use/server/groups/services: use/server
	@$(call add,MAIN_GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,MAIN_GROUPS,dhcp-server mail-server mysql-server)
	@$(call add,MAIN_GROUPS,pgsql-server)

use/server/groups/base: use/server/groups/tools use/server/groups/services; @:

use/server/groups/openstack: use/server
	@$(call add,MAIN_GROUPS,openstack/block openstack/compute)
	@$(call add,MAIN_GROUPS,openstack/controller openstack/network)
	@$(call add,MAIN_GROUPS,openstack/storage)

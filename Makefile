BUILD_DIR=$(shell pwd)/build
BIN_DIR=$(BUILD_DIR)/bin
HANDLE_USER_DATA=$(shell base64 -w 0 scripts/handle-user-data)
HANDLE_USER_DATA_SERVICE=$(shell base64 -w 0 scripts/handle-user-data.service)
YUM_WRAPPER=$(shell base64 -w 0 scripts/yum-wrapper)
SET_IPADDRESS=$(shell base64 -w 0 scripts/set-ipaddress)
SET_IPADDRESS_SERVICE=$(shell base64 -w 0 scripts/set-ipaddress.service)
VERSION=1.0.0
GITTAG=$(shell git rev-parse --short HEAD)
TODAY=$(shell date +"%d%m%Y%H%M%S")

ifndef BUILD_ID
    BUILD_ID=local
endif

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

default: fedora_iso

.PHONY: init
init:
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: fedora_iso
fedora_iso: ISO_NAME=boot2podman-fedora
fedora_iso: KICKSTART_FILE=fedora.ks
fedora_iso: fedora_kickstart
fedora_iso: iso_creation

.PHONY: fedora_kickstart
fedora_kickstart: KICKSTART_FILE=fedora.ks
fedora_kickstart: KICKSTART_TEMPLATE=fedora.template
fedora_kickstart: RELEASEVER=30
fedora_kickstart: BASEARCH=x86_64
fedora_kickstart: kickstart

.PHONY: kickstart
kickstart: init
	@handle_user_data='$(HANDLE_USER_DATA)' handle_user_data_service='$(HANDLE_USER_DATA_SERVICE)' \
        set_ipaddress='$(SET_IPADDRESS)' set_ipaddress_service='$(SET_IPADDRESS_SERVICE)' \
        yum_wrapper='$(YUM_WRAPPER)' \
	version='$(VERSION)' build_id='$(GITTAG)-$(TODAY)-$(BUILD_ID)' \
	releasever='$(RELEASEVER)' basearch='$(BASEARCH)' \
	envsubst < $(KICKSTART_TEMPLATE) > $(BUILD_DIR)/$(KICKSTART_FILE)

.PHONY: iso_creation
iso_creation:
	cd $(BUILD_DIR); sudo livecd-creator --config $(BUILD_DIR)/$(KICKSTART_FILE) --logfile=$(BUILD_DIR)/livecd-creator.log --fslabel $(ISO_NAME) --cache=/var/cache/live
	# http://askubuntu.com/questions/153833/why-cant-i-mount-the-ubuntu-12-04-installer-isos-in-mac-os-x
	# http://www.syslinux.org/wiki/index.php?title=Doc/isolinux#HYBRID_CD-ROM.2FHARD_DISK_MODE
	dd if=/dev/zero bs=2k count=1 of=${BUILD_DIR}/tmp.iso
	dd if=$(BUILD_DIR)/$(ISO_NAME).iso bs=2k skip=1 >> ${BUILD_DIR}/tmp.iso
	mv -f ${BUILD_DIR}/tmp.iso $(BUILD_DIR)/$(ISO_NAME).iso

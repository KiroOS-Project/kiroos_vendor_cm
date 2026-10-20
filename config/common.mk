PRODUCT_BRAND ?= KiroOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cm/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/cm/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/cm/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Include CM audio files
include vendor/cm/config/cm_audio.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/cm/config/cmsdk_common.mk
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/cm/config/twrp.mk
endif

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# Required CM packages
# KiroOS 2.1.1: Development (Dev Tools) is left out
PRODUCT_PACKAGES += \
    BluetoothExt \
    CMAudioService \
    CMParts \
    Profiles \
    WeatherManagerService

# Optional CM packages
# KiroOS 2.1.1: Terminal is left out
# KiroOS Beta 4.1: LiveWallpapersPicker ("Live Wallpapers") is left out: Canvas is the only
# wallpaper picker
PRODUCT_PACKAGES += \
    libemoji \
    PhotoTable

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom CM packages
# KiroOS: LineageSetupWizard, Eleven, ExactCalculator and Trebuchet are replaced by
# Kiro Setup Wizard, Pulse Music, Kiro Calculator and Kiro Home (packages/apps/KiroOS)
# KiroOS 2.1.1: LockClock (cLock) and Exchange2 are left out
# KiroOS Beta 4.1: WallpaperPicker ("Wallpapers") is left out: Canvas replaces it
PRODUCT_PACKAGES += \
    CMSettingsProvider \
    WeatherProvider

# Extra tools in CM
PRODUCT_PACKAGES += \
    7z \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank

# Conditionally build in su
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

DEVICE_PACKAGE_OVERLAYS += vendor/cm/overlay/common

# KiroOS version and branding. The system is KiroOS 1.0. Beta 4: the build number shows just
# "1.0" (it was "KiroOS 1.0 (3.0)"); which beta it is shows as the channel ("Developer Beta 4"
# in KiroOS Update). KIRO_RELEASE (4.0) stays internal, for the OTA order and the package name.
# ~/kiro_build_env.sh exports KIRO_RELEASE and KIRO_RELEASE_CHANNEL; these are the defaults.
KIRO_NAME := KiroOS
KIRO_VERSION := 1.0
KIRO_DISPLAY_VERSION := KiroOS $(KIRO_VERSION)
KIRO_RELEASE ?= 5.0
KIRO_RELEASE_CHANNEL ?= Developer Beta 5
CUSTOM_BUILD_DISPLAY_ID := $(KIRO_VERSION)

PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE := 0
PRODUCT_VERSION_MAINTENANCE := 0

ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    CM_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    CM_VERSION_MAINTENANCE := 0
endif

# Set CM_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef CM_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "CM_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^CM_||g')
        CM_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(CM_BUILDTYPE)),)
    CM_BUILDTYPE :=
endif

ifdef CM_BUILDTYPE
    ifneq ($(CM_BUILDTYPE), SNAPSHOT)
        ifdef CM_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            CM_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from CM_EXTRAVERSION
            CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to CM_EXTRAVERSION
            CM_EXTRAVERSION := -$(CM_EXTRAVERSION)
        endif
    else
        ifndef CM_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            CM_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from CM_EXTRAVERSION
            CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to CM_EXTRAVERSION
            CM_EXTRAVERSION := -$(CM_EXTRAVERSION)
        endif
    endif
else
    # If CM_BUILDTYPE is not defined, set to UNOFFICIAL
    CM_BUILDTYPE := UNOFFICIAL
    CM_EXTRAVERSION :=
endif

ifeq ($(CM_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        CM_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

# The package name and ro.cm.version: version, release, build date (local time, the date on the
# PC clock), device: KiroOS-1.0-3.0-20261008-zerofltexx.zip
KIROOS_VERSION := $(KIRO_VERSION)-$(KIRO_RELEASE)-$(shell date +%Y%m%d)-$(CM_BUILD)

# ro.lineage.* / ro.cm.* keep their names (cmsdk, CMParts and backuptool read them) and carry
# KiroOS values
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.version=$(KIROOS_VERSION) \
    ro.cm.version=$(KIROOS_VERSION) \
    ro.cm.releasetype=RELEASE \
    ro.cm.build.version=$(KIRO_VERSION) \
    ro.modversion=KiroOS-$(KIRO_VERSION)-$(CM_BUILD) \
    ro.kiro.name=KiroOS \
    ro.kiro.version=$(KIRO_VERSION)
# KiroOS: set ro.cmlegal.url here when a legal page is published (the entry is hidden until then)

# The KiroOS recovery takes only KiroOS packages: LineageOS's release key is no longer trusted
# (PRODUCT_EXTRA_RECOVERY_KEYS vendor/cm/build/target/product/security/lineage was here)

-include vendor/cm-priv/keys/keys.mk

CM_DISPLAY_VERSION := KiroOS $(KIRO_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(CM_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(CM_EXTRAVERSION),)
                # Remove leading dash from CM_EXTRAVERSION
                CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(CM_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
        CM_DISPLAY_VERSION := KiroOS $(KIRO_VERSION)
    endif
endif
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/cm/config/partner_gms.mk
-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/sensitive_pn.xml:system/etc/sensitive_pn.xml

# World APN list
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Telephony packages (SMS/MMS: Kiro Messages, packages/apps/KiroOS)
PRODUCT_PACKAGES += \
    Stk \
    CellBroadcastReceiver

# Default ringtone
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Orion.ogg

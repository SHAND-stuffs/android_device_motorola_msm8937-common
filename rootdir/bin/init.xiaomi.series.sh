#!/vendor/bin/sh

# Device Info
setprop ro.vendor.xiaomi.device "$(cat /sys/motorola-msm8937-mach/device)"
setprop ro.vendor.xiaomi.variant "$(cat /sys/motorola-msm8937-mach/variant)"

exit 0

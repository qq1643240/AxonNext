ARCHS = arm64 arm64e
TARGET = iphone:16.5:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AxonNext
$(TWEAK_NAME)_FILES = Tweak.xm $(wildcard AXN*.m)
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore WebKit MediaPlayer
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += SpringBoardFoundation
ADDITIONAL_OBJCFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-function -Wno-error -Wno-incompatible-property-type -Wno-visibility

include $(THEOS_MAKE_PATH)/tweak.mk

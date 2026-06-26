ARCHS = arm64 arm64e
TARGET = iphone:16.5:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AxonNextPrefs
$(BUNDLE_NAME)_FILES = Preferences.m AXNAppearanceSettings.m AXNListItemsController.m AXNDebugController.m AXNLocationController.m AXNGestureSettings.m AXNFilterSettings.m AXNLayoutSettings.m AXNAnimationSettings.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
ADDITIONAL_OBJCFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)

#import "Tweak.h"
#import "AXNManager.h"

NSDictionary *prefs;
BOOL initialized = NO;
BOOL enabled;
BOOL vertical;
BOOL badgesEnabled;
BOOL badgesShowBackground;
BOOL hapticFeedback;
NSInteger darkMode;
NSInteger sortingMode;
NSInteger selectionStyle;
BOOL addBlur;
NSInteger style;
NSInteger showByDefault;
NSInteger alignment;
NSInteger iconStyle;
NSInteger verticalPosition;
NSInteger autoLayout;
NSInteger yAxis;
NSInteger location;
CGFloat spacing;
CGFloat iconSize;
NSInteger itemsPerRow;
CGFloat cornerRadius;
BOOL autoArrange;
NSInteger animationStyle;
BOOL gesturesEnabled;
NSInteger swipeUpAction;
NSInteger swipeDownAction;
NSInteger swipeLeftAction;
NSInteger swipeRightAction;

void updateViewConfiguration() {
    if (initialized && [AXNManager sharedInstance].view) {
        AXNView *view = [AXNManager sharedInstance].view;
        view.hapticFeedback = hapticFeedback;
        view.badgesEnabled = badgesEnabled;
        view.badgesShowBackground = badgesShowBackground;
        view.darkMode = darkMode;
        view.sortingMode = sortingMode;
        view.selectionStyle = selectionStyle;
        view.addBlur = addBlur;
        view.style = style;
        view.showByDefault = showByDefault;
        view.alignment = alignment;
        view.iconStyle = iconStyle;
        view.spacing = spacing;
        view.iconSize = iconSize;
        view.cornerRadius = cornerRadius;
        view.autoArrange = autoArrange;
        view.animationStyle = animationStyle;
        view.gesturesEnabled = gesturesEnabled;
        view.swipeUpAction = swipeUpAction;
        view.swipeDownAction = swipeDownAction;
        view.swipeLeftAction = swipeLeftAction;
        view.swipeRightAction = swipeRightAction;
        [view refresh];
    }
}

// Force a dark mode value
NSInteger overrideDarkMode() {
    if (darkMode == 0) {
        // Follow system
        return [[UIScreen mainScreen] traitCollection.userInterfaceStyle] == UIUserInterfaceStyleDark ? 2 : 1;
    }
    return darkMode;
}

%group Axon

// Hook NCNotificationStructuredListViewController (iOS 14+)
%hook NCNotificationStructuredListViewController

%property (nonatomic, retain) AXNView *axnView;

- (void)viewDidLoad {
    %orig;
    if (!enabled) return;

    self.axnView = [[AXNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 90)];
    self.axnView.translatesAutoresizingMaskIntoConstraints = NO;
    self.axnView.clipsToBounds = YES;

    [self.view addSubview:self.axnView];

    [NSLayoutConstraint activateConstraints:@[
        [self.axnView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.axnView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.axnView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.axnView.heightAnchor constraintEqualToConstant:90],
    ]];

    [AXNManager sharedInstance].view = self.axnView;
    [AXNManager sharedInstance].clvc = self;
    [AXNManager sharedInstance].sbclvc = self;
    initialized = YES;
    updateViewConfiguration();
}

- (void)_setListHasContent:(BOOL)arg1 {
    %orig;
    if (self.axnView) [self.axnView refresh];
}

- (void)_didUpdateDisplay {
    %orig;
    if (self.axnView) [self.axnView refresh];
}

- (void)insertNotificationRequest:(id)arg1 {
    %orig;
    if ([AXNManager sharedInstance].clvc == self) {
        [[AXNManager sharedInstance] insertNotificationRequest:arg1];
        [self.axnView refresh];
    }
}

- (void)removeNotificationRequest:(id)arg1 {
    %orig;
    if ([AXNManager sharedInstance].clvc == self) {
        [[AXNManager sharedInstance] removeNotificationRequest:arg1];
        [self.axnView refresh];
    }
}

- (void)modifyNotificationRequest:(id)arg1 {
    %orig;
    if ([AXNManager sharedInstance].clvc == self) {
        [[AXNManager sharedInstance] modifyNotificationRequest:arg1];
        [self.axnView refresh];
    }
}

%end

// Hook NCNotificationDispatcher
%hook NCNotificationDispatcher

- (id)init {
    id orig = %orig;
    [AXNManager sharedInstance].dispatcher = orig;
    return orig;
}

%end

%end

%group AxonHorizontal

%hook NCNotificationStructuredListViewController

- (void)viewDidLayoutSubviews {
    %orig;
    if (self.axnView) {
        // Horizontal layout adjustments
        self.axnView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 90);
    }
}

%end

%end

%group AxonVertical

%hook NCNotificationStructuredListViewController

- (void)viewDidLayoutSubviews {
    %orig;
    if (self.axnView) {
        // Vertical layout adjustments
        CGFloat width = 90;
        CGFloat height = self.view.bounds.size.height;
        CGFloat x = 0;

        if (verticalPosition == 1) {
            x = self.view.bounds.size.width - width;
        }

        self.axnView.frame = CGRectMake(x, 0, width, height);
    }
}

%end

%end

void loadPrefs() {
  prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.nepeta.axon.plist"] ?: [NSDictionary new];

  enabled = prefs[@"enabled"] != nil ? [prefs[@"enabled"] boolValue] : true;
  vertical = prefs[@"vertical"] != nil ? [prefs[@"vertical"] boolValue] : false;
  hapticFeedback = prefs[@"hapticFeedback"] != nil ? [prefs[@"hapticFeedback"] boolValue] : true;
  badgesEnabled = prefs[@"badgesEnabled"] != nil ? [prefs[@"badgesEnabled"] boolValue] : true;
  badgesShowBackground = prefs[@"badgesShowBackground"] != nil ? [prefs[@"badgesShowBackground"] boolValue] : true;
  darkMode = [prefs[@"DarkMode"] intValue] ?: 0;
  sortingMode = [prefs[@"sortingMode"] intValue] ?: 0;
  selectionStyle = [prefs[@"selectionStyle"] intValue] ?: 0;
  addBlur = prefs[@"addBlur"] != nil ? [prefs[@"addBlur"] boolValue] : false;
  style = [prefs[@"style"] intValue] ?: 0;
  if(style > 5) style = 4;
  showByDefault = [prefs[@"showByDefault"] intValue] ?: 0;
  alignment = [prefs[@"alignment"] intValue] ?: 1;
  iconStyle = [prefs[@"iconStyle"] intValue] ?: 0;
  verticalPosition = [prefs[@"verticalPosition"] intValue] ?: 0;
  autoLayout = prefs[@"autoLayout"] != nil ? [prefs[@"autoLayout"] boolValue] : true;
  location = [prefs[@"location"] intValue] ?: 0;
  if(autoLayout == false) location = 1;
  yAxis = [prefs[@"yAxis"] intValue] ?: 0;
  spacing = [prefs[@"spacing"] floatValue] ?: 10;
  iconSize = [prefs[@"iconSize"] floatValue] ?: 60;
  cornerRadius = [prefs[@"cornerRadius"] floatValue] ?: 13;
  autoArrange = prefs[@"autoArrange"] != nil ? [prefs[@"autoArrange"] boolValue] : true;
  animationStyle = [prefs[@"animationStyle"] intValue] ?: 0;
  gesturesEnabled = prefs[@"gesturesEnabled"] != nil ? [prefs[@"gesturesEnabled"] boolValue] : true;
  swipeUpAction = [prefs[@"swipeUpAction"] intValue] ?: 1;
  swipeDownAction = [prefs[@"swipeDownAction"] intValue] ?: 2;
  swipeLeftAction = [prefs[@"swipeLeftAction"] intValue] ?: 3;
  swipeRightAction = [prefs[@"swipeRightAction"] intValue] ?: 4;
  if(style > 5) style = 4;
  updateViewConfiguration();
}

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%ctor {
  NSLog(@"[AxonNext] init");
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("me.nepeta.axon/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();

  if(enabled) {
    %init(Axon);
    if (!vertical) %init(AxonHorizontal);
    else %init(AxonVertical);
  }
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

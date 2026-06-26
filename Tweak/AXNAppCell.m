#import <AudioToolbox/AudioToolbox.h>
#import "AXNAppCell.h"
#import "AXNManager.h"

NSMutableDictionary* prefs;

UIView *getBlurView(CGRect frame) {
    NSInteger darkModeTmp = [prefs[@"DarkMode"] intValue] ?: 0;
    UIView *blurView;
    if(darkModeTmp == 0) {
        id materialView = objc_getClass("MTMaterialView");
        if([materialView respondsToSelector:@selector(materialViewWithRecipe:options:)]) blurView = [materialView materialViewWithRecipe:MTMaterialRecipeNotifications options:MTMaterialOptionsBlur];
        else blurView = [materialView materialViewWithRecipe:MTMaterialRecipeNotifications configuration:1];
        blurView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    } else if(darkModeTmp == 1) {
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    } else if(darkModeTmp == 2) {
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    } else if(darkModeTmp == 3) {
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial]];
    } else if(darkModeTmp == 4) {
        // Transparent
        blurView = [[UIView alloc] initWithFrame:frame];
        blurView.backgroundColor = [UIColor clearColor];
    }
    return blurView;
}

@implementation AXNAppCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (self.isSetupComplete) return;
    self.isSetupComplete = YES;
    self.iconSize = 60;
    self.cornerRadius = 13;
    self.gesturesEnabled = YES;

    self.iconView = [[UIImageView alloc] init];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.layer.cornerRadius = self.cornerRadius;
    self.iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconView];

    self.badgeLabel = [[UILabel alloc] init];
    self.badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.badgeLabel.textColor = [UIColor whiteColor];
    self.badgeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = [UIColor systemRedColor];
    self.badgeLabel.layer.cornerRadius = 10;
    self.badgeLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.badgeLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.iconView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:self.iconSize],
        [self.iconView.heightAnchor constraintEqualToConstant:self.iconSize],

        [self.badgeLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:-4],
        [self.badgeLabel.trailingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:4],
        [self.badgeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:20],
        [self.badgeLabel.heightAnchor constraintEqualToConstant:20],
    ]];

    // Long press for context menu
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.contentView addGestureRecognizer:longPress];

    // Swipe gestures (four directions)
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.contentView addGestureRecognizer:swipeUp];

    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.contentView addGestureRecognizer:swipeDown];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:swipeRight];
}

- (void)setIconSize:(CGFloat)iconSize {
    _iconSize = iconSize;
    self.iconView.layer.cornerRadius = self.cornerRadius;
    for (NSLayoutConstraint *constraint in self.contentView.constraints) {
        if (constraint.firstItem == self.iconView && (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight)) {
            constraint.constant = iconSize;
        }
    }
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.iconView.layer.cornerRadius = cornerRadius;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor clearColor];
    self.iconView.alpha = 1.0;
    self.badgeLabel.alpha = 1.0;
}

-(void)setBundleIdentifier:(NSString *)bundleIdentifier {
    _bundleIdentifier = bundleIdentifier;
    self.iconView.image = [[AXNManager sharedInstance] getIcon:bundleIdentifier rounded:(self.iconStyle == 0)];
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.notificationCount];

    if (self.badgesEnabled && self.notificationCount > 1) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
}

-(void)setNotificationCount:(NSInteger)notificationCount {
    _notificationCount = notificationCount;
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)notificationCount];
    if (self.badgesEnabled && notificationCount > 1) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
}

#pragma mark - Gesture Handling

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    if (!self.gesturesEnabled) return;
    if (self.hapticFeedback) AudioServicesPlaySystemSound(1519);

    NSInteger action = 0;
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:    action = self.swipeUpAction; break;
        case UISwipeGestureRecognizerDirectionDown:  action = self.swipeDownAction; break;
        case UISwipeGestureRecognizerDirectionLeft:  action = self.swipeLeftAction; break;
        case UISwipeGestureRecognizerDirectionRight: action = self.swipeRightAction; break;
    }
    [self performGestureAction:action];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.hapticFeedback) AudioServicesPlaySystemSound(1519);
        [self showLongPressMenu];
    }
}

- (void)performGestureAction:(NSInteger)action {
    AXNManager *manager = [AXNManager sharedInstance];
    NSString *bid = self.bundleIdentifier;
    if (!bid) return;

    switch (action) {
        case AXNGestureActionOpenApp:
            [manager launchAppWithBundleIdentifier:bid];
            break;
        case AXNGestureActionClearNotif:
            [manager clearAll:bid];
            [manager.view refresh];
            break;
        case AXNGestureActionMute:
            [manager toggleMuteForBundleIdentifier:bid];
            break;
        case AXNGestureActionFavorite:
            [manager toggleFavoriteForBundleIdentifier:bid];
            [manager.view refresh];
            break;
        case AXNGestureActionCopyContent: {
            NSString *content = [manager notificationContentForBundleIdentifier:bid];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = content;
            break;
        }
        case AXNGestureActionViewNotif:
            [manager showNotificationRequestsForBundleIdentifier:bid];
            break;
        default:
            break;
    }
}

- (void)showLongPressMenu {
    AXNManager *manager = [AXNManager sharedInstance];
    NSString *bid = self.bundleIdentifier;
    if (!bid) return;

    NSString *appName = manager.names[bid] ?: bid;
    BOOL isMuted = [manager isMuted:bid];
    BOOL isFav = [manager isFavorited:bid];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"打开应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [manager launchAppWithBundleIdentifier:bid];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"查看通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [manager showNotificationRequestsForBundleIdentifier:bid];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"清除通知" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
        [manager clearAll:bid];
        [manager.view refresh];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"清除全部" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
        [manager clearAll];
        [manager.view refresh];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:isMuted ? @"取消静音" : @"静音通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [manager toggleMuteForBundleIdentifier:bid];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:isFav ? @"取消收藏" : @"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [manager toggleFavoriteForBundleIdentifier:bid];
        [manager.view refresh];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"复制通知内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        NSString *content = [manager notificationContentForBundleIdentifier:bid];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    // Find top view controller
    UIViewController *topVC = nil;
    UIWindowScene *scene = (UIWindowScene *)[UIApplication.sharedApplication.connectedScenes anyObject];
    if (scene) {
        topVC = scene.windows.firstObject.rootViewController;
    } else {
        topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;

    if ([topVC isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)topVC) presentViewController:alert animated:YES completion:nil];
    } else {
        [topVC presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            switch (self.selectionStyle) {
                case 1:
                    self.iconView.alpha = 1.0;
                    self.badgeLabel.alpha = 1.0;
                    break;
                default:
                    if (!self.darkMode) self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
                    else if (self.darkMode) self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            }
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            switch (self.selectionStyle) {
                case 1:
                    self.iconView.alpha = 0.5;
                    self.badgeLabel.alpha = 0.5;
                    break;
                default:
                    self.backgroundColor = [UIColor clearColor];
            }
        } completion:NULL];
    }
}

@end

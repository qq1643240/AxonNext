@interface MPArtworkColorAnalyzer : NSObject
- (void)analyzeWithCompletionHandler:(id /* block */)arg1;
- (id)initWithImage:(id)arg1 algorithm:(long long)arg2;
@end

typedef NS_ENUM(NSInteger, MTMaterialRecipe) {
    MTMaterialRecipeNone,
    MTMaterialRecipeNotifications,
    MTMaterialRecipeWidgetHosts,
    MTMaterialRecipeWidgets,
    MTMaterialRecipeControlCenterModules,
    MTMaterialRecipeSwitcherContinuityItem,
    MTMaterialRecipePreviewBackground,
    MTMaterialRecipeNotificationsDark,
    MTMaterialRecipeControlCenterModulesSheer
};

typedef NS_OPTIONS(NSUInteger, MTMaterialOptions) {
    MTMaterialOptionsNone             = 0,
    MTMaterialOptionsGamma            = 1 << 0,
    MTMaterialOptionsBlur             = 1 << 1,
    MTMaterialOptionsZoom             = 1 << 2,
    MTMaterialOptionsLuminanceMap     = 1 << 3,
    MTMaterialOptionsLuminanceMapBlur = 1 << 4,
};

@interface MTMaterialView : UIView
+ (instancetype)materialViewWithRecipe:(MTMaterialRecipe)recipe options:(MTMaterialOptions)options;
+ (instancetype)materialViewWithRecipe:(MTMaterialRecipe)recipe configuration:(NSInteger)config;
@end

@interface NCNotificationDispatcher : NSObject
@property (nonatomic, retain) id notificationStore;
-(void)destination:(id)arg1 requestsClearingNotificationRequests:(id)arg2;
@end

@interface NCNotificationRequest : NSObject <NSCopying>
@property (nonatomic, copy) NSString *notificationIdentifier;
@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain) BBBulletin *bulletin;
@property (nonatomic, retain) NCNotificationContent *content;
@property (nonatomic, retain) NSString *sectionIdentifier;
@end

@interface NCCoalescedNotification : NSObject
@property (nonatomic, retain) NSSet *notificationRequests;
@end

@interface SBIcon : NSObject
- (UIImage *)getIconImage:(NSInteger)arg1;
- (UIImage *)iconImageWithInfo:(struct SBIconImageInfo)arg1;
@end

@interface SBIconModel : NSObject
- (SBIcon *)applicationIconForBundleIdentifier:(NSString *)arg1;
@end

@interface SBIconViewMap : NSObject
- (SBIconModel *)iconModel;
@end

@interface SBIconController : NSObject
+ (instancetype)sharedInstance;
- (SBIconViewMap *)homescreenIconViewMap;
- (SBIconModel *)model;
@end

@interface NCNotificationStructuredListViewController : UIViewController
@property (nonatomic, retain) NSMutableSet *internalNotificationRequests;
- (NSSet *)allNotificationRequests;
- (void)insertNotificationRequest:(id)arg1 ;
- (void)modifyNotificationRequest:(id)arg1 ;
- (void)removeNotificationRequest:(id)arg1 ;
- (void)_didUpdateDisplay;
- (void)_insertItem:(id)arg1 animated:(BOOL)arg2 ;
- (void)_removeItem:(id)arg1 animated:(BOOL)arg2 ;
- (void)updateNotifications;
- (void)revealNotificationHistory:(BOOL)revealed;
- (id)collectionView;
- (BOOL)isPresentingContent;
- (void)_setListHasContent:(BOOL)arg1;
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface CALayer (Private)
@property (nonatomic, assign) BOOL continuousCorners;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * displayName;
@end

// Gesture action enum
typedef NS_ENUM(NSInteger, AXNGestureAction) {
    AXNGestureActionNone        = 0,
    AXNGestureActionOpenApp     = 1,
    AXNGestureActionClearNotif  = 2,
    AXNGestureActionMute        = 3,
    AXNGestureActionFavorite    = 4,
    AXNGestureActionCopyContent = 5,
    AXNGestureActionViewNotif   = 6,
};

@interface AXNAppCell : UICollectionViewCell <UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, retain) UILabel *badgeLabel;
@property (nonatomic, retain) NSString *bundleIdentifier;
@property (nonatomic, assign) NSInteger notificationCount;
@property (nonatomic, assign) NSInteger selectionStyle;
@property (nonatomic, assign) BOOL addBlur;
@property (nonatomic, assign) NSInteger style;
@property (nonatomic, assign) NSInteger iconStyle;
@property (nonatomic, assign) BOOL badgesEnabled;
@property (nonatomic, assign) BOOL badgesShowBackground;
@property (nonatomic, assign) NSInteger darkMode;
@property (nonatomic, assign) BOOL isSetupComplete;
@property (nonatomic, assign) CGFloat iconSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL gesturesEnabled;
@property (nonatomic, assign) NSInteger swipeUpAction;
@property (nonatomic, assign) NSInteger swipeDownAction;
@property (nonatomic, assign) NSInteger swipeLeftAction;
@property (nonatomic, assign) NSInteger swipeRightAction;
@property (nonatomic, assign) NSInteger animationStyle;

-(void)setupView;
-(void)performGestureAction:(NSInteger)action;
-(void)showLongPressMenu;

@end

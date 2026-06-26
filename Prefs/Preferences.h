#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "AXNController.h"
#import "NSTask.h"

@interface AXNAppearanceSettings : PSListController

@end

@interface AXNPrefsListController : PSListController {
    UITableView * _table;
}

@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
- (void)respring:(id)sender;

@end

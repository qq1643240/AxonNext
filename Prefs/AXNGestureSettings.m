#import "AXNGestureSettings.h"

@implementation AXNGestureSettings

-(id)specifiers {
    if(_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];

        if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
        else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"手势设置"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSGroupCell
                                                                        edit:nil];
            [specifier.properties setValue:@"配置四方向滑动手势和长按菜单行为" forKey:@"footerText"];
            specifier;
        })];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"启用手势"
                                                                      target:self
                                                                         set:@selector(setSwitch:forSpecifier:)
                                                                         get:@selector(getSwitch:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSSwitchCell
                                                                        edit:nil];
            [specifier setProperty:@"gesturesEnabled" forKey:@"key"];
            [specifier setProperty:@1 forKey:@"default"];
            specifier;
        })];

        // Swipe Up
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"上滑动作"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:AXNListItemsController.class
                                                                        cell:PSLinkListCell
                                                                        edit:nil];
            [specifier setProperty:@"swipeUpAction" forKey:@"key"];
            [specifier setProperty:@[@[
                @[@"打开应用", @1],
                @[@"清除通知", @2],
                @[@"静音通知", @3],
                @[@"收藏", @4],
                @[@"复制内容", @5],
                @[@"查看通知", @6],
                @[@"无", @0],
            ]] forKey:@"values"];
            [specifier setProperty:@1 forKey:@"default"];
            specifier;
        })];

        // Swipe Down
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"下滑动作"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:AXNListItemsController.class
                                                                        cell:PSLinkListCell
                                                                        edit:nil];
            [specifier setProperty:@"swipeDownAction" forKey:@"key"];
            [specifier setProperty:@[@[
                @[@"清除通知", @2],
                @[@"打开应用", @1],
                @[@"静音通知", @3],
                @[@"收藏", @4],
                @[@"复制内容", @5],
                @[@"查看通知", @6],
                @[@"无", @0],
            ]] forKey:@"values"];
            [specifier setProperty:@2 forKey:@"default"];
            specifier;
        })];

        // Swipe Left
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"左滑动作"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:AXNListItemsController.class
                                                                        cell:PSLinkListCell
                                                                        edit:nil];
            [specifier setProperty:@"swipeLeftAction" forKey:@"key"];
            [specifier setProperty:@[@[
                @[@"静音通知", @3],
                @[@"打开应用", @1],
                @[@"清除通知", @2],
                @[@"收藏", @4],
                @[@"复制内容", @5],
                @[@"查看通知", @6],
                @[@"无", @0],
            ]] forKey:@"values"];
            [specifier setProperty:@3 forKey:@"default"];
            specifier;
        })];

        // Swipe Right
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"右滑动作"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:AXNListItemsController.class
                                                                        cell:PSLinkListCell
                                                                        edit:nil];
            [specifier setProperty:@"swipeRightAction" forKey:@"key"];
            [specifier setProperty:@[@[
                @[@"收藏", @4],
                @[@"打开应用", @1],
                @[@"清除通知", @2],
                @[@"静音通知", @3],
                @[@"复制内容", @5],
                @[@"查看通知", @6],
                @[@"无", @0],
            ]] forKey:@"values"];
            [specifier setProperty:@4 forKey:@"default"];
            specifier;
        })];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@""
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSGroupCell
                                                                        edit:nil];
            [specifier.properties setValue:@"长按应用图标可弹出菜单：打开应用、查看通知、清除通知、清除全部、静音/取消静音、收藏、复制通知内容" forKey:@"footerText"];
            specifier;
        })];

        _specifiers = specifiers;
    }
    return _specifiers;
}

-(void)setValue:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
    prefs[[specifier propertyForKey:@"key"]] = value;
    [[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:NO];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.nepeta.axon/ReloadPrefs"), NULL, NULL, YES);
}

-(NSNumber *)getValue:(NSString *)key forSpecifier:(PSSpecifier *)specifier {
    return prefs[key] ? [NSNumber numberWithInteger:[prefs[key] intValue]] : [specifier propertyForKey:@"default"];
}

-(void)setSwitch:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
    prefs[[specifier propertyForKey:@"key"]] = value;
    [[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:NO];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.nepeta.axon/ReloadPrefs"), NULL, NULL, YES);
}

-(NSNumber *)getSwitch:(PSSpecifier *)specifier {
    return prefs[[specifier propertyForKey:@"key"]] ? [NSNumber numberWithBool:[prefs[[specifier propertyForKey:@"key"]] boolValue]] : [specifier propertyForKey:@"default"];
}

@end

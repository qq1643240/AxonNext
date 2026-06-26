#import "AXNAnimationSettings.h"

@implementation AXNAnimationSettings

-(id)specifiers {
    if(_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];

        if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
        else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"动画设置"
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSGroupCell
                                                                        edit:nil];
            specifier;
        })];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"动画样式"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValue:forSpecifier:)
                                                                      detail:AXNListItemsController.class
                                                                        cell:PSLinkListCell
                                                                        edit:nil];
            [specifier setProperty:@"animationStyle" forKey:@"key"];
            [specifier setProperty:@[@[
                @[@"Apple Spring", @0],
                @[@"Scale", @1],
                @[@"Bounce", @2],
                @[@"Fluid", @3],
                @[@"Jelly", @4],
                @[@"Fade", @5],
            ]] forKey:@"values"];
            [specifier setProperty:@0 forKey:@"default"];
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
            [specifier.properties setValue:@"选择通知列表刷新和选中时的动画效果。" forKey:@"footerText"];
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

@end

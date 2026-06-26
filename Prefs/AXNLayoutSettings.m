#import "AXNLayoutSettings.h"

@implementation AXNLayoutSettings

-(id)specifiers {
    if(_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];

        if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
        else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"布局设置"
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSGroupCell
                                                                        edit:nil];
            specifier;
        })];

        // Icon Size
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"图标大小"
                                                                      target:self
                                                                         set:@selector(setSlider:forSpecifier:)
                                                                         get:@selector(getSlider:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSSliderCell
                                                                        edit:nil];
            [specifier setProperty:@"iconSize" forKey:@"key"];
            [specifier setProperty:@40 forKey:@"min"];
            [specifier setProperty:@80 forKey:@"max"];
            [specifier setProperty:@YES forKey:@"showValue"];
            [specifier setProperty:@60 forKey:@"default"];
            specifier;
        })];

        // Spacing
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"图标间距"
                                                                      target:self
                                                                         set:@selector(setSlider:forSpecifier:)
                                                                         get:@selector(getSlider:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSSliderCell
                                                                        edit:nil];
            [specifier setProperty:@"spacing" forKey:@"key"];
            [specifier setProperty:@0 forKey:@"min"];
            [specifier setProperty:@30 forKey:@"max"];
            [specifier setProperty:@YES forKey:@"showValue"];
            [specifier setProperty:@10 forKey:@"default"];
            specifier;
        })];

        // Corner Radius
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"圆角样式"
                                                                      target:self
                                                                         set:@selector(setSlider:forSpecifier:)
                                                                         get:@selector(getSlider:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSSliderCell
                                                                        edit:nil];
            [specifier setProperty:@"cornerRadius" forKey:@"key"];
            [specifier setProperty:@0 forKey:@"min"];
            [specifier setProperty:@30 forKey:@"max"];
            [specifier setProperty:@YES forKey:@"showValue"];
            [specifier setProperty:@13 forKey:@"default"];
            specifier;
        })];

        // Auto Arrange
        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"自动排列（收藏优先）"
                                                                      target:self
                                                                         set:@selector(setSwitch:forSpecifier:)
                                                                         get:@selector(getSwitch:forSpecifier:)
                                                                      detail:nil
                                                                        cell:PSSwitchCell
                                                                        edit:nil];
            [specifier setProperty:@"autoArrange" forKey:@"key"];
            [specifier setProperty:@YES forKey:@"default"];
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
            [specifier.properties setValue:@"收藏的应用将自动排在前面。" forKey:@"footerText"];
            specifier;
        })];

        _specifiers = specifiers;
    }
    return _specifiers;
}

-(void)setSlider:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
    prefs[[specifier propertyForKey:@"key"]] = value;
    [[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:NO];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.nepeta.axon/ReloadPrefs"), NULL, NULL, YES);
}

-(NSNumber *)getSlider:(NSString *)key forSpecifier:(PSSpecifier *)specifier {
    return prefs[key] ? [NSNumber numberWithFloat:[prefs[key] floatValue]] : [specifier propertyForKey:@"default"];
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

#import <AppList/AppList.h>
#import "AXNController.h"
NSMutableDictionary *prefs;

@interface AXNLocationController : PSListController {
        PSSpecifier *_autoLayoutLocationSpecifier;
        PSSpecifier *_yAxisSpecifier;
}
@property (nonatomic, strong) PSSpecifier *autoLayoutLocationSpecifier;
@property (nonatomic, strong) PSSpecifier *yAxisSpecifier;
@end

@implementation AXNLocationController
-(id)specifiers {
        if(_specifiers == nil)
        {
                NSMutableArray *specifiers = [[NSMutableArray alloc] init];

                if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
                else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];

                [specifiers addObject:({
                        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"位置" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
                        specifier;
                })];

                self.autoLayoutLocationSpecifier = ({
                        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"自动定位" target:self set:@selector(setSwitch:forSpecifier:) get:@selector(getSwitch:forSpecifier:) detail:nil cell:PSSwitchCell edit:nil];
                        [specifier setProperty:@"autoLayout" forKey:@"displayIdentifier"];
                        [specifier setProperty:@YES forKey:@"default"];
                        specifier;
                });
                [specifiers addObject:self.autoLayoutLocationSpecifier];

                self.yAxisSpecifier = ({
                        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Y轴位置" target:self set:@selector(setNumber:forSpecifier:) get:@selector(getSwitch:forSpecifier:) detail:nil cell:PSSliderCell edit:nil];
                        [specifier setProperty:@"yAxis" forKey:@"displayIdentifier"];
                        [specifier setProperty:@0 forKey:@"min"];
                        [specifier setProperty:@100 forKey:@"max"];
                        [specifier setProperty:@YES forKey:@"showValue"];
                        [specifier setProperty:@0 forKey:@"default"];
                        specifier;
                });

                if([prefs[@"autoLayout"] boolValue] != false) {
                        [specifiers addObject:self.autoLayoutLocationSpecifier];
                } else {
                        [specifiers addObject:self.yAxisSpecifier];
                }

                _specifiers = specifiers;
        }
        return _specifiers;
}
-(void)setSwitch:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
        prefs[[specifier propertyForKey:@"displayIdentifier"]] = value;
        [[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:FALSE];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.nepeta.axon/ReloadPrefs"), NULL, NULL, YES);

        if([[specifier propertyForKey:@"displayIdentifier"] isEqualToString:@"autoLayout"]) {
                if([value boolValue]) {
                        [self removeSpecifier:self.yAxisSpecifier animated:true];
                        [self addSpecifier:self.autoLayoutLocationSpecifier animated:true];
                } else {
                        [self removeSpecifier:self.autoLayoutLocationSpecifier animated:true];
                        [self addSpecifier:self.yAxisSpecifier animated:true];
                }
        }
}
-(void)setNumber:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
        prefs[[specifier propertyForKey:@"displayIdentifier"]] = value;
        [[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:FALSE];
}
-(NSNumber *)getSwitch:(PSSpecifier *)specifier {
        return [self getValue:[specifier propertyForKey:@"displayIdentifier"]];
}
-(NSNumber *)getValue:(NSString *)name {
        return prefs[name] ? [NSNumber numberWithInteger:[prefs[name] intValue]] : @(1);
}
@end

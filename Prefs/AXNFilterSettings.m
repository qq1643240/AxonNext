#import "AXNFilterSettings.h"

@implementation AXNFilterSettings

-(id)specifiers {
    if(_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];

        if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
        else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"通知过滤"
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSGroupCell
                                                                        edit:nil];
            [specifier.properties setValue:@"设置白名单和黑名单。黑名单优先于白名单。" forKey:@"footerText"];
            specifier;
        })];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"白名单"
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSLinkCell
                                                                        edit:nil];
            [specifier setProperty:@"AXNWhitelistController" forKey:@"detailClass"];
            specifier;
        })];

        [specifiers addObject:({
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"黑名单"
                                                                      target:self
                                                                         set:nil
                                                                         get:nil
                                                                      detail:nil
                                                                        cell:PSLinkCell
                                                                        edit:nil];
            [specifier setProperty:@"AXNBlacklistController" forKey:@"detailClass"];
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
            [specifier.properties setValue:@"白名单中的应用将显示在 AxonNext 中，其他应用将被隐藏。如果白名单为空，则显示所有应用（除黑名单外）。" forKey:@"footerText"];
            specifier;
        })];

        _specifiers = specifiers;
    }
    return _specifiers;
}

@end

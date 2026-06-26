#import <AppList/AppList.h>
#import "AXNController.h"

@interface AXNDebugController : PSListController
@end

@implementation AXNDebugController
-(id)specifiers {
	if(_specifiers == nil)
	{
		NSMutableArray *specifiers = [[NSMutableArray alloc] init];

		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"调试选项" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			[specifier.properties setValue:@"调试选项可以帮助您解决问题！.." forKey:@"footerText"];
			specifier;
		})];

    [specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"清除所有通知" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
	    specifier->action = @selector(clearAll);
			specifier;
		})];
    [specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"保存通知列表" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
	    specifier->action = @selector(saveNotification);
			specifier;
		})];
    [specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"反馈问题" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
	    specifier->action = @selector(report);
			specifier;
		})];

		_specifiers = [specifiers copy];
	}

	return _specifiers;
}

-(void)clearAll {
  [[objc_getClass("NSDistributedNotificationCenter") defaultCenter] postNotificationName:@"me.nepeta.axonnext.clearAllNotification" object:nil];
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"调试" message:@"所有已注册的AxonNext通知已被清除。" preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
  }]];
  return [self presentViewController:alert animated:YES completion:nil];
}
-(void)saveNotification {
  [[objc_getClass("NSDistributedNotificationCenter") defaultCenter] postNotificationName:@"me.nepeta.axonnext.saveNotification" object:nil];
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"调试" message:@"所有已注册的AxonNext通知已保存到 /var/mobile/Documents/AxonDebug.txt" preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
  }]];
  return [self presentViewController:alert animated:YES completion:nil];
}
-(void)report {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/qq1643240/axonnn/issues/new"] options:@{} completionHandler:nil];
}
@end

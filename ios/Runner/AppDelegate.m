#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyAfxEnHzdr3k9Cglf3WpNgzP1XGqLNX4nI"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  if (@available(iOS 10.0, *)) {
  [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
}

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

//
//  AppDelegate.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 13/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "dbconnect/DBCOnnectClass.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //SettingsViewController *svc= [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
   // self.window.rootViewController = svc;
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    int useid=[[def objectForKey:@"userId"] intValue];
    
    if (useid==0) {
        self.window.rootViewController = self.viewController;
        
    }else{
        HomeViewController *hvc=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        // UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:hvc];
        //[self presentViewController:hvc animated:NO completion:nil];
        self.window.rootViewController = hvc;
    }
    
    DBCOnnectClass *connectDb = [[DBCOnnectClass alloc] init];
    [connectDb copyDatabaseIfNeeded];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: ( UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
        
   // NSLog(@"/n float value == %f",(CGFloat)68/(CGFloat)255);
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.window.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(CGFloat)68/(CGFloat)255 green:(CGFloat)81/(CGFloat)255 blue:(CGFloat)143/(CGFloat)255 alpha:1.0]CGColor], (id)[[UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0]CGColor], nil];
//    //gradient.geometryFlipped = YES;
//    //[gradient setStartPoint:CGPointMake(0.0, 0.5)];
//    //[gradient setEndPoint:CGPointMake(1.0, 0.5)];
//    [self.window.layer addSublayer:gradient];
    
   // self.window.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
    
       return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    application.applicationIconBadgeNumber=0;
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSString* deviceToken1 = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:hexToken forKey:@"token"];
    [def synchronize];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber=0;
    NSLog(@"received push notification successfully");
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to  push notification for reason %@",[error localizedFailureReason]);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Push Notif" message:@"Failed to receice push message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

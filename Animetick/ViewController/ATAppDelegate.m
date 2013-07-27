//
//  ATAppDelegate.m
//  Animetick
//
//  Created by Kazuki Akamine on 2013/06/18.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATAppDelegate.h"
#import "ATLoginViewController.h"
#import "FMDatabase.h"
#import "ATDatabase.h"
#import "ATAuth.h"
#define DBFILE @"animetick.db"

@interface ATAppDelegate()
@property ATAuth *auth;
@end

@implementation ATAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.auth = [[ATAuth alloc] init];
    
    if (self.auth.sessionId == nil) {
        NSLog(@"session_id: not found.");
        ATLoginViewController *loginViewController = [[ATLoginViewController alloc] init];
        loginViewController.auth = self.auth;
        
        self.window.rootViewController = loginViewController;
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"session_id: %@", self.auth.sessionId);
    }

    /*
    NSString *session_id = self.getSessionId;
    if (session_id == NULL)
    {
        NSLog(@"session_id: not found.");
        UIViewController *loginViewController = [[ATLoginViewController alloc] init];
        self.window.rootViewController = loginViewController;
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"session_id: %@", session_id);
    }
     */
    
    return YES;
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

- (NSString *)getSessionId
{
    ATDatabase *atdb = ATDatabase.instance;
    FMDatabase *db = atdb.getDatabase;
    if (db == NULL) {
        return NULL;
    }
    NSString *sql = @"SELECT value FROM properties WHERE key = 'session_id'";
    FMResultSet *results = [db executeQuery:sql];
    NSString *session_id = NULL;
    if ([results next])
    {
        session_id = [results stringForColumnIndex:0];
    }
    return session_id;
}

@end

//
//  AppDelegate.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import "AppDelegate.h"
#import "MSConstants.h"
#import "MSPlayViewController.h"
#import "MSStartViewController.h"

#import <GrowthPush/GrowthPush.h>
#import <Appirater/Appirater.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    //TODO: GrowthPush設定 for App Store
//   [EasyGrowthPush setApplicationId:@"XXXX" secret:@"XXXX" environment:kGrowthPushEnvironment debug:NO];
    
    
    [Appirater setAppId:@"955311550"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    MSStartViewController *_startViewController = [MSStartViewController startViewController];
    
    
    //setings 初回起動時
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"settings"]){
        
        [[NSUserDefaults standardUserDefaults] setObject:@{@"fieldType":MSFieldType5x5, @"numberOfBombs":@(5)} forKey:@"settings"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    //best score
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"]){
        
        NSDictionary *bestScoreDict = @{
                                        MSBestScoreTypeField5x5_type1:@(0),
                                        MSBestScoreTypeField5x5_type2:@(0),
                                        MSBestScoreTypeField5x5_type3:@(0),
                                        MSBestScoreTypeField9x9_type1:@(0),
                                        MSBestScoreTypeField9x9_type2:@(0),
                                        MSBestScoreTypeField9x9_type3:@(0),
                                        MSBestScoreTypeField12x12_type1:@(0),
                                        MSBestScoreTypeField12x12_type2:@(0),
                                        MSBestScoreTypeField12x12_type3:@(0)
                                        };
        
        [[NSUserDefaults standardUserDefaults] setObject:@{
                                                           @"currentFieldType":MSBestScoreTypeField5x5_type1,
                                                           @"bestScore":bestScoreDict}
                                                  forKey:@"bestScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    self.window.rootViewController = _startViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

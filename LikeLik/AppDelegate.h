//
//  AppDelegate.h
//  LikeLik
//
//  Created by Vladimir Malov on 08.05.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UILabel  *alertLabel;
@property (nonatomic, assign) UIViewController *currentController;

+(UIFont *)OpenSansRegular:(CGFloat)size;
+(UIFont *)OpenSansSemiBold:(CGFloat)size;
+(UIFont *)OpenSansBoldwithSize:(CGFloat)size;


+(void)segmentControlMapList;
+(BOOL)isiPhone5;
+(void)lang;

@end
//
//  AppDelegate.m
//  LikeLik
//
//  Created by Vladimir Malov on 08.05.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//
NSString *localReceived = @"localReceived";
#import "AppDelegate.h"
//
#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "PlaceViewController.h"
#import "CheckViewController.h"

#import "SplashViewController.h"

#import <CoreText/CoreText.h>

#import "SCFacebook.h"
NSInteger wasinactive = NO;

//Enable for logging on
//#define LOGGING


#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define afterCall             @"l27h7RU2dzVfPoQQQQ"
#define afterFB             @"l27h7RU2dadsdafszVfPoQQQQ"
#define afternotification             @"l27h7RU2dzVfPoQssda"
#define backgroundg @"l27h7RU2123123132dzVfPoQssda"
#define backgroundTag 2442441
#define backgroundTag2 2442442


static NSString *const kTrackingId = @"UA-44026994-1";
static NSString *const kAllowTracking = @"allowTracking";


@implementation AppDelegate

//#warning воронка пользования
@synthesize alertLabel;

+(UIFont *)OpenSansRegular:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans" size:size/2];
    return font;
}
+(UIFont *)OpenSansSemiBold:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans-Semibold" size:size/2];
    // //    log([NSString stringWithFormat:@"%@",font);
    return font;
    
}

+(UIFont *)OpenSansBoldwithSize:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans-Bold" size:size/2];
    return font;
}

+(UIFont *)OpenSansLight:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:size/2];
    // //    log([NSString stringWithFormat:@"Light 26 = %@",font);
    return font;
}

+(BOOL)isiPhone5{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height < 500)
            return NO;  // iPhone 4S / 4th Gen iPod Touch or earlier
        else
            return YES;  // iPhone 5
    }
    else
    {
        return NO; // iPad
    }
}

+(void)segmentControlMapList{
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"segmentbar_background_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    /* Selected background */
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"segmentbar_background_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    /* Image between two unselected segments */
    UIImage *bothUnselectedImage = [[UIImage imageNamed:@"segmentbar_middle_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
    [[UISegmentedControl appearance] setDividerImage:bothUnselectedImage
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    /* Image between segment selected on the left and unselected on the right */
    UIImage *leftSelectedImage = [[UIImage imageNamed:@"segmentbar_middle_left_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
    [[UISegmentedControl appearance] setDividerImage:leftSelectedImage
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    /* Image between segment selected on the right and unselected on the left */
    UIImage *rightSelectedImage = [[UIImage imageNamed:@"segmentbar_middle_right_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
    [[UISegmentedControl appearance] setDividerImage:rightSelectedImage
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [AppDelegate OpenSansSemiBold:24], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    
}

+(void)lang{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"Language"] length] == 0){
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"ru"]){
            LocalizationSetLanguage(@"ru");
            [defaults setObject:@"Русский" forKey:@"Language"];
        }
        if ([language isEqualToString:@"en"]){
            LocalizationSetLanguage(@"en");
            [defaults setObject:@"English" forKey:@"Language"];
        }
        if ([language isEqualToString:@"de"]){
            LocalizationSetLanguage(@"de");
            [defaults setObject:@"Deutsch" forKey:@"Language"];
        }
        if ([language isEqualToString:@"ja"]){
            LocalizationSetLanguage(@"ja");
            [defaults setObject:@"Japanese" forKey:@"Language"];
        }
    }
    
    NSString *Lang = [defaults objectForKey:@"Language"];
    if ([Lang isEqualToString:@"Русский"])
        LocalizationSetLanguage(@"ru");
    if ([Lang isEqualToString:@"Deutsch"])
        LocalizationSetLanguage(@"de");
    if ([Lang isEqualToString:@"English"])
        LocalizationSetLanguage(@"en");
    if ([Lang isEqualToString:@"Japanese"])
        LocalizationSetLanguage(@"ja");

}

+(void)LLLog:(NSString *)string{
#ifdef LOGGING
    NSLog(@"%@", string);
#endif
}

- (UIImage*) blur:(UIImage*)theImage withFloat:(float)blurSize
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurSize] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(blurSize, 0, [inputImage extent].size.width - 2*blurSize, [inputImage extent].size.height)];
    
    //return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    return [[self class] scaleIfNeeded:cgImage];
}

+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 5;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
   
    
#if MOSCOW
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Likelik Moscow"
                                              trackingId:@"UA-44026994-2"];
    [AppDelegate LLLog:[NSString stringWithFormat:@"LikeLik MOSCOW onboard"]];
#endif
    
#if VIENNA
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Likelik Vienna"
                                              trackingId:@"UA-44026994-3"];
    [AppDelegate LLLog:[NSString stringWithFormat:@"LikeLik Vienna onboard"]];
#endif
    
#if LIKELIK
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Likelik"
                                              trackingId:kTrackingId];
    [AppDelegate LLLog:[NSString stringWithFormat:@"LikeLik onboard"]];
#endif
    
    [AppDelegate segmentControlMapList];
    [AppDelegate lang];
    
    [ExternalFunctions getReady];

        UIStoryboard *iPhone40Storyboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
        UIViewController *initialViewController = [iPhone40Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
        UIImageView *image =[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#if VIENNA
        image.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Vienna"]]];
        image.image = [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Vienna"]];
#else
        image.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Moscow"]]];
        image.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Moscow"]];
#endif
        image.tag = backgroundTag;
        [self.window.rootViewController.view insertSubview:image atIndex:0];
        
        UIImageView *image2 =[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        image2.backgroundColor = [UIColor blackColor];
    
#if VIENNA
        image2.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Vienna"]];
#else
        image2.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Moscow"]];
#endif
        image2.tag = backgroundTag2;
        [self.window.rootViewController.view insertSubview:image2 atIndex:0];
        
//    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate OpenSansBoldwithSize:20], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [SCFacebook initWithAppId:@"465683146835593"];
    
    
    // start of your application:didFinishLaunchingWithOptions
    
    // !!!: Use the next line only during beta
    // [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    
    [TestFlight takeOff:@"ea479ea2-6ad1-441d-994b-c32244e4f232"];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:backgroundg
                                                        object:self];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
{
    
    if (wasinactive){
        log([NSString stringWithFormat:@"was inactive"]);
        PlaceViewController *view;
        UINavigationController * myStoryBoardInitialViewController;
        if ([AppDelegate isiPhone5]) {
            view = [[UIStoryboard storyboardWithName:@"iPhone5" bundle:nil] instantiateViewControllerWithIdentifier:@"321"];
            myStoryBoardInitialViewController = [[UIStoryboard storyboardWithName:@"iPhone5" bundle:nil]instantiateInitialViewController];
        }
        else{
            
            view = [[UIStoryboard storyboardWithName:@"iPhone351" bundle:nil] instantiateViewControllerWithIdentifier:@"321"];
            myStoryBoardInitialViewController = [[UIStoryboard storyboardWithName:@"iPhone351" bundle:nil] instantiateInitialViewController];
        }
        view.navigationController.navigationBarHidden = NO;
//        view.PlaceCategory = [notification.userInfo objectForKey:@"Category"];
//        view.PlaceName = [notification.userInfo objectForKey:@"Place"];
//        view.PlaceCityName = [notification.userInfo objectForKey:@"City"];
//        view. = [notification.userInfo objectForKey:@"Photos"];
//        view.Color = [InterfaceFunctions colorTextCategory:@"Category"];
//
        

        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[notification.userInfo objectForKey:@"lat"] doubleValue] longitude:[[notification.userInfo objectForKey:@"lon"] doubleValue]];
        view.PlaceName = [notification.userInfo objectForKey:@"Place"];
        view.PlaceCategory = [notification.userInfo objectForKey:@"Category"];
        view.PlaceCityName = [notification.userInfo objectForKey:@"City"];
        view.PlaceAddress = [notification.userInfo objectForKey:@"Address"];
        view.PlaceAbout = [notification.userInfo objectForKey:@"About"];
        view.PlaceTelephone = [notification.userInfo objectForKey:@"Telephone"];
        view.PlaceWeb = [notification.userInfo objectForKey:@"Web"];
        view.PlaceLocation = loc;
        view.Color = [InterfaceFunctions colorTextCategory:[notification.userInfo objectForKey:@"Category"]];
        view.Photos = [notification.userInfo objectForKey:@"Photo"];
        view.fromNotification = @"YES";
      
        
        
        
        
        //      log([NSString stringWithFormat:@"userinfo = %@",notification.userInfo);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:view];
        [navController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        [[NSNotificationCenter defaultCenter] postNotificationName:afternotification object:self];
        //
        //
        //        UINavigationController *nvcontrol = [[UINavigationController alloc] initWithRootViewController:view];
        //
        //        [self.window addSubview:nvcontrol.view];
        //        [self.window makeKeyAndVisible];
        //      //  [[NSNotificationCenter defaultCenter] postNotificationName:afternotification object:self];
        //
        // [testflight passCheckpoint:[notification.userInfo objectForKey:@"Place"]];
        //
    }
    else{
        //      log([NSString stringWithFormat:@"another situation");
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:afterCall
                                                            object:self];
        
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    wasinactive = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    wasinactive = NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:afterFB
                                                        object:self];
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
}

#pragma mark - SCFacebook Handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_URL object:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_URL object:url];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}



@end

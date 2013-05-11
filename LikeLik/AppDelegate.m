//
//  AppDelegate.m
//  LikeLik
//
//  Created by Vladimir Malov on 08.05.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//
NSString *localReceived = @"localReceived";
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "PlaceViewController.h"
#import "CheckViewController.h"

#import "SplashViewController.h"

#import <CoreText/CoreText.h>

#import "SCFacebook.h"
NSInteger wasinactive = NO;
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define afterCall             @"l27h7RU2dzVfPoQQQQ"
#define afterFB             @"l27h7RU2dadsdafszVfPoQQQQ"
#define afternotification             @"l27h7RU2dzVfPoQssda"
#define backgroundg @"l27h7RU2123123132dzVfPoQssda"
@implementation AppDelegate


@synthesize alertLabel;
+(UIFont *)OpenSansRegular:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans" size:size/2];
    return font;
}
+(UIFont *)OpenSansSemiBold:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans-Semibold" size:size/2];
    // //    nslog(@"%@",font);
    return font;
    
}

+(UIFont *)OpenSansBoldwithSize:(CGFloat)size{
    UIFont* font = [UIFont fontWithName:@"OpenSans-Bold" size:size/2];
    return font;
}

+(UIFont *)OpenSansLight:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:size/2];
    // //    nslog(@"Light 26 = %@",font);
    return font;
}

+(UIColor *)color1withFlag:(NSInteger)flag{
    UIColor *color;
    flag+=1;
    flag%=11;
    switch (flag) {
        case 11:
            color = [UIColor colorWithRed:16.0/255.0 green:159.0/255.0 blue:64.0/255.0 alpha:1];
            break;
        case 10:
            color = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
            break;
        case 9:
            color = [UIColor colorWithRed:0.0/255.0 green:51.0/255.0 blue:204.0/255.0 alpha:1];
            break;
        case 8:
            color = [UIColor colorWithRed:102.0/255.0 green:0.0/255.0 blue:204.0/255.0 alpha:1];
            break;
        case 7:
            color = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:153.0/255.0 alpha:1];
            break;
        case 6:
            color = [UIColor colorWithRed:211.0/255.0 green:78.0/255.0 blue:34.0/255.0 alpha:1];
            break;
        case 5:
            color = [UIColor colorWithRed:253.0/255.0 green:179.0/255.0 blue:66.0/255.0 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:207.0/255.0 green:16.0/255.0 blue:207.0/255.0 alpha:1];
            break;
        case 1:
            color = [UIColor colorWithRed:207.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1];
            break;
            
        default:
            break;
    }
    return color;
}


+(NSArray * )ColorsForGradient{
    return [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:235.0/255.0 green: 235.0/255.0 blue: 235.0/255.0 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0] CGColor], nil];
}


+(UIView *)SelectedCellBG{
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    return myBackgroundView;
    
}


+(UIView *)CellBG{
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    [myBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [myBackgroundView setContentMode:UIViewContentModeScaleToFill];
    return myBackgroundView;
    

}

+(CALayer *)gradient:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
                            (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.4f],
                               nil];
    
    gradientLayer.cornerRadius = view.layer.cornerRadius;
    return gradientLayer;
    
}




+(UILabel *)AboutLabelwithString:(NSString *)string andheight:(CGFloat)height andNumberLines:(NSInteger)Lines{
    UILabel *AboutDistrict = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0, 310.0, height)];
    AboutDistrict.numberOfLines = Lines;
    [AboutDistrict setFont:[AppDelegate OpenSansBoldwithSize:26.0]];
    AboutDistrict.text = string;
    AboutDistrict.textAlignment = NSTextAlignmentLeft;
    AboutDistrict.backgroundColor = [UIColor clearColor];
    
    //
    //    [AboutDistrict sizeToFit];
    //    CGSize size1 =AboutDistrict.frame.size;
    //    size1.width=292.0;
    //    AboutDistrict.frame = CGRectMake(AboutDistrict.frame.origin.x, AboutDistrict.frame.origin.y, size1.width, size1.height);
    //    [AboutDistrict sizeThatFits:size1];
    
    return AboutDistrict;
}

+(UIImageView *)DistrictImage:(NSString *)image{
    UIImageView *districtimage= [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 0.0, 260.0, 60.0)];
    districtimage.image = [UIImage imageNamed:image];
    return districtimage;
    
}

+(UIView *)photScrollwithArray:(NSArray *)photos{
    return nil;
}



+(UIColor *)SelectedCellColor:(NSInteger)flag{
    return [AppDelegate color1withFlag:flag];
}


+(UIImageView *)accessorView{
    UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 0.0, 260.0, 60.0)];
    imageview.image = [UIImage imageNamed:@"actb_white.png"];
    imageview.frame = CGRectMake(293, 123, 9, 14);
    return imageview;
}

+(UIImageView *)BGForLabels{
    UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 0.0, 260.0, 60.0)];
    imageview.image = [UIImage imageNamed:@"Bg_gradient.png"];
    imageview.frame = CGRectMake(0.0, 0.0, imageview.image.size.width, imageview.image.size.height);//CGRectMake(293, 123, 9, 14);
    return imageview;
}


+(UIBarButtonItem *)back_button{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:AMLocalizedString(@"Back",nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [AppDelegate OpenSansSemiBold:24], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [backButton setBackgroundVerticalPositionAdjustment:-20.0f forBarMetrics:UIBarMetricsDefault];
    [backButton setBackButtonTitlePositionAdjustment:UIOffsetMake(3.0, 0.0) forBarMetrics:UIBarMetricsDefault];
    return backButton;
}

+(UIButton *)search_button{
    UIImage *buttonImage = [UIImage imageNamed:@"search_butt.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    aButton.imageEdgeInsets = UIEdgeInsetsMake(-0, 0, 0, 0);
    
    // Set the Target and Action for aButton
    
    
    return aButton;
}





+(UIButton *)segmentbar_map_list:(NSInteger)flag{
    UIButton *aButton;
    if (flag == 0) {
        UIImage *buttonImage = [UIImage imageNamed:@"segmentbar_map_tapped.png"];
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    }
    if (flag == 1) {
        UIImage *buttonImage = [UIImage imageNamed:@"segmentbar_list_tapped.png"];
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    }
    // Set the Target and Action for aButton
    
    
    return aButton;
}

+(UILabel *)LabelonPhoto:(NSString *)string andHeightofParentView:(CGFloat)height{
    //    nslog(@"Height = %f",height);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14.0, height-5.0, 300.0, 33)];
    label.text = string;//@"Москва";//self.Label;
    label.font = [AppDelegate OpenSansSemiBold:60];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    return  label;
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
    //  //    nslog(@"%@ %@" ,LocalizationGetLanguage,[[NSLocale preferredLanguages] objectAtIndex:0]);
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
        
    }
    
    NSString *Lang = [defaults objectForKey:@"Language"];
    if ([Lang isEqualToString:@"Русский"])
        LocalizationSetLanguage(@"ru");
    //    if ([Lang isEqualToString:@"English"])
    //        LocalizationSetLanguage(@"en");
    if ([Lang isEqualToString:@"Deutsch"])
        LocalizationSetLanguage(@"de");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //#warning !!!: Use the next line only during beta 2 string
    //  [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //  [ExternalFunctions makeAllChecksUnused];
    
    //   [TestFlight takeOff:@"92da971a-a358-42b8-8b57-554a866d1f7f"];
    // The rest of your application:didFinishLaunchingWithOptions method
    // ...
    
    [AppDelegate segmentControlMapList];
    
    [AppDelegate lang];
    [ExternalFunctions getReady];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480)
    {
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            
            //    nslog(@"asddsadasasd");
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iphone351
            UIStoryboard *ios5iphone35Storyboard = [UIStoryboard storyboardWithName:@"ios5" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [ios5iphone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        else{
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iphone351
            UIStoryboard *iphone35Storyboard = [UIStoryboard storyboardWithName:@"iPhone351" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iphone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
    }
    
    if (iOSDeviceScreenSize.height == 568)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone40Storyboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
        
        UIViewController *initialViewController = [iPhone40Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate OpenSansBoldwithSize:20], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    //    if ([self didCrashInLastSessionOnStartup]) {
    //    }
    //    else {
    //        [self setupApplication];
    //    }
    
    [SCFacebook initWithAppId:@"465683146835593"];
    return YES;
}

//- (BOOL)didCrashInLastSessionOnStartup {
//    return ([[BITHockeyManager sharedHockeyManager].crashManager didCrashInLastSession] &&
//            [[BITHockeyManager sharedHockeyManager].crashManager timeintervalCrashInLastSessionOccured] < 5);
//}

- (void)setupApplication {
    // setup your app specific code
}

//#pragma mark - BITCrashManagerDelegate
//
//- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager {
//    if ([self didCrashInLastSessionOnStartup]) {
//        [self setupApplication];
//    }
//}
//
//- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error {
//    if ([self didCrashInLastSessionOnStartup]) {
//        [self setupApplication];
//    }
//}
//
//- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager {
//    if ([self didCrashInLastSessionOnStartup]) {
//        [self setupApplication];
//    }
//}
//
//
//- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
//#ifndef CONFIGURATION_AppStore
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
//        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
//#endif
//    return nil;
//}

//+(UIImage *)ribbon:(UIColor *)color{
//    NSInteger flag = 99;
//    if ([color isEqual:[AppDelegate color1withFlag:0]])
//        flag = 11;
//    if ([color isEqual:[AppDelegate color1withFlag:1]])
//        flag = 10;
//    if ([color isEqual:[AppDelegate color1withFlag:2]])
//        flag = 9;
//    if ([color isEqual:[AppDelegate color1withFlag:3]])
//        flag = 8;
//    if ([color isEqual:[AppDelegate color1withFlag:4]])
//        flag = 7;
//    if ([color isEqual:[AppDelegate color1withFlag:5]])
//        flag = 6;
//    if ([color isEqual:[AppDelegate color1withFlag:6]])
//        flag = 5;
//    if ([color isEqual:[AppDelegate color1withFlag:7]])
//        flag = 4;
//    if ([color isEqual:[AppDelegate color1withFlag:8]])
//        flag = 3;
//    if ([color isEqual:[AppDelegate color1withFlag:9]])
//        flag = 2;
//    if ([color isEqual:[AppDelegate color1withFlag:10]])
//        flag = 1;
//    NSString *name = [NSString stringWithFormat:@"Ribbon_%d.png",flag];
//    return [UIImage imageNamed:name];
//}
+(UIImage *)check_background:(UIColor *)color{
    NSInteger flag = 0;
    if ([color isEqual:[AppDelegate color1withFlag:0]])
        flag = 11;
    if ([color isEqual:[AppDelegate color1withFlag:1]])
        flag = 10;
    if ([color isEqual:[AppDelegate color1withFlag:2]])
        flag = 9;
    if ([color isEqual:[AppDelegate color1withFlag:3]])
        flag = 8;
    if ([color isEqual:[AppDelegate color1withFlag:4]])
        flag = 7;
    if ([color isEqual:[AppDelegate color1withFlag:5]])
        flag = 6;
    if ([color isEqual:[AppDelegate color1withFlag:6]])
        flag = 5;
    if ([color isEqual:[AppDelegate color1withFlag:7]])
        flag = 4;
    if ([color isEqual:[AppDelegate color1withFlag:8]])
        flag = 3;
    if ([color isEqual:[AppDelegate color1withFlag:9]])
        flag = 2;
    if ([color isEqual:[AppDelegate color1withFlag:10]])
        flag = 1;
    NSString *name = [NSString stringWithFormat:@"check_background_%d-568h.png",flag];
    return [UIImage imageNamed:name];
}






+(UIButton *)done_button{
    UIImage *buttonImage = [UIImage imageNamed:@"done_button"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel  setFont:[AppDelegate OpenSansRegular:24]];
    [aButton setTitle:AMLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [aButton sizeToFit];
    //    CGRect rect = aButton.frame;
    //
    //
    //    rect.size.width *=1.1;
    //    aButton.frame = rect;
    return aButton;
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:backgroundg
                                                        object:self];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
{
    
    if (wasinactive){
        NSLog(@"was inactive");
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
        view.PlaceCategory = [notification.userInfo objectForKey:@"Category"];
        view.PlaceName = [notification.userInfo objectForKey:@"Place"];
        view.PlaceCityName = [notification.userInfo objectForKey:@"City"];
        view.Color = [InterfaceFunctions colorTextCategory:@"Category"];
        view.fromNotification = @"YES";
        
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
        //        //[TestFlight passCheckpoint:[notification.userInfo objectForKey:@"Place"]];
        //
    }
    else{
        //      NSLog(@"another situation");
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:afterCall
                                                            object:self];
        
    }
    
}







- (void)applicationWillEnterForeground:(UIApplication *)application
{
    wasinactive = YES;
    //  NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    wasinactive = NO;
    //  NSLog(@"applicationDidBecomeActive");
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:afterCall
    //                                                        object:self];
    //
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:afterFB
                                                        object:self];
    
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

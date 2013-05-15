//
//  SplashViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 11.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "AboutTableViewController.h"
#import "RegistrationViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//#import "UIViewController+KNSemiModal.h"
@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize locationManagerRegion,locationManager;
@synthesize alertLabel;
@synthesize message;
@synthesize localNotification;
static BOOL haveAlreadyReceivedCoordinates = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



-(void)startTracking{
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
#warning regions
    if (haveAlreadyReceivedCoordinates) {
        Me = newLocation;
        NSLog(@"%@",Me);
//#warning надо переделать под новый каталог
//        NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
//
////        NSDictionary *Place = [NSDictionary dictionaryWithDictionary:[ExternalFunctions getPlaceByCLRegion:[Region objectAtIndex:2]]];
////        NSLog(@"%@",Place);
////        localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
////        [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
////        [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
////        [localNotification setAlertBody:[NSString stringWithFormat:@"%@",[Place objectForKey:@"Place"]]];
////        [localNotification setHasAction: YES];
////        [localNotification setApplicationIconBadgeNumber:1];
////        [localNotification setUserInfo:[NSDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithDictionary:Place]]];
////        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
////        
//        
//        
//        
//        for (int i = 0; i<[Region count]; i++) {
//            [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
//        }
        [locationManager stopUpdatingLocation];
        locationManager = nil;
     //   NSLog(@"%@",Region);
    }
    else{
        haveAlreadyReceivedCoordinates = YES;
    }


    //

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
//#warning надо переделать под новый каталог
    NSDictionary *Place = [NSDictionary dictionaryWithDictionary:[ExternalFunctions getPlaceByCLRegion:region]];
    localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@",region.identifier]];
    [localNotification setHasAction: YES];
    [localNotification setApplicationIconBadgeNumber:1];
    [localNotification setUserInfo:[NSDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithDictionary:Place]]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
   
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
    
    //NSLog(@"%@",[ExternalFunctions getPlacesAroundMyLocation:Me InCity:@"Moscow"]);
    
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    
    
    
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    self.HUDfade.userInteractionEnabled = NO;
    self.HUDfade.mode = MBProgressHUDAnimationFade;
    self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
        [self.HUDfade show:YES];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    if ([[defaults objectForKey:@"Language"] length] == 0) {
//        [defaults setObject:@"English" forKey:@"Language"];
//    }
//    
//    
//    if ([[defaults objectForKey:@"Measure"] length] == 0) {
//        [defaults setObject:@"Miles" forKey:@"Measure"];
//    }
//    [defaults synchronize];
//    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
 
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"Language"] length] == 0) {
         [defaults setObject:@"English" forKey:@"Language"];
    }

    
    if ([[defaults objectForKey:@"Measure"] length] == 0) {
        [defaults setObject:@"Miles" forKey:@"Measure"];
    }
    [defaults synchronize];
        
    CGRect Shadeframe = self.Shade.frame;
    CGRect Fistframe = self.fist.frame;

    if ([AppDelegate isiPhone5]) {
        
        Shadeframe.origin.y-=340.0;
        Fistframe.origin.y-=340.0;
    }
    else{
        
        Shadeframe.origin.y-=270.0;
        Fistframe.origin.y-=270.0;

    }
    
    
    // скачивание
    if (![[defaults objectForKey:@"Download"] isEqualToString:@"1"]) {
        [ExternalFunctions downloadCatalogue:@"test"];
        [defaults setObject:@"1" forKey:@"Download"];
        [self.HUDfade show:YES];
    }
    
    [UIView animateWithDuration:1.2 animations:^{
        self.Shade.frame = Shadeframe;
        self.fist.frame = Fistframe;
    }
                     completion:^(BOOL finished){
                         self.Firsttitle.hidden = NO;
                         self.subtitle.hidden = NO;
                         self.Firsttitle.alpha = 1;
                         self.subtitle.alpha = 1;
                         [self.HUDfade hide:YES];
                         [self performSegueWithIdentifier:@"fistSegue" sender:self];
                     }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
  //  [locationManagerRegion stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (void)viewDidUnload {
    [self setMaintitle:nil];
    [super viewDidUnload];
}

@end

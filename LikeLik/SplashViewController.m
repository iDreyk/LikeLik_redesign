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

static NSInteger j=0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)startTracking{
}

-(void) stopUpdating{
    [locationManager stopUpdatingLocation];
    NSLog(@"Notification сработал");
}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    dispatch_queue_t backGroundQueue;
//    
//    backGroundQueue = dispatch_queue_create("backGroundQueueForRegions", NULL);
//    dispatch_async(backGroundQueue, ^{
//        // post an NSNotification that loading has started
//        NSLog(@"start background queue");
//        NSLog(@"j=%d",j);
//        if (j==0) {
//            j++;
//            Me = newLocation;
//            
//            NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
//            
//            
//            NSLog(@"Зашел в счетчик");
//            for (int i = 0; i<[Region count]; i++) {
//                [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
//            }
//        }
//        NSLog(@"after j = %d",j);
//        // post an NSNotification that loading is finished
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"stopUpdating" object:nil]];
//    });
//    
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (j==0) {
        Me = newLocation;
        
        //  NSLog(@"%@",Me);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Me];
        [defaults setObject:data forKey:@"location"];
        
        NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
        
        j++;
        NSLog(@"Зашел в счетчик");
        for (int i = 0; i<[Region count]; i++) {
            [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
        }
        [locationManager stopUpdatingLocation];
    }
    NSLog(@"Monitored regions: %d",[[locationManager monitoredRegions] count]);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSDictionary *Place = [NSDictionary dictionaryWithDictionary:[ExternalFunctions getPlaceByCLRegion:region]];
    localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    
    [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@ %@", AMLocalizedString(@"You are next to", nil),[Place objectForKey:@"Name"]]];
    [localNotification setHasAction: YES];
    [localNotification setApplicationIconBadgeNumber:1];
    
    
    CLLocation *loc = [Place objectForKey:@"Location"];
    NSString *lat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[Place objectForKey:@"Name"] forKey:@"Place"];
    [dictionary setObject:[Place objectForKey:@"Category"] forKey:@"Category"];
    [dictionary setObject:[Place objectForKey:@"City"] forKey:@"City"];
    [dictionary setObject:[Place objectForKey:@"Address"] forKey:@"Address"];
    [dictionary setObject:[Place objectForKey:@"About"] forKey:@"About"];
    [dictionary setObject:[Place objectForKey:@"Telephone"] forKey:@"Telephone"];
    [dictionary setObject:[Place objectForKey:@"Web"] forKey:@"Web"];
    [dictionary setObject:lat forKey:@"lat"];
    [dictionary setObject:lon forKey:@"lon"];
    [dictionary setObject:[Place objectForKey:@"Photo"] forKey:@"Photo"];
    
    [localNotification setUserInfo:dictionary];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdating) name:@"stopUpdating" object:nil];
    
    locationManagerRegion = [[CLLocationManager alloc] init];
    [locationManagerRegion setDelegate:self];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        [locationManager startUpdatingLocation];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Back on main thread");
        });
    });
    

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
    
    //NSLog(@"%@",[ExternalFunctions getPlacesAroundMyLocation:Me InCity:@"Moscow"]);
    
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    
    
    
    //    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    //    [self.navigationController.view addSubview:self.HUDfade];
    //    self.HUDfade.userInteractionEnabled = NO;
    //    self.HUDfade.mode = MBProgressHUDAnimationFade;
    //    self.HUDfade.removeFromSuperViewOnHide = YES;
    //    self.HUDfade.delegate = self;
    //    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
    //        [self.HUDfade show:YES];
    //
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

    
    [UIView animateWithDuration:1.2 animations:^{
        self.Shade.frame = Shadeframe;
        self.fist.frame = Fistframe;
    }
                     completion:^(BOOL finished){
                         self.Firsttitle.hidden = NO;
                         self.subtitle.hidden = NO;
                         self.Firsttitle.alpha = 1;
                         self.subtitle.alpha = 1;
                         //     [self.HUDfade hide:YES];
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

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

#import "RegistrationViewController.h"

#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString *city = @"";

//#import "UIViewController+KNSemiModal.h"
@interface SplashViewController ()

@end
//testing git
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
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    dispatch_queue_t backGroundQueue;
    
    backGroundQueue = dispatch_queue_create("backGroundQueueForRegions", NULL);
    dispatch_async(backGroundQueue, ^{
        [ExternalFunctions getReady];
        log([NSString stringWithFormat:@"start background queue"]);
        if (j==0) {
            j++;
            Me = newLocation;
            
            NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
            for (int i = 0; i<[Region count]; i++) {
                [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"stopUpdating" object:nil]];
    });

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

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha andPict:(UIImage *)pic{
    UIGraphicsBeginImageContextWithOptions(pic.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, pic.size.width, pic.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, pic.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Splash Screen"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];


#if VIENNA
    city = @"Vienna";
#endif
    
#if MOSCOW
    city = @"Moscow";
#endif
    
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdating) name:@"stopUpdating" object:nil];
    
    locationManagerRegion = [[CLLocationManager alloc] init];
    [locationManagerRegion setDelegate:self];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        [locationManager startUpdatingLocation];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            log([NSString stringWithFormat:@"Back on main thread"]);
        });
    });
}

-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidDisappear:(BOOL)animated{
    //  [locationManagerRegion stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)viewDidUnload {
    log([NSString stringWithFormat:@"Unload"]);
    [self setMaintitle:nil];
    [super viewDidUnload];
}

@end

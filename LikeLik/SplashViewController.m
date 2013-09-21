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
#import "AFDownloadRequestOperation.h"
#import "Reachability.h"

#define catalogue @"Catalogues"
#define likelikurlwifi_4        @"http://likelik.net/ios/online/4/"
#define likelikurlwifi_5        @"http://likelik.net/ios/online/5/"
#define likelikurlcell_4        @"http://likelik.net/ios/online/4/"
#define likelikurlcell_5        @"http://likelik.net/ios/online/5/"
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
 //   log([NSString stringWithFormat:@"Notification сработал");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    dispatch_queue_t backGroundQueue;
    
    backGroundQueue = dispatch_queue_create("backGroundQueueForRegions", NULL);
    dispatch_async(backGroundQueue, ^{
        [ExternalFunctions getReady];
        // post an NSNotification that loading has started
        log([NSString stringWithFormat:@"start background queue"]);
  //      log([NSString stringWithFormat:@"j=%d",j);
        if (j==0) {
            j++;
            Me = newLocation;
            
            NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
            
            
       //     log([NSString stringWithFormat:@"Зашел в счетчик");
            for (int i = 0; i<[Region count]; i++) {
                [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
            }
        }
      //  log([NSString stringWithFormat:@"after j = %d",j);
        // post an NSNotification that loading is finished
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

-(void)ShowAlertView{
    //NSString *str = [NSString stringWithFormat:@"%@ %@ Mb",AMLocalizedString(@"You are up to download LikeLik Catalogue", nil),[self retrieveFileSizeFromServer]];
    NSString *str = AMLocalizedString(@"You are up to download LikeLik Catalogue", nil);
    UIAlertView *message1 = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Download", nil)
                                                      message:str
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"Next time", nil)
                                            otherButtonTitles:@"Ok",nil];
    [message1 show];
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
    }
    else{
        [self startDownloading];
    }
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

    // Send the screen view.
#if VIENNA
    city = @"Vienna";
#endif
    
#if MOSCOW
    city = @"Moscow";
#endif
    
#if LIKELIK
#else
    if (![ExternalFunctions isDownloaded:city]) {
       
        [self ShowAlertView];
    }
//    else
//        [self prepareAroundMe];
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

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setTranslucent:YES];
    [localNotification setAlertAction:AMLocalizedString(@"Launch", nil)];
    
    //log([NSString stringWithFormat:@"%@",[ExternalFunctions getPlacesAroundMyLocation:Me InCity:@"Moscow"]);
    
    
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
#if LIKELIK
                         [self performSegueWithIdentifier:@"fistSegue" sender:self];
                         
#endif
#if VIENNA
                         [self performSegueWithIdentifier:@"CitySegue" sender:self];
#endif
#if MOSCOW
                         [self performSegueWithIdentifier:@"CitySegue" sender:self];
#endif
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
    log([NSString stringWithFormat:@"Unload"]);
    [self setMaintitle:nil];
    [super viewDidUnload];
}


- (void) AFdownload : (NSString *) filename fromURL : (NSString *) likelikUrl{
    
    
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.HUDfade.mode = MBProgressHUDAnimationFade;
    self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
        [self.HUDfade show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@.zip",likelikUrl,filename];
  //  log([NSString stringWithFormat:@"%@",url);
    NSString *zipFile = [[NSString alloc] initWithFormat:@"%@.zip",filename];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:zipFile];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self DownloadSucceeded:filename];
        
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark@2x"]];
        self.HUDfade.mode = MBProgressHUDModeCustomView;
        self.HUDfade.labelText = AMLocalizedString(@"Ready!", nil);
        [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                                onTarget:self withObject:nil animated:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
        self.HUDfade.mode = MBProgressHUDModeCustomView;
        self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
        [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                                onTarget:self withObject:nil animated:YES];
        
        [self DownloadError:error];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [operation start];
    double CurrentTime1 = CACurrentMediaTime();
    
    //Setup Upload block to return progress of file upload
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        BOOL i = YES;
        double currentTime = 0.0;
        if (i) {
            currentTime = CurrentTime1;
            i = NO;
        }
        
        double currentTime2 = CACurrentMediaTime();
        
        float progress = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile * 100;
        //
        //        int result = (int)floorf(progress*100);
        double speed = (totalBytesRead / (currentTime2 - currentTime));
        double bytes_left = totalBytesExpected - totalBytesRead;
        double time_left = bytes_left / speed;
        
        int secs = time_left;
        //int h = secs / 3600;
        int m = secs / 60 % 60;
        int s = secs % 60;
        
//        NSString *text = [NSString stringWithFormat:@"%02d:%02d", m, s];
        if (m == 0 && s==0) {
            
            self.HUDfade.labelText = AMLocalizedString(@"Data processing", nil);
        }
        else
            self.HUDfade.labelText = [NSString stringWithFormat:@"%.1f %%",progress];
        //log([NSString stringWithFormat:@"Time left: %@ \n Speed: %f",text,speed);
        currentTime = currentTime2;
    }];
    
    
    
}

- (void) DownloadSucceeded:(NSString *)fileName {
    NSString *zipFile = [[NSString alloc] initWithFormat:@"%@.zip",fileName];
    NSString *newCataloguePath = [[NSString alloc]initWithFormat:@"%@/%@/catalogue.plist",[ExternalFunctions docDir],fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:zipFile];
    [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    [ExternalFunctions unzipFileAt:path ToDestination:[paths objectAtIndex:0]];
    NSString *crapPath = [[ExternalFunctions docDir]stringByAppendingPathComponent:@"__MACOSX"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:crapPath error:nil];
    
    NSString *cataloguesPath = [[ExternalFunctions docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    
    NSMutableArray *catalogueArray = [[NSMutableArray alloc] initWithContentsOfFile:cataloguesPath];
    NSArray *newCatalogues = [[NSArray alloc] initWithContentsOfFile:newCataloguePath];
    NSDictionary *temp;
    
    for (int i = 0; i < [newCatalogues count]; i++) {
        if ([[[newCatalogues objectAtIndex:i] objectForKey:@"city_EN"] isEqualToString:fileName]) {
            temp = [newCatalogues objectAtIndex:i];
        }
    }
    for (int i = 0; i < [catalogueArray count]; i++) {
        if ([[[catalogueArray objectAtIndex:i] objectForKey:@"city_EN"] isEqualToString:fileName]) {
            [catalogueArray removeObjectAtIndex:i];
        }
    }
    
    //#warning один раз тут вылетело, но приложение было свернуто [catalogueArray addObject:temp];
    [catalogueArray addObject:temp];
    
    [[NSFileManager defaultManager] removeItemAtPath:cataloguesPath error:nil];
    
    [catalogueArray writeToFile:cataloguesPath atomically:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:catalogueArray forKey:catalogue];
    
    [ExternalFunctions addCityToDownloaded:fileName];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAllCatalogues" object:nil];
}

- (NSError *) DownloadError:(NSError *) error{
   // log([NSString stringWithFormat:@"error = %d",error.code);
   // log([NSString stringWithFormat:@"error description = %@",error.description);
    return error;
}

- (void)waitForTwoSeconds {
    sleep(3);
}

- (void) startDownloading {
//    log([NSString stringWithFormat:@"Согласился на покупку");
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"google.com"];
    
    if ([reach isReachable]) {
        if ([reach isReachableViaWiFi]) {
            // On WiFi
            
            if(IS_IPHONE_5 == 1)
                [self AFdownload:city fromURL:likelikurlwifi_5];
            else
                [self AFdownload:city fromURL:likelikurlwifi_4];
            
        //    log([NSString stringWithFormat:@"Downloading via Wi-Fi");
        }
        else {
            // On Cell
            
            
            
            if(IS_IPHONE_5 == 1)
                [self AFdownload:city fromURL:likelikurlcell_5];
            else
                [self AFdownload:city fromURL:likelikurlcell_4];
            
            
        //    log([NSString stringWithFormat:@"Downloading via cell network");
        }
        
    } else {
        // Isn't reachable
        self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.HUDfade];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
        self.HUDfade.mode = MBProgressHUDModeCustomView;
        self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
        [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds) onTarget:self withObject:nil animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

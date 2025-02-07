//
//  CategoryViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 30.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "PlaceslistViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "VisualTourViewController.h"
#import "ScrollinfoViewController.h"
#import <MapBox/MapBox.h>
#import "PlaceViewController.h"
#import "MLPAccessoryBadge.h"
#import <QuartzCore/QuartzCore.h>
#import "TransportationViewController.h"
#import "ExternalFunctions.h"
#import "AFDownloadRequestOperation.h"
#import "Reachability.h"

#define catalogue @"Catalogues"
#define likelikurlwifi_4        @"http://likelik.net/ios/docs/4/"
#define likelikurlwifi_5        @"http://likelik.net/ios/docs/5/"
#define likelikurlcell_4        @"http://likelik.net/ios/cell/4/"
#define likelikurlcell_5        @"http://likelik.net/ios/cell/5/"
#define likelikurlonline_4      @"http://likelik.net/ios/online/4/"
#define likelikurlonline_5      @"http://likelik.net/ios/online/5/"
#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static BOOL IS_LOADING;
static BOOL IN_BG;
static NSString *currentCity = @"";

#define textinFrame 131313
#define EF_TAG 66483
#define FADE_TAG 66484
#define backgroundTag 2442441
#define backgroundTag2 2442442

#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
static NSString *city = @"";
static NSInteger j=0;
@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize locationManager2,locationManagerRegion,localNotification;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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


-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidDisappear:(BOOL)animated{

}

- (void)viewDidLoad
{
    if ([AMLocalizedString(@"Moscow", nil) isEqualToString:self.Label]) {
        currentCity = @"Moscow";
        city = currentCity;
    }
    else{
        currentCity = @"Vienna";
        city = currentCity;
    }
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];

 //   [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    IN_BG = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    _locationManager1 = [[CLLocationManager alloc] init];
    [_locationManager1 setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager1 startUpdatingLocation];
    
    self.categoryView.backgroundColor = [UIColor clearColor];
    
    [self.categoryView setScrollEnabled:YES];
    self.categoryView.showsHorizontalScrollIndicator = NO;
    self.categoryView.showsVerticalScrollIndicator = NO;
    
    [self.categoryView setContentSize:CGSizeMake(320, 480)];
    [self.categoryView flashScrollIndicators];
    self.categoryView.delegate = self;
    
    
    
    
        //    self.Table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
    
#if MOSCOW
    self.Label = @"Moscow";
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
#endif
#if VIENNA
    self.Label = @"Vienna";
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
#endif
    
#if VIENNA
    city = @"Vienna";
#endif
    
#if MOSCOW
    city = @"Moscow";
#endif
    
#if LIKELIK
    if (![ExternalFunctions isDownloaded:currentCity]) {
        
        [self ShowAlertView];
    }
#else
    if (![ExternalFunctions isDownloaded:city]) {
        
        [self ShowAlertView];
    }
    //    else
    //        [self prepareAroundMe];
#endif


    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
    background.tag = backgroundTag;
    UIImageView *background2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -66 - 150, 320, 718)];
    background2.tag = backgroundTag2;
    
    background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_blur",[[ExternalFunctions cityCatalogueForCity:self.Label] objectForKey:@"city_EN"]]];
    background2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_paralax",[[[ExternalFunctions cityCatalogueForCity:self.Label] objectForKey:@"city_EN"] lowercaseString]]];
    
    [self.view addSubview:background2];
    [self.view addSubview:background];
    
    [self.view bringSubviewToFront:self.categoryView];
    [self.view bringSubviewToFront:self.MapPlace];

    self.CityImage.image =  [UIImage imageNamed:[ExternalFunctions larkePictureOfCity:self.Label]];
    self.CellArray = @[@"Around Me", @"Restaurants",@"Night life",@"Shopping",@"Culture",@"Leisure", @"Beauty",@"Visual Tour", @"Metro",@"Search",@"Favorites",  @"Practical Info"];
    
    self.SegueArray = @[@"AroundmeSegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"VisualtourSegue",@"TransportationSegue",@"SearchSegue",@"FavoritesSegue",@"PracticalinfoSegue"];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
#if LIKELIK
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    NSURL *url;
    if ([self.Label isEqualToString:@"Moscow"] || [self.Label isEqualToString:@"Москва"] || [self.Label isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.Label isEqualToString:@"Vienna"] || [self.Label isEqualToString:@"Вена"] || [self.Label isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    [self.MapPlace setTileSource:offlineSource];
    self.MapPlace.hidden = NO;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    
    self.MapPlace.minZoom = 10;
    self.MapPlace.zoom = 13;
    self.MapPlace.maxZoom = 17;
    
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
  //  self.MapPlace.showsUserLocation = YES;
    [self.MapPlace setHidden:YES];

#else

    self.navigationItem.hidesBackButton = YES;
    
    UIButton *btn = [InterfaceFunctions Pref_button];
    [btn addTarget:self action:@selector(Pref) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
#endif
    
    
    IS_LOADING = YES;
    if([ExternalFunctions isDownloaded:self.Label]){
        UIView *fade = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        fade.tag = FADE_TAG;
        fade.backgroundColor = [UIColor clearColor];
        [self.navigationController.view addSubview:fade];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // post an NSNotification that loading has started
            
            AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.Label];
            RMAnnotation *marker1;
            
            for (int i=0; i<[AroundArray count]; i++) {
                CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
                marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:tmp.coordinate andTitle:@"Pin"];
                marker1.annotationType = @"marker";
                marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
                marker1.subtitle = AMLocalizedString([[AroundArray objectAtIndex:i] objectForKey:@"Category"], nil);
                marker1.userInfo = [AroundArray objectAtIndex:i];
                [self.MapPlace addAnnotation:marker1];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                log([NSString stringWithFormat:@"Back on main thread"]);
                IS_LOADING = NO;
                [self getSoonLabels];
                [self removeKnuckleHUD];
                
              //  log([NSString stringWithFormat:@"remove knuckle animation");
            });
            // post an NSNotification that loading is finished
        });
    }
    self.categoryView.contentSize = CGSizeMake(320, 505);
    CGFloat frameSize = 93.0;
    CGFloat xOrigin = 10;
    CGFloat yOrigin = 40; // 20 (без + 44)
    CGFloat yOffset = 10;
    
    if(self.view.bounds.size.height == 460.0 || self.view.bounds.size.height == 480.0){
        yOrigin = 0;
        self.categoryView.contentSize = CGSizeMake(320.0, 421.0);
    }
    
    self.frame1 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, yOrigin + yOffset, frameSize, frameSize)];
    UIView *frame2 = [[UIView alloc] initWithFrame:CGRectMake(frameSize +2*xOrigin, yOrigin + yOffset, frameSize, frameSize)];
    UIView *frame3 = [[UIView alloc] initWithFrame:CGRectMake(2*frameSize + 3*xOrigin, yOrigin + yOffset, frameSize, frameSize)];
    UIView *frame4 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, frameSize + yOrigin + 2*yOffset, frameSize, frameSize)];
    UIView *frame5 = [[UIView alloc] initWithFrame:CGRectMake(frameSize +2*xOrigin, frameSize + yOrigin + 2*yOffset, frameSize, frameSize)];
    UIView *frame6 = [[UIView alloc] initWithFrame:CGRectMake(2*frameSize + 3*xOrigin, frameSize + yOrigin + 2*yOffset, frameSize, frameSize)];
    UIView *frame7 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 2*frameSize + yOrigin + 3*yOffset, frameSize, frameSize)];
    UIView *frame8 = [[UIView alloc] initWithFrame:CGRectMake(frameSize +2*xOrigin, 2*frameSize + yOrigin + 3*yOffset, frameSize, frameSize)];
    UIView *frame9 = [[UIView alloc] initWithFrame:CGRectMake(2*frameSize + 3*xOrigin, 2*frameSize + yOrigin + 3*yOffset, frameSize, frameSize)];
    UIView *frame10 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 3*frameSize + yOrigin + 4*yOffset, frameSize, frameSize)];
    UIView *frame11 = [[UIView alloc] initWithFrame:CGRectMake(frameSize +2*xOrigin, 3*frameSize + yOrigin + 4*yOffset, frameSize, frameSize)];
    UIView *frame12 = [[UIView alloc] initWithFrame:CGRectMake(2*frameSize + 3*xOrigin, 3*frameSize + yOrigin + 4*yOffset, frameSize, frameSize)];
    if(!self.frameArray)
        self.frameArray = [[NSArray alloc] init];
    
    self.frameArray = @[self.frame1, frame2, frame3, frame4, frame5, frame6, frame7, frame8, frame9, frame10, frame11, frame12];
    
    int i = 0;
    for (UIView *frame in self.frameArray){
        frame.tag = i;
        frame.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i+1]] scaledToSize:CGSizeMake(frameSize, frameSize)]];
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(1, 64, 91, 28)];
        text.text = AMLocalizedString([self.CellArray objectAtIndex:frame.tag], nil);
        text.backgroundColor = [UIColor clearColor];
        text.textColor = [UIColor whiteColor];
        text.tag = textinFrame;
        [text setFont:[AppDelegate OpenSansSemiBold:22]];
        text.textAlignment = NSTextAlignmentCenter;
        [frame addSubview:text];
        CALayer *layer = frame.layer;
        layer.cornerRadius = 5;
        //frame.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
        [frame addGestureRecognizer:tap];
        [frame setUserInteractionEnabled:YES];
        [self.categoryView addSubview:frame];
        ++i;
    }
    
    if([ExternalFunctions isDownloaded:self.Label]){
        UIView *coolEf = [[UIView alloc] initWithFrame:self.view.frame];
        coolEf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        coolEf.tag = EF_TAG;
        [self.view addSubview:coolEf];
        [UIView animateWithDuration:0.2 animations:^{
            coolEf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            UIView *spin = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 90, 45, 45)];
            //knuckle_1@2x.png
            spin.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"kul_90.png"] scaledToSize:CGSizeMake(45, 45)]];
            //spin.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            CALayer *layer = spin.layer;
            layer.cornerRadius = 8;
            spin.clipsToBounds = YES;
            CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
            animation.fromValue = [NSNumber numberWithFloat:0.0f];
            animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
            animation.duration = 3.0f;
            animation.repeatCount = HUGE_VAL;
            [spin.layer addAnimation:animation forKey:@"knuckleAnimation"];
            [coolEf addSubview:spin];
          //  log([NSString stringWithFormat:@"start knuckle animation in viewDidLoad");
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reloadCatalogue) name:@"reloadAllCatalogues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reloadCatalogue) name:@"reloadAllCatalogues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startHUD)
                                                 name: @"startHUD"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopHUDWithSuccess)
                                                 name: @"stopHUDWithSuccess"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopHUDWithFailure)
                                                 name: @"stopHUDWithFailure"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(popViewController)
                                                 name: @"popViewController"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reloadMapView)
                                                 name: @"reloadMapView"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showNoInternetConnectionHUD)
                                                 name: @"showNoInternetConnectionHUD"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(dataProcessingHUD)
                                                 name: @"dataProcessingHUD"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showDownloadProgressHUD)
                                                 name: @"showDownloadProgressHUD"
                                               object: nil];
}


-(void)viewDidAppear:(BOOL)animated{
    
    self.view.hidden = NO;
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@" %@ Category Screen",currentCity]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    if ([[[CLLocation alloc] initWithLatitude:self.MapPlace.userLocation.coordinate.latitude longitude:self.MapPlace.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.Label]] > 50000.0) {
        self.MapPlace.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.Label].coordinate;
        //    log([NSString stringWithFormat:@"Взяли центр города");
        //        [self.locationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        //        self.locationButton.enabled = NO;
    }
    else{
        self.MapPlace.centerCoordinate = self.MapPlace.userLocation.coordinate;
        //   self.locationButton.enabled = YES;
        //   log([NSString stringWithFormat:@"Взяли локацию пользователя");
    }
#if VIENNA
    city = @"Vienna";
#endif
#if MOSCOW
    city = @"Moscow";
#endif
    
#if LIKELIK
#else
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.Label = [[ExternalFunctions cityCatalogueForCity:city] objectForKey:[ExternalFunctions getLocalizedString:@"city"]];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
    self.Label = [[ExternalFunctions cityCatalogueForCity:city] objectForKey:[ExternalFunctions getLocalizedString:@"city"]];
    for (int i = 0; i < 12; ++i){
        UILabel *label = (UILabel *)[[self.frameArray objectAtIndex:i] viewWithTag:textinFrame];
        label.text = AMLocalizedString([self.CellArray objectAtIndex:i], nil);
    }
#endif
    
#if VIENNA
    city = @"Vienna";
#endif
    
#if MOSCOW
    city = @"Moscow";
#endif
    
    
    locationManager2 = [[CLLocationManager alloc] init];
    [locationManager2 setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdating) name:@"stopUpdating" object:nil];
    
    locationManagerRegion = [[CLLocationManager alloc] init];
    [locationManagerRegion setDelegate:self];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        [locationManager2 startUpdatingLocation];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [NSString stringWithFormat:@"Back on main thread"];
        });
    });
    
    
#warning лишний end?
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.hidden = NO;
    self.categoryView.contentOffset = CGPointMake(self.categoryView.contentOffset.x, 0);
    if (self.MapPlace.hidden){
//        [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
    }
    else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    

    //    [self.Table deselectRowAtIndexPath:[self.Table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Memory warning" action:@"Catch warning"                                                                                          label:@"Category view" value:nil] build]];
    [super didReceiveMemoryWarning];
}

-(void)viewReload{
    [self viewDidLoad];
}

-(void)pref_dismiss{
    [self viewDidAppear:YES];
}

-(void)Pref{
    [self performSegueWithIdentifier:@"PrefSegue" sender:self];
}

-(void)Info{
    [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}

- (void)appToBackground{
    log([NSString stringWithFormat:@"LOG: app to background"]);
    IN_BG = YES;
    [self removeKnuckleHUD];
}
- (void)appReturnsActive{
    log([NSString stringWithFormat:@"LOG: app returns active"]);
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
- (void)removeKnuckleHUD{
    for (UIView *subViews in self.view.subviews)
        if (subViews.tag == EF_TAG ) {
            [subViews removeFromSuperview];
        }
    for (UIView *subViews in self.navigationController.view.subviews){
        if(subViews.tag == FADE_TAG)
            [subViews removeFromSuperview];
    }
}

-(void)reloadCatalogue{
    //[self.placeViewMap addSubview:self.MapPlace];
    
    UIView *fade = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    fade.tag = FADE_TAG;
    fade.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:fade];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // post an NSNotification that loading has started
        AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.Label];
        RMAnnotation *marker1;
        for (int i=0; i<[AroundArray count]; i++) {
            CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
            marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:tmp.coordinate andTitle:@"Pin"];
            marker1.annotationType = @"marker";
            marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
            marker1.subtitle = AMLocalizedString([[AroundArray objectAtIndex:i] objectForKey:@"Category"], nil);
            marker1.userInfo = [AroundArray objectAtIndex:i];
            [self.MapPlace addAnnotation:marker1];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            log([NSString stringWithFormat:@"Back on main thread"]);
            IS_LOADING = NO;
            [self getSoonLabels];
            [self removeKnuckleHUD];
            //   log([NSString stringWithFormat:@"remove knuckle animation in reload");
            //            [self.Table reloadData];
        });
        // post an NSNotification that loading is finished
    });
    UIView *coolEf = [[UIView alloc] initWithFrame:self.view.frame];
    coolEf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    coolEf.tag = EF_TAG;
    [self.view addSubview:coolEf];
    [UIView animateWithDuration:0.2 animations:^{
        coolEf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        UIView *spin = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 90, 45, 45)];
        //knuckle_1@2x.png
        spin.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kul_90.png"]];
        //spin.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        CALayer *layer = spin.layer;
        layer.cornerRadius = 8;
        spin.clipsToBounds = YES;
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 3.0f;
        animation.repeatCount = HUGE_VAL;
        [spin.layer addAnimation:animation forKey:@"knuckleAnimation"];
        [coolEf addSubview:spin];
        //      log([NSString stringWithFormat:@"start knuckle animation in reload");
    }];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)getSoonLabels{
    for (int i = 1; i < 7; ++i){
        UIView *frame = (self.frameArray)[i];
        MLPAccessoryBadge *Badge = [MLPAccessoryBadge new];
        [Badge.textLabel setFont:[AppDelegate OpenSansSemiBold:32]];
        //[Badge sizeToFit];
        [Badge setBackgroundColor:[InterfaceFunctions colorTextCategory:[self.CellArray objectAtIndex:i]]];
        [Badge setText:AMLocalizedString(@"Soon", nil)];
        Badge.center = frame.center;//CGRectMake(0.0, 0.0, frameSize, frameSize);
        if ([[self placesInCategory:[self.CellArray objectAtIndex:i]] count] == 0) {
            frame.alpha = 0.3;
            [self.categoryView addSubview:Badge];
            [frame setUserInteractionEnabled:NO];
        }
        else{
            [frame setUserInteractionEnabled:YES];
        }
    }
    
}


-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
        
        [marker replaceUIImage:[InterfaceFunctions MapPin:annotation.subtitle].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return marker;
        
    }
    return nil;
}

-(void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    //  log([NSString stringWithFormat:@"123");
    //[map selectAll:map];
    //    [map selectAnnotation:annotation animated:YES];
}


-(void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    // log([NSString stringWithFormat:@"123");
}
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    // log([NSString stringWithFormat:@"tap");
    PlaceName = annotation.title;
    PlaceCategory = [annotation.userInfo objectForKey:@"Category"];
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}


-(IBAction)ShowMap:(id)sender{
    
    self.MapPlace.hidden = !self.MapPlace.hidden;
    if (self.MapPlace.hidden){
        
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Category Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
        UIButton *btn = [InterfaceFunctions map_button:1];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
     //   [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Category Map Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
     //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

-(void)search:(id)sender{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
}



-(void)clearView:(UIView *)obj{
    for (UIView *subView in self.view.subviews){
        if(subView.tag == EF_TAG)
            [subView removeFromSuperview];
    }
}
-(void)customPush:(UIView *)sender{
    NSInteger number = [(UIGestureRecognizer *)sender view].tag;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self performSegueWithIdentifier:[self.SegueArray objectAtIndex:number] sender:sender];
}

-(NSArray *)placesInCategory:(NSString *)category{
    NSMutableArray *arrayOfPlacesInCategory = [[NSMutableArray alloc] init];
    for (int i = 0; i < AroundArray.count; ++i) {
        if([[[AroundArray objectAtIndex:i] objectForKey:@"Category"] isEqualToString:category]){
            [arrayOfPlacesInCategory addObject:(AroundArray)[i]];
        }
    }
    return [NSArray arrayWithArray:arrayOfPlacesInCategory];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIView *)sender{
    
    NSInteger row =[(UIGestureRecognizer *)sender view].tag;
  //  log([NSString stringWithFormat:@"In segue! Number is: %d", row);
    if ([[segue identifier] isEqualToString:@"AroundmeSegue"]) {
        PlaceslistViewController *destination = [segue destinationViewController];
        destination.CityNameText = self.Label;
        destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
        destination.readyArray = AroundArray;
        destination.CityNameString = AMLocalizedString(@"Around Me", nil);
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Aroundme Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        PlaceslistViewController *destination = [segue destinationViewController];
        destination.CityNameText = self.Label;
      //  destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
        destination.readyArray = [self placesInCategory:[self.CellArray objectAtIndex:row]];
        destination.CityNameString = AMLocalizedString([self.CellArray objectAtIndex:row], nil);
        
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Screen",currentCity,[self.CellArray objectAtIndex:row]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    if ([[segue identifier] isEqualToString:@"FavoritesSegue"]) {
        PlaceslistViewController *destination = [segue destinationViewController];
        destination.CityNameText = self.Label;//[self.CellArray objectAtIndex:row];
        destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
        destination.readyArray = [ExternalFunctions getAllFavouritePlacesInCity:self.Label];//[self favoritePlaces];//[self placesInCategory:[self.CellArray objectAtIndex:row]];
        destination.CityNameString = AMLocalizedString([self.CellArray objectAtIndex:row], nil);
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Favorites Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
        
    }
    if ([[segue identifier] isEqualToString:@"VisualtourSegue"]) {
        VisualTourViewController *destination =
        [segue destinationViewController];
        destination.CityName = self.Label;
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Visual Tour Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    if ([[segue identifier] isEqualToString:@"PracticalinfoSegue"]) {
        ScrollinfoViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
        destination.Parent = @"Practical";
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Practical Info Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    
    
    if ([[segue identifier] isEqualToString:@"TransportationSegue"]) {
        TransportationViewController *destination = [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"MapSegue"]) {
        PlaceViewController *PlaceView = [segue destinationViewController];
        PlaceView.PlaceName = PlaceName;
        PlaceView.PlaceCategory = PlaceCategory;
        PlaceView.PlaceCityName = [Place objectForKey:@"City"];
        PlaceView.PlaceAddress = [Place objectForKey:@"Address"];
        PlaceView.PlaceAbout = [Place objectForKey:@"About"];
        PlaceView.PlaceTelephone = [Place objectForKey:@"Telephone"];
        PlaceView.PlaceWeb = [Place objectForKey:@"Web"];
        PlaceView.PlaceLocation = [Place objectForKey:@"Location"];
        PlaceView.Color = [InterfaceFunctions colorTextCategory:PlaceCategory];
        PlaceView.Photos = [Place objectForKey:@"Photo"];
    }
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]){
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.Label;
        destinaton.readyArray = AroundArray;
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Category Search Screen",currentCity]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
        //currentCategory =@"Search";
    }
}

- (void)viewDidUnload {
        [super viewDidUnload];
}


- (void)updateOffsets {
    CGFloat yOffset   = self.categoryView.contentOffset.y;
    UIImageView *imback = (UIImageView *)[self.view viewWithTag:backgroundTag];
    UIImageView *clearBack = (UIImageView *)[self.view viewWithTag:backgroundTag2];
    double startFrom = -170.0;
    double navBarOffset = 66;
    double angelOffset = 150;
    if(yOffset < 0){
        imback.alpha = 1.0 + yOffset/200;
        if(yOffset < startFrom && yOffset > startFrom - navBarOffset - angelOffset){
            CGRect frame = clearBack.frame;
            frame.origin.y = -yOffset + startFrom - navBarOffset - angelOffset;
            clearBack.frame = frame;
            
            CGRect frameBlured = imback.frame;
            frameBlured.origin.y = -yOffset + startFrom - navBarOffset;
            imback.frame = frameBlured;
            //[[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Angel" action:@"Got"                                                                                          label:[NSString stringWithFormat:@"%@ %@",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]] value:nil] build]];

        }
        else if(yOffset > startFrom - navBarOffset - angelOffset){
            CGRect frame = clearBack.frame;
            frame.origin.y = -navBarOffset - angelOffset;
            clearBack.frame = frame;
            
            CGRect frameBlured = imback.frame;
            frameBlured.origin.y = -navBarOffset;
            imback.frame = frameBlured;
        }
    }
    if (yOffset > 0){
        imback.alpha = 1.0 - yOffset/300;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}

-(void)ShowAlertView{
    NSString *str = AMLocalizedString(@"You are up to download LikeLik Catalogue", nil);
    UIAlertView *message1 = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Download", nil)
                                                       message:str
                                                      delegate:self
                                             cancelButtonTitle:AMLocalizedString(@"Next time", nil)
                                             otherButtonTitles:@"Ok",nil];
    [message1 show];
    
}



-(void)startTracking{
}

-(void) stopUpdating{
    [locationManager2 stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    dispatch_queue_t backGroundQueue;
    
    backGroundQueue = dispatch_queue_create("backGroundQueueForRegions", NULL);
    dispatch_async(backGroundQueue, ^{
        [ExternalFunctions getReady];
      //  log([NSString stringWithFormat:@"start background queue"]);
        if (j==0) {
            j++;
            Me = newLocation;
            
            NSArray *Region =  [ExternalFunctions getAllRegionsAroundMyLocation:Me];
            for (int i = 0; i<[Region count]; i++) {
                [locationManagerRegion startMonitoringForRegion:[Region objectAtIndex:i]];
             //   NSLog(@"%@",[locationManagerRegion monitoredRegions]);
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




- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
#if LIKELIK
        int navigationControllersCount = [[self.navigationController viewControllers] count] - 2;
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:navigationControllersCount] animated:YES];
#endif
    }
    else{
        [ExternalFunctions startDownloadingCatalogueOfCity : city];
    }
}


- (void) startHUD {
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.HUDfade.mode = MBProgressHUDAnimationFade;
    self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
        [self.HUDfade show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void) stopHUDWithSuccess {
    self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark@2x"]];
    self.HUDfade.mode = MBProgressHUDModeCustomView;
    self.HUDfade.labelText = AMLocalizedString(@"Ready!", nil);
    [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                            onTarget:self withObject:nil animated:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) stopHUDWithFailure {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
    self.HUDfade.mode = MBProgressHUDModeCustomView;
    self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
    [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                            onTarget:self withObject:nil animated:YES];
}

- (void) showNoInternetConnectionHUD {
    int navigationControllersCount = [[self.navigationController viewControllers] count] - 2;
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
    self.HUDfade.mode = MBProgressHUDModeCustomView;
    self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
    [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds) onTarget:self withObject:nil animated:YES];
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:navigationControllersCount] animated:YES];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) popViewController {
    int navigationControllersCount = [[self.navigationController viewControllers] count] - 2;
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:navigationControllersCount] animated:YES];
}

- (void) reloadMapView {
    NSURL *url;
    if ([city isEqualToString:@"Moscow"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([city isEqualToString:@"Vienna"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    [self.MapPlace setTileSource:offlineSource];
    self.MapPlace.hidden = NO;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    
    self.MapPlace.minZoom = 10;
    self.MapPlace.zoom = 13;
    self.MapPlace.maxZoom = 17;
    
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    [self.MapPlace setHidden:YES];
}

- (void) dataProcessingHUD {
    self.HUDfade.labelText = AMLocalizedString(@"Data processing", nil);
}

- (void) showDownloadProgressHUD {
    NSString *progress = [[NSUserDefaults standardUserDefaults] objectForKey:@"progress"];
    self.HUDfade.labelText = progress;
}

- (void) waitForTwoSeconds {
    sleep(2);
}

@end

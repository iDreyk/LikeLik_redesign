//
//  AroundMeViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "PlaceslistViewController.h"
#import "PlaceViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "CheckViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapBox/MapBox.h>
#import "RegistrationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreTextLabel.h"
#import "MapViewAnnotation.h"
//
//
#define tableLabelWithTextTag 87001
#define goLAbelTag 87002
#define arrowTag 87003
#define backgroundViewTag 87004
#define cellColorTag 87005
#define distanceTag 87006
#define announceTag 87007
#define labelColorTag 87008
#define buttonlabel1Tag 87009
#define checkTag 87010
#define smallIconTag 87011

#define backgroundTag 2442441
#define backgroundTag2 2442442

#define afterregister             @"l27h7RU2dzVfP12aoQssda"
static NSString *LorR = nil;
static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;
static CGFloat width = 180;//220;
static NSString * currentCity = @"";

NSInteger PREV_SECTION_AROUNDME = 0;
bool REVERSE_ANIM = false;
static BOOL JUST_APPEAR = YES;
static BOOL BACK_PRESSED = NO;
static BOOL NEED_TO_RELOAD = NO;


@interface UIButtonWithAditionalNum ()

@end

@implementation UIButtonWithAditionalNum

@end

@interface PlaceslistViewController ()

@end


@implementation PlaceslistViewController
@synthesize HUD,knuck;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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


-(void)viewWillDisappear:(BOOL)animated{
    //self.view.hidden = YES;
     BACK_PRESSED = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    //self.view.hidden = NO;
    [HUD setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([AMLocalizedString(@"Moscow", nil) isEqualToString:self.CityName.text]) {
        currentCity = @"Moscow";
    }
    else{
        currentCity = @"Vienna";
    }
    
    
    JUST_APPEAR = YES;
    
    AroundArray = [[NSArray alloc] initWithArray:self.readyArray];    
#if LIKELIK
    self.mapView.hidden = YES;
    self.Map.hidden = YES;
    NSURL *url;
    if ([self.CityNameText isEqualToString:@"Moscow"] || [self.CityNameText isEqualToString:@"Москва"] || [self.CityNameText isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityNameText isEqualToString:@"Vienna"] || [self.CityNameText isEqualToString:@"Вена"] || [self.CityNameText isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    [self.Map setTileSource:offlineSource];
    self.Map.showsUserLocation = YES;
    self.Map.minZoom = 13;
    self.Map.zoom = 13;

    self.Map.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate;
    [self.Map setAdjustTilesForRetinaDisplay:YES];
    RMAnnotation *marker1;
    for (int i=0; i<[AroundArray count]; i++) {
        CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = AMLocalizedString([[AroundArray objectAtIndex:i] objectForKey:@"Category"], nil);
        marker1.userInfo = [AroundArray objectAtIndex:i];
        [self.Map addAnnotation:marker1];
    }
    
#else
    self.mapView.hidden = YES;
    self.ViewforMap.hidden = YES;
    self.Map.hidden = YES;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    
    // define starting point for map
    CLLocationCoordinate2D start;
    start.latitude = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate.latitude;
    start.longitude = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate.longitude;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    [self.mapView setRegion:region animated:YES];
    

    [AppDelegate LLLog:[NSString stringWithFormat:@"%f",[ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate.latitude]];
    for (int i=0; i<[AroundArray count]; i++) {
        CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
        MapViewAnnotation *Annotation = [[MapViewAnnotation alloc] initWithTitle:[[AroundArray objectAtIndex:i] objectForKey:@"Name"] andCoordinate:tmp.coordinate andUserinfo:[AroundArray objectAtIndex:i] andSubtitle:[[AroundArray objectAtIndex:i] objectForKey:@"Category"] AndTag:[[NSString alloc] initWithFormat:@"%d",i]];
        [self.mapView addAnnotation:Annotation];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:Annotation.title forState:UIControlStateNormal];
        
    }
#endif
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
    
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:@"Moscow"]]];
    [self.view bringSubviewToFront:self.PlacesTable];
    [self.view bringSubviewToFront:self.mapView];
    [self.view bringSubviewToFront:self.Map];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
       
    self.PlacesTable.backgroundColor = [UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PlacesTable.showsHorizontalScrollIndicator = NO;
    self.PlacesTable.showsVerticalScrollIndicator = NO;
    
   // self.CityImage.hidden = NO;
    self.CityName.hidden = NO;
    self.PlacesTable.hidden =NO;
    self.Map.hidden = YES;
    self.locationButton.hidden = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    Me = [locationManager location];
    
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    if ([CLLocationManager authorizationStatus] == 2) {
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.userInteractionEnabled = NO;
        
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.removeFromSuperViewOnHide = YES;
        HUD.detailsLabelFont = [AppDelegate OpenSansBoldwithSize:28];
        HUD.detailsLabelText = AMLocalizedString(@"Apparently, you've disabled this application to access your geolocation", nil);
        
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    self.CityName.text = self.CityNameString;
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btn = [InterfaceFunctions search_button];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if ([self.CityNameString isEqualToString:AMLocalizedString(@"Favorites", Nil)])
        self.navigationItem.rightBarButtonItem = nil;
    
    
    UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
    [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    
    if(!self.imageCache)
        self.imageCache = [[NSMutableDictionary alloc] init];
    
    if ([AppDelegate isiPhone5])
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
    else
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController35" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(test:)
                                                 name: afterregister
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(tableNeedsToReload:)
                                                 name: @"ReloadTableInPlaces"
                                               object: nil];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    self.PlacesTable.contentOffset = CGPointMake(0, -40);
//    [UIView commitAnimations];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
    bg.tag = backgroundTag;
    UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
    bg2.tag = backgroundTag2;
    
    bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_blur",[[ExternalFunctions cityCatalogueForCity:self.CityNameText] objectForKey:@"city_EN"]]];
    bg2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_paralax",[[[ExternalFunctions cityCatalogueForCity:self.CityNameText] objectForKey:@"city_EN"] lowercaseString]]];
    
    [self.view addSubview:bg2];
    [self.view addSubview:bg];
    [self.view bringSubviewToFront:self.PlacesTable];
    [self.view bringSubviewToFront:self.Map];
    [self.view bringSubviewToFront:self.mapView];
}

- (void)tableNeedsToReload:(NSNotification *) notification {
    NEED_TO_RELOAD = YES;
    //[self.PlacesTable reloadData];
}

#if LIKELIK
-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    
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
    
}
-(void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
}
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    PlaceName = annotation.title;
    PlaceCategory = [annotation.userInfo objectForKey:@"Category"];
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}
#else
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapViewAnnotation *)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        //  [AppDelegate LLLog:[NSString stringWithFormat:@"%@",annotation.userinfo);
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [InterfaceFunctions MapPin:AMLocalizedString(annotation.subtitle, nil)].image;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = [annotation.tag intValue];
        [rightButton addTarget:self action:@selector(map_tu:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        return annotationView;
    }
    
    return nil;
}
-(void)map_tu:(UIButton *)sender{
   // [AppDelegate LLLog:[NSString stringWithFormat:@"123 %d",sender.tag);
    
    
    PlaceName = [[AroundArray objectAtIndex:sender.tag] objectForKey:@"Name"];
    PlaceCategory = [[AroundArray objectAtIndex:sender.tag] objectForKey:@"Category"];
    Place = [AroundArray objectAtIndex:sender.tag];
    //[self performSegueWithIdentifier:@"" sender:]
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
    
   // [AppDelegate LLLog:[NSString stringWithFormat:@"%@",[AroundArray objectAtIndex:sender.tag]);
}
#endif


-(void)test:(id)sender{
    
    

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
    {
        VC.view.backgroundColor = [UIColor clearColor];
        VC.PlaceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"];
        VC.PlaceCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"];
        VC.PlaceCity =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"];
        VC.PlaceNameEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTempEN"];
        VC.PlaceCityEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTempEN"];
        VC.color = [InterfaceFunctions colorTextCategory:@"Category"];
        
        [self presentSemiViewController:VC withOptions:@{
         KNSemiModalOptionKeys.pushParentBack    : @(YES),
         KNSemiModalOptionKeys.animationDuration : @(0.5),
         KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
         }];
        
    }

}

-(IBAction)showLocation:(id)sender{
#if LIKELIK
    [self.Map setCenterCoordinate:self.Map.userLocation.coordinate];
#else
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
#endif
}

-(void)Search{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
}


-(void)viewDidAppear:(BOOL)animated{
    // [testflight passCheckpoint:@"Around Me"];
    self.view.hidden = NO;
#if LIKELIK
    if ([[[CLLocation alloc] initWithLatitude:self.Map.userLocation.coordinate.latitude longitude:self.Map.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText]] > 50000.0) {
        self.Map.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate;
        
        [self.locationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        self.locationButton.enabled = NO;
    }
    else{
        self.Map.centerCoordinate = self.Map.userLocation.coordinate;
        self.locationButton.enabled = YES;
    }
    
#else 
#warning тестануть Apple Maps на 3.5"
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    // define starting point for map
    CLLocationCoordinate2D start;
    if ([[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText]] > 50000.0){
        start = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate;
        self.locationButton.enabled = NO;
    }
    else{
        start = self.mapView.userLocation.coordinate;
        self.locationButton.enabled = YES;
    }
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    [self.mapView setRegion:region animated:YES];
    

#endif
    
    JUST_APPEAR = YES;
    if(NEED_TO_RELOAD){
        [AppDelegate LLLog:[NSString stringWithFormat:@"Reloading table"]];
        [self.PlacesTable reloadData];
        NEED_TO_RELOAD = NO;
    }
    //[self.PlacesTable reloadData];
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

-(IBAction) segmentedControlIndexChanged{
    if(AroundArray.count == 0)
        return;
    //self.CityImage.hidden=!self.CityImage.hidden;
    
    self.CityName.hidden=!self.CityName.hidden;
    self.PlacesTable.hidden=!self.PlacesTable.hidden;
#if LIKELIK
    self.Map.hidden=!self.Map.hidden;
    if (!self.Map.hidden) {
          [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Map Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
          [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    else {
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
#else
    self.mapView.hidden =!self.mapView.hidden;
    if (!self.mapView.hidden){
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Map Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    else {
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
#endif
    self.locationButton.hidden=!self.locationButton.hidden;
    
    if (self.CityName.hidden) {
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:0];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
       //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
//        [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.hidden = NO;
    BACK_PRESSED = NO;
    [self.PlacesTable deselectRowAtIndexPath:[self.PlacesTable indexPathForSelectedRow] animated:YES];
    if (self.mapView.hidden){
    //    [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];
    }
    else{
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }

}


- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [self.PlacesTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([AroundArray count] == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.PlacesTable.frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.2;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/4, 0.0, 0.0)];
        [label setText:AMLocalizedString(@"Add to Favorites best places", nil)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
        [label setFont:[AppDelegate OpenSansRegular:32]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,label.frame.origin.y +label.frame.size.height +40.0,0.0,0.0)];
        [sublabel setText:AMLocalizedString(@"To do this, just click on a star when you look interesting place ", nil)];
        sublabel.numberOfLines = 0;
        sublabel.textAlignment = NSTextAlignmentCenter;
        [sublabel sizeToFit];
        [sublabel setFrame:CGRectMake((320.0-sublabel.frame.size.width)/2, label.frame.origin.y + label.frame.size.height + 40.0, sublabel.frame.size.width, sublabel.frame.size.height+30)];
        [sublabel setFont:[AppDelegate OpenSansRegular:32]];
        [sublabel setBackgroundColor:[UIColor clearColor]];
        [sublabel setTextColor:[UIColor whiteColor]];
        

        self.gradient_under_cityname.hidden = YES;
        self.CityName.hidden = YES;
        self.PlacesTable.hidden = YES;
        [self.view addSubview:view];
        [self.view addSubview:[InterfaceFunctions favourite_star_empty]];
        [self.view addSubview:label];
        [self.view addSubview:sublabel];
        self.navigationItem.titleView = nil;
       
    }
    
    
    return [AroundArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.CityNameString isEqualToString: AMLocalizedString(@"Favorites", nil)]){
        return YES;
    }
    else{
        return NO;
    }
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [AppDelegate LLLog:[NSString stringWithFormat:@"Hello!");
    NSString *Place = [[AroundArray objectAtIndex:[indexPath row]] objectForKey:@"Name"];
    NSString *Category = [[AroundArray objectAtIndex:[indexPath row]] objectForKey:@"Category"];
    [ExternalFunctions removeFromFavoritesPlace:Place InCategory:Category InCity:self.CityNameText];
    AroundArray = [ExternalFunctions getAllFavouritePlacesInCity:self.CityNameText];
    [tableView reloadData];
    
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)loadImageFromCache:(NSString *)url :(NSString *)backup completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    UIImage* theImage = [self.imageCache objectForKey:url];
    UIImage* backupImg = [self.imageCache objectForKey:backup];
    
    if ((nil != theImage) && [theImage isKindOfClass:[UIImage class]]) {
//        [AppDelegate LLLog:[NSString stringWithFormat:@"img loaded from cache!");
        completionBlock(YES, theImage);
    }
    else if((nil != backupImg) && [backupImg isKindOfClass:[UIImage class]]){
//        [AppDelegate LLLog:[NSString stringWithFormat:@"img loaded from cache!");
        completionBlock(YES, backupImg);
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image = [UIImage imageWithContentsOfFile:url];
            UIImage *cropedImage = [[UIImage alloc] init];
            if(!image){
                image = [UIImage imageWithContentsOfFile:backup];
                CGImageRef imgRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 400,width, width/1.852));
                cropedImage = [UIImage imageWithCGImage:imgRef];
                CGImageRelease(imgRef);
                [self.imageCache setObject:cropedImage forKey:backup];
            //    [AppDelegate LLLog:[NSString stringWithFormat:@"img saved to cache! (%@)", [self.imageCache objectForKey:backup]);
            }
            else{
                cropedImage = image;
                [self.imageCache setObject:cropedImage forKey:url];
           //     [AppDelegate LLLog:[NSString stringWithFormat:@"img saved to cache! (%@)", [self.imageCache objectForKey:url]);
            }
       //     [AppDelegate LLLog:[NSString stringWithFormat:@"Images in cache: %d", [self.imageCache count]);
            dispatch_async(dispatch_get_main_queue(), ^ {
                completionBlock(YES,cropedImage);
            });
            
        });
    }
}


#pragma mark - cell

//For future cool animation
//-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
//    // Create animation keys, forwards and backwards
//    CATransform3D t1 = CATransform3DIdentity;
//    t1.m34 = 1.0/-900;
//    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
//    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
//    
//    CATransform3D t2 = CATransform3DIdentity;
//    t2.m34 = t1.m34;
//    t2 = CATransform3DTranslate(t2, 0, 185*-0.08, 0);
//    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.toValue = [NSValue valueWithCATransform3D:t1];
//	CFTimeInterval duration = 0.5;
//    animation.duration = duration/2;
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
//    animation2.beginTime = animation.duration;
//    animation2.duration = animation.duration;
//    animation2.fillMode = kCAFillModeForwards;
//    animation2.removedOnCompletion = NO;
//    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.fillMode = kCAFillModeForwards;
//    group.removedOnCompletion = NO;
//    [group setDuration:animation.duration*2];
//    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
//    return group;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *category = [[AroundArray objectAtIndex:row] objectForKey:@"Category"];
    
    if (cell == nil) { // init the cell
      //  [AppDelegate LLLog:[NSString stringWithFormat:@"Created! %@",indexPath);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //202,148,78
        
        // плитка, на которую всё накладываем
        CGFloat x_dist = 3;
        CGFloat y_dist = 3;
        CGFloat cellWidth = 314;
        CGFloat cellHeight = 181;
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(x_dist, y_dist, cellWidth, cellHeight)];
        CALayer * back_layer = back.layer;
        back_layer.cornerRadius = 5;
        //back.clipsToBounds = YES;
        back.tag = cellColorTag;
        back.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:back]; // добавили на cell
        
        
        cell.contentView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:216/255.0 green:219/255.0 blue:220/255.0 alpha:1];//[UIColor colorWithRed:216/255.0 green:219/255.0 blue:220/255.0 alpha:1];//[[InterfaceFunctions colorTextCategory:category] colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //  картинка
        CGFloat img_x_dist = 7;
        CGFloat img_y_dist = 63;
        UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(img_x_dist, img_y_dist, width, width / 1.852)];
        preview.tag = backgroundViewTag;
        preview.backgroundColor =  [UIColor whiteColor];
        //preview.clipsToBounds = NO;
        
        CALayer * imgLayer1 = preview.layer;
        [imgLayer1 setBorderColor: [[UIColor blackColor] CGColor]];
        [imgLayer1 setBorderWidth:0.5f];
        [imgLayer1 setShadowColor: [[UIColor blackColor] CGColor]];
        [imgLayer1 setShadowOpacity:0.9f];
        [imgLayer1 setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer1 setShadowRadius:3.0];
        imgLayer1.shouldRasterize = YES;
        
        [imgLayer1 setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer1.bounds].CGPath];
        [imgLayer1 setRasterizationScale:[UIScreen mainScreen].scale];
        
        CALayer * imgLayer = back.layer;
        [imgLayer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imgLayer setBorderWidth:0.5f];
//        [imgLayer setShadowColor: [[UIColor blackColor] CGColor]];
//        [imgLayer setShadowOpacity:0.9f];
//        [imgLayer setShadowOffset: CGSizeMake(0, 1)];
//        [imgLayer setShadowRadius:3.0];
//        // [imgLayer setCornerRadius:4];
        imgLayer.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer setRasterizationScale:[UIScreen mainScreen].scale];
        
        [back addSubview:preview];
        // картинку сделали
        
        
        // анонс
        CoreTextLabel *text = [[CoreTextLabel alloc]  initWithFrame:CGRectMake(width + 2*img_x_dist + 3, img_y_dist - 4, cellWidth - width - 2*img_x_dist - 10, 70)]; // y - 4
        text.textColor = [UIColor blackColor];
        text.tag = announceTag;
        text.adjustsFontSizeToFitWidth = NO;
        text.textAlignment = kCTLeftTextAlignment;
        text.font = [AppDelegate  OpenSansRegular:19];
        text.textColor = [UIColor blackColor];
        text.lineBreakMode = kCTLineBreakByWordWrapping;
        [back addSubview:text];
        
        // заголовок
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , cellWidth, 42)];
        CALayer *layer2 = nameLabel.layer;
        layer2.cornerRadius = 5;
        //nameLabel.clipsToBounds = YES;
        nameLabel.tag = labelColorTag;
        [back addSubview:nameLabel];

        // первая кнопка
//        UILabel * buttonlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(width + 2*img_x_dist - 2 + img_x_dist + 5, img_y_dist + width/1.852 - 24 -2 , 26, 26)];
//        CALayer *layer1 = buttonlabel1.layer;
//        layer1.cornerRadius = 3;
//        buttonlabel1.clipsToBounds = YES;
//        buttonlabel1.tag = buttonlabel1Tag;
        
        // кнопка с кулаком

        knuck = [[UIButtonWithAditionalNum alloc] initWithFrame:CGRectMake(width + 2*img_x_dist + 2*img_x_dist + 2*img_x_dist  + 5 - 6, img_y_dist + width/1.852 - 2*img_x_dist - 11 - 5, 60, 30)];
        knuck.tag = checkTag;
        knuck.backgroundColor = [InterfaceFunctions corporateIdentity];
        knuck.layer.cornerRadius = 3;
        UIImageView *knPict = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_knuck"]];
        knPict.frame = CGRectMake(0, 3, 24, 24);
        [knuck addSubview:knPict];
        //[knuck addSubview:[[UIImageView alloc]initWithImage:[self imageWithImage:[UIImage imageNamed:@"kul_90"] scaledToSize:CGSizeMake(24,24)]]];
        
        UILabel *checkText = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, knuck.frame.size.width - 26, knuck.frame.size.height)];
        checkText.text = @"Use";
        checkText.font = [AppDelegate OpenSansBoldwithSize:32];
        checkText.backgroundColor = [UIColor clearColor];
        checkText.textColor = [UIColor whiteColor];
        [knuck addSubview:checkText];
        // knuck.imageView.image = [UIImage imageNamed:@"kul_90"];
        [knuck addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
//        [back addSubview:buttonlabel1];
        [back addSubview:knuck];

        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(268.0, 0.0, 42.0, 42.0)];
        iconView.tag = smallIconTag;
        [back addSubview:iconView];
        
                                                                            //280
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0,265, cell.center.y*2)];
        
        //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        //        line.backgroundColor = [[InterfaceFunctions colorTextCategory:category] colorWithAlphaComponent:0.3];
        //        [preview addSubview:line];
        
        
        //      [InterfaceFunctions TableLabelwithText:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)];
        
        
        label.tag = tableLabelWithTextTag;
        label.font = [AppDelegate OpenSansSemiBold:45];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [back addSubview:label];
        
        UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(img_x_dist, cellHeight - 15, 100, 15)];
        distance.textAlignment = NSTextAlignmentLeft;
        distance.font = [AppDelegate OpenSansBoldwithSize:20];//[UIFont systemFontOfSize:10];
        distance.tag = distanceTag;
        distance.textColor = [UIColor grayColor];
        distance.backgroundColor = [UIColor clearColor];
        [back addSubview:distance];
    }

    NSNumber *distance = [[AroundArray objectAtIndex:row] objectForKey:@"Distance"];
    float intDist = [distance floatValue];
    
    UILabel *dist = (UILabel *)[cell viewWithTag:distanceTag];
    if(intDist > 20000)
        dist.text = [NSString stringWithFormat:@"20+ %@",AMLocalizedString(@"km", nil)];
    else if(intDist > 1000)
        dist.text = [NSString stringWithFormat:@"%.2f%@", intDist / 1000.,AMLocalizedString(@"km", nil)];
    else
        dist.text = [NSString stringWithFormat:@"%.0f%@", intDist,AMLocalizedString(@"m", nil)];
    
    
    UIButtonWithAditionalNum * check = (UIButtonWithAditionalNum *)[cell viewWithTag:checkTag];
    check.tagForCheck = [indexPath row];
    
  //  NSDictionary *temp = [AroundArray objectAtIndex:row];

  //  [AppDelegate LLLog:[NSString stringWithFormat:@"Name = %@ Category = %@ City = %@ row = %d",[temp objectForKey:@"Name"],[temp objectForKey:@"Category"],self.CityNameText,row);

    if ([ExternalFunctions isCheckUsedInPlace:[[AroundArray objectAtIndex:row] objectForKey:@"Name"] InCategory:category InCity:self.CityNameText]){
    
   //     [AppDelegate LLLog:[NSString stringWithFormat:@"isUsed = %d row = %d",[ExternalFunctions isCheckUsedInPlace:[[AroundArray objectAtIndex:row] objectForKey:@"Name"] InCategory:category InCity:self.CityNameText],row);
        check.alpha = 0.5;
    }
    else{
        check.alpha = 1.0;
     //   [AppDelegate LLLog:[NSString stringWithFormat:@"NOOOOOO %@",[temp objectForKey:@"Name"]);
    }
    
    
    UILabel * buttonlabel = (UILabel *)[cell viewWithTag:buttonlabel1Tag];
    buttonlabel.backgroundColor =[InterfaceFunctions colorTextCategory:category];
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[AroundArray objectAtIndex:row] objectForKey:@"Name"];
    
    UILabel *previewText = (UILabel *)[cell viewWithTag:announceTag];
    
    NSString *preview = [[AroundArray objectAtIndex:row] objectForKey:@"Preview"];
    if(preview.length < 10)
    previewText.text = AMLocalizedString(@"Please, update catalogues to get access to newest features.", nil);
                            //Добавить в локализации
    else
        previewText.text = preview;
    
    UILabel *label = (UILabel *)[cell viewWithTag:labelColorTag];
    label.backgroundColor = [InterfaceFunctions colorTextCategory:category];
    
    UIView *iconView = (UIView *)[cell viewWithTag:smallIconTag];
    iconView.backgroundColor = [InterfaceFunctions iconColorWithCategory:category];
    
    Place1 = [AroundArray objectAtIndex:row];
    NSArray *photos = [Place1 objectForKey:@"Photo"];
    [self loadImageFromCache:[Place1 objectForKey:@"thumb"] :[photos objectAtIndex:0] completionBlock:^(BOOL succeeded, UIImage *image) {
        if(succeeded){
            UIImageView *preview = (UIImageView *)[cell viewWithTag:backgroundViewTag];
            preview.image = image;
        }
    }];
    //cell.backgroundView = bkgView;
    
    //cell.backgroundView = [InterfaceFunctions CellBG];
    //cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    if(PREV_SECTION_AROUNDME > row)
        REVERSE_ANIM = true;
    else
        REVERSE_ANIM = false;
    
    PREV_SECTION_AROUNDME = row;
    if(!JUST_APPEAR){

    //UIView *myView = [[cell subviews] objectAtIndex:0];
    UIView *myView = (UIView *)[cell viewWithTag:cellColorTag];
    CALayer *layer = myView.layer;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DMakeTranslation(0, 0, -10);
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/6, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/6, 1, 0, 0);
    }
    
    layer.transform = rotationAndPerspectiveTransform;
    
    
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.75];
    //[cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/6, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/6, 1, 0, 0);
    }
    layer.transform = rotationAndPerspectiveTransform;
    
    [UIView commitAnimations];
    }
    return cell;
}

-(void)check:(UIButtonWithAditionalNum *)sender{
    
    NSDictionary *temp = [AroundArray objectAtIndex:sender.tagForCheck];
  //  [AppDelegate LLLog:[NSString stringWithFormat:@"TagforCheck = %d",sender.tagForCheck);
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"Name"] forKey:@"PlaceTemp"];
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"Category"] forKey:@"CategoryTemp"];
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"City"] forKey:@"CityTemp"];
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"Name_EN"] forKey:@"PlaceTempEN"];
    [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CityTempEN"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sender.tagForCheck] forKey:@"RowTemp"];
  //  [AppDelegate LLLog:[NSString stringWithFormat:@"Check: %@ %@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"],[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"],[[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"]);
    
    if ([ExternalFunctions isCheckUsedInPlace:[temp objectForKey:@"Name"] InCategory:[temp objectForKey:@"Category"] InCity:self.CityNameText]){
 //       [AppDelegate LLLog:[NSString stringWithFormat:@"Уже использован");
    }
    else{
 //       [AppDelegate LLLog:[NSString stringWithFormat:@"Еще не использован");
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:checkOpen
                                                                object:self];
            
            VC.view.backgroundColor = [UIColor clearColor];
            VC.PlaceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"];
            VC.PlaceCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"];
            VC.PlaceCity =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"];
            VC.PlaceNameEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTempEN"];
            VC.PlaceCityEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTempEN"];
            VC.color = [InterfaceFunctions colorTextCategory:@"Category"];
            
            [self presentSemiViewController:VC withOptions:@{
             KNSemiModalOptionKeys.pushParentBack    : @(YES),
             KNSemiModalOptionKeys.animationDuration : @(0.5),
             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
             }];
            
            
            
        }
        else{
            [self showRegistrationMessage:self];
            
        }
    }
}


- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
//        [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//        self.navigationController.navigationBar.hidden = YES;
        if ([ExternalFunctions isCheckUsedInPlace:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"] InCategory:[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"] InCity:[[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"]]){
   //         [AppDelegate LLLog:[NSString stringWithFormat:@"HAAAAALO!!!");
            NSIndexPath *durPath = [NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"RowTemp"] integerValue] inSection:0];
            NSArray *paths = [NSArray arrayWithObject:durPath];
            [self.PlacesTable reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];

        //    self.GOUSE.enabled = NO;
        //    [Use stopAnimating];
        }
    }
}

-(IBAction)showRegistrationMessage:(id)sender{
    
    UIAlertView  *message = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Registration", nil)
                                                       message:AMLocalizedString(@"To use all the features of the world LikeLik, please register", nil)
                                                      delegate:nil
                                             cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
                                             otherButtonTitles:AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil), nil];
    message.delegate = self;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        LorR = @"Login";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Register Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
    if (buttonIndex == 2){
        LorR = @"Login";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Login Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CellSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [HUD hide:YES];
    
    if ([[segue identifier] isEqualToString:@"CellSegue"]) {
        PlaceViewController *destinaton  = [segue destinationViewController];
        destinaton.PlaceCityName = self.CityNameText;
        NSIndexPath *indexpath = [self.PlacesTable indexPathForSelectedRow];
        Place1 = [AroundArray objectAtIndex:[indexpath row]];
        destinaton.PlaceName = [Place1 objectForKey:@"Name"];
        destinaton.PlaceCategory = [Place1 objectForKey:@"Category"];
        destinaton.Color = [InterfaceFunctions colorTextPlaceBackground:[Place1 objectForKey:@"Category"]];
        destinaton.PlaceAbout = [Place1 objectForKey:@"About"];
        destinaton.PlaceAddress = [Place1 objectForKey:@"Address"];
        destinaton.PlaceTelephone = [Place1 objectForKey:@"Telephone"];
        destinaton.PlaceWeb = [Place1 objectForKey:@"Web"];
        destinaton.PlaceLocation = [Place1 objectForKey:@"Location"];
        destinaton.Photos = [Place1 objectForKey:@"Photo"];
        destinaton.PlaceNameEn = Place1[@"Name_EN"];
        
    }
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.CityNameText;
        destinaton.readyArray = AroundArray;
        
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Search Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    
    if ([[segue identifier] isEqualToString:@"RegisterSegue"]) {
        
        RegistrationViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.Parent = @"Place";
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ %@ Register Screen",currentCity,[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"]]];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];

    }
    
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        RegistrationViewController *destination = [segue destinationViewController];
        destination.LorR = LorR;
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(JUST_APPEAR)
        JUST_APPEAR = NO;
}


- (void)updateOffsets {
    CGFloat yOffset   = self.PlacesTable.contentOffset.y;
    UIImageView *imback = (UIImageView *)[self.view viewWithTag:backgroundTag];
    if(yOffset < 0)
        imback.alpha = 1.0 + yOffset / 600;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!BACK_PRESSED)
        [self updateOffsets];
}


- (void)viewDidUnload {
   [super viewDidUnload];
}
@end

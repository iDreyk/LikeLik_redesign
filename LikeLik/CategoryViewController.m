//
//  CategoryViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 30.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "AroundMeViewController.h"
#import "CityInfoTableViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "FavViewController.h"
#import "AboutTableViewController.h"
#import "VisualTourViewController.h"
#import "TransportationTableViewController.h"
#import "PracticalInfoViewController.h"
#import <MapBox/MapBox.h>
#import "PlaceViewController.h"
#import "MLPAccessoryBadge.h"
#import <QuartzCore/QuartzCore.h>

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static BOOL IS_LOADING;
static BOOL IN_BG;
#define textinFrame 131313
#define EF_TAG 66483
#define FADE_TAG 66484
#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
static NSString *city = @"";
@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:0.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    //return [[self class] scaleIfNeeded:cgImage];
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
    NSURL *url;
    if ([self.CityName.text isEqualToString:@"Moscow"] || [self.CityName.text isEqualToString:@"Москва"] || [self.CityName.text isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityName.text isEqualToString:@"Vienna"] || [self.CityName.text isEqualToString:@"Вена"] || [self.CityName.text isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.MapPlace.showsUserLocation = YES;
    self.MapPlace = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.MapPlace.hidden = NO;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    
    if ([AppDelegate isiPhone5])
        self.MapPlace.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.MapPlace.frame = CGRectMake(0.0, 0.0, 320.0, 450.0);
    
    
    self.MapPlace.minZoom = 10;
    self.MapPlace.zoom = 13;
    self.MapPlace.maxZoom = 17;
    
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    self.MapPlace.showsUserLocation = YES;
    [self.placeViewMap setHidden:YES];
    [self.placeViewMap addSubview:self.MapPlace];
    
    UIView *fade = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    fade.tag = FADE_TAG;
    fade.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:fade];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // post an NSNotification that loading has started
        AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text];
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
            NSLog(@"Back on main thread");
            IS_LOADING = NO;
            [self getSoonLabels];
            [self removeKnuckleHUD];
            NSLog(@"remove knuckle animation in reload");
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
        NSLog(@"start knuckle animation in reload");
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

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    IN_BG = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    //    CLLocation *Me = [_locationManager location];
    
    self.categoryView.backgroundColor = [UIColor clearColor];
    [self.categoryView setScrollEnabled:YES];
    self.categoryView.showsHorizontalScrollIndicator = NO;
    self.categoryView.showsVerticalScrollIndicator = NO;
    
    [self.categoryView setContentSize:CGSizeMake(320, 480)];
    [self.categoryView flashScrollIndicators];
    self.categoryView.delegate = self;
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    background.backgroundColor = [UIColor whiteColor];  //[UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"Overlay_Long@2x.png"] scaledToSize:CGSizeMake(320, 568)]];//[UIColor //[UIColor whiteColor];//[InterfaceFunctions BackgroundColor];
    [self.categoryView addSubview:background];
    
    //    self.Table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"Overlay_Long@2x.png"] scaledToSize:CGSizeMake(320, 568)]];//[UIColor whiteColor];//[InterfaceFunctions BackgroundColor];
    //Overlay_Long@2x.png
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
    
#if MOSCOW
    self.Label = @"Moscow";
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
#endif
#if VIENNA
    self.Label = @"Vienna";
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
#endif

    self.CityName.text = self.Label;
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityName.textColor = [UIColor whiteColor];
    self.CityImage.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:self.Label]];
        NSLog(@"City in viewDidLoad: %@",[ExternalFunctions larkePictureOfCity:self.Label]);
    self.CellArray = @[@"Around Me", @"Restaurants",@"Night life",@"Shopping",@"Culture",@"Leisure", @"Beauty",@"Visual Tour", @"Metro",@"Search",@"Favorites",  @"Practical Info"];
    
    self.SegueArray = @[@"AroundmeSegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"VisualtourSegue",@"TransportationSegue",@"SearchSegue",@"FavoritesSegue",@"PracticalinfoSegue"];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
#if LIKELIK
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    NSURL *url;
    if ([self.CityName.text isEqualToString:@"Moscow"] || [self.CityName.text isEqualToString:@"Москва"] || [self.CityName.text isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityName.text isEqualToString:@"Vienna"] || [self.CityName.text isEqualToString:@"Вена"] || [self.CityName.text isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.MapPlace.showsUserLocation = YES;
    self.MapPlace = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.MapPlace.hidden = NO;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    
    if ([AppDelegate isiPhone5])
        self.MapPlace.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.MapPlace.frame = CGRectMake(0.0, 0.0, 320.0, 450.0);
    
    
    self.MapPlace.minZoom = 10;
    self.MapPlace.zoom = 13;
    self.MapPlace.maxZoom = 17;
    
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    self.MapPlace.showsUserLocation = YES;
    [self.placeViewMap setHidden:YES];

#else
    [self.placeViewMap setHidden:YES];
    UIButton *btn_left = [InterfaceFunctions Info_button];
    [btn_left addTarget:self action:@selector(Info) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    
    UIButton *btn = [InterfaceFunctions Pref_button];
    [btn addTarget:self action:@selector(Pref) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewReload) name:@"reloadView" object:nil];
    
#endif
    
    if([ExternalFunctions isDownloaded:self.CityName.text]){
        
        [self.placeViewMap addSubview:self.MapPlace];
    }
    IS_LOADING = YES;
    if([ExternalFunctions isDownloaded:self.CityName.text]){
        UIView *fade = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        fade.tag = FADE_TAG;
        fade.backgroundColor = [UIColor clearColor];
        [self.navigationController.view addSubview:fade];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // post an NSNotification that loading has started
            
            AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text];
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
                NSLog(@"Back on main thread");
                IS_LOADING = NO;
                [self getSoonLabels];
                [self removeKnuckleHUD];
                
                NSLog(@"remove knuckle animation");
            });
            // post an NSNotification that loading is finished
        });
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    CGFloat frameSize = 93.0;
    CGFloat xOrigin = 10;
    CGFloat yOrigin = 20;
    CGFloat yOffset = 10;
    
    if(self.view.bounds.size.height == 460.0)
        yOrigin = 0;
    
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
//    NSLog(@"cellArray = %@",self.CellArray);
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
        frame.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
        [frame addGestureRecognizer:tap];
        [frame setUserInteractionEnabled:YES];
        [self.categoryView addSubview:frame];
        ++i;
    }
    
    if([ExternalFunctions isDownloaded:self.CityName.text]){
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
            NSLog(@"start knuckle animation in viewDidLoad");
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reloadCatalogue) name:@"reloadAllCatalogues" object:nil];
    
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
    NSLog(@"LOG: app to background");
    IN_BG = YES;
    [self removeKnuckleHUD];
}
- (void)appReturnsActive{
    NSLog(@"LOG: app returns active");
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
    //  NSLog(@"123");
    //[map selectAll:map];
    //    [map selectAnnotation:annotation animated:YES];
}


-(void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    // NSLog(@"123");
}
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    // NSLog(@"tap");
    PlaceName = annotation.title;
    PlaceCategory = [annotation.userInfo objectForKey:@"Category"];
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}


-(IBAction)ShowMap:(id)sender{
    self.placeViewMap.hidden = !self.placeViewMap.hidden;
    if (self.placeViewMap.hidden){
        UIButton *btn = [InterfaceFunctions map_button:1];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else{
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

-(void)search:(id)sender{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
}

-(void)viewDidAppear:(BOOL)animated{
    //  AroundArray = [ExternalFunctions getAllPlacesInCity:self.CityName.text];
    NSLog(@"loadView");
    
    if ([[[CLLocation alloc] initWithLatitude:self.MapPlace.userLocation.coordinate.latitude longitude:self.MapPlace.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName.text]] > 50000.0) {
        self.MapPlace.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName.text].coordinate;
        NSLog(@"Взяли центр города");
        //        [self.locationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        //        self.locationButton.enabled = NO;
    }
    else{
        self.MapPlace.centerCoordinate = self.MapPlace.userLocation.coordinate;
        //   self.locationButton.enabled = YES;
        NSLog(@"Взяли локацию пользователя");
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
    self.Label = city;//[[ExternalFunctions cityCatalogueForCity:city] objectForKey:[ExternalFunctions getLocalizedString:@"city"]];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];
    self.CityName.text = city;//[[ExternalFunctions cityCatalogueForCity:city] objectForKey:[ExternalFunctions getLocalizedString:@"city"]];
        for (int i = 0; i < 12; ++i){
            UILabel *label = (UILabel *)[[self.frameArray objectAtIndex:i] viewWithTag:textinFrame];
            label.text = AMLocalizedString([self.CellArray objectAtIndex:i], nil);
            }
    [self getSoonLabels];
#endif

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.Table deselectRowAtIndexPath:[self.Table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    //NSIndexPath *indexPath = [self.Table indexPathForSelectedRow];
    NSInteger row =[(UIGestureRecognizer *)sender view].tag;//[indexPath row];
    NSLog(@"In segue! Number is: %d", row);
    if ([[segue identifier] isEqualToString:@"AroundmeSegue"]) {
        AroundMeViewController *destination = [segue destinationViewController];
        destination.CityNameText = self.Label;
        destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
        destination.readyArray = AroundArray;
        destination.CityNameString = AMLocalizedString(@"Around Me", nil);
    }
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        AroundMeViewController *destination = [segue destinationViewController];
        destination.CityNameText = self.Label;//[self.CellArray objectAtIndex:row];
        destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
        destination.readyArray = [self placesInCategory:[self.CellArray objectAtIndex:row]];
        destination.CityNameString = AMLocalizedString([self.CellArray objectAtIndex:row], nil);
    }
    if ([[segue identifier] isEqualToString:@"FavoritesSegue"]) {
        FavViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
        destination.readyArray = [ExternalFunctions getAllFavouritePlacesInCity:self.CityName.text];
    }
    
    if ([[segue identifier] isEqualToString:@"VisualtourSegue"]) {
        VisualTourViewController *destination =
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"TransportationSegue"]) {
        TransportationTableViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"PracticalinfoSegue"]) {
        PracticalInfoViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
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
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)updateOffsets {
    
    CGFloat yOffset   = self.categoryView.contentOffset.y;
    
    if (yOffset < 0) {
        self.CityImage.frame = CGRectMake(0, -280.0, 320.0, 568.0 - yOffset);
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
        //self.categoryView.frame = CGRectMake(self.categoryView.frame.origin.x,self.categoryView.frame.origin.y-yOffset,self.categoryView.frame.size.width,self.categoryView.frame.size.height);
    }
    else {
        self.CityImage.frame = CGRectMake(0, -280.0, 320, self.CityImage.frame.size.height);
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,0.0,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
        
    }
    self.CityImage.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}

@end

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
#import "PlacesByCategoryViewController.h"
#import "VisualTourViewController.h"
#import "TransportationTableViewController.h"
#import "PracticalInfoViewController.h"
#import <MapBox/MapBox.h>
#import "PlaceViewController.h"
#import "MLPAccessoryBadge.h"
static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;

#define FADE_TAG 66482
#define EF_TAG 66483

@interface CategoryViewController ()

@end

static BOOL PLACES_LOADED = NO;

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)activateAroundMe{
    for (UIView *subView in self.categoryView.subviews){
        if(subView.tag == FADE_TAG){
           [subView removeFromSuperview];
        }
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    CLLocation *Me = [_locationManager location];
    
    self.categoryView.backgroundColor = [UIColor clearColor
                                         ];
    [self.categoryView setScrollEnabled:YES];
    [self.categoryView setContentSize:CGSizeMake(320, 480)];
    [self.categoryView flashScrollIndicators];
    self.categoryView.delegate = self;
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    background.backgroundColor = [InterfaceFunctions BackgroundColor];
    [self.categoryView addSubview:background];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPush:)];
    
        
//    self.Table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];

    self.CityName.text = self.Label;
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityName.textColor = [UIColor whiteColor];
    self.CityImage.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:self.Label]];
    NSLog(@"%@",[ExternalFunctions larkePictureOfCity:self.Label]);
    self.CellArray = @[@"Around Me", @"Restaurants",@"Night life",@"Shopping",@"Culture",@"Leisure", @"Beauty", @"Hotels",@"Favorites", @"Visual Tour", @"Metro",@"Practical Info"];
    
    self.SegueArray = @[@"AroundmeSegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"FavoritesSegue",@"VisualtourSegue",@"TransportationSegue",@"PracticalinfoSegue"];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
//    self.Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    
    [self.placeViewMap addSubview:self.MapPlace];

    PLACES_LOADED = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // post an NSNotification that loading has started
        AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text];
        RMAnnotation *marker1;
        for (int i=0; i<[AroundArray count]; i++) {
            NSLog(@"in cycle %d",i);
            CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
            marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:tmp.coordinate andTitle:@"Pin"];
            marker1.annotationType = @"marker";
            marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
            marker1.subtitle = AMLocalizedString([[AroundArray objectAtIndex:i] objectForKey:@"Category"], nil);
            marker1.userInfo = [AroundArray objectAtIndex:i];
            [self.MapPlace addAnnotation:marker1];
            //NSLog(@"! %@ %f %f",marker1.title,marker1.coordinate.latitude,marker1.coordinate.longitude);
        }
        //    NSLog(@"%@",self.MapPlace.annotations);]
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Back on main thread");
            self.navigationItem.rightBarButtonItem.enabled = YES;
            PLACES_LOADED = YES;
            [self activateAroundMe];
//            [self.Table reloadData];
        });
                // post an NSNotification that loading is finished
    });
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *city = [[ExternalFunctions cityCatalogueForCity:self.CityName.text] objectForKey:@"city_EN"];
    if ([ExternalFunctions isDownloaded:city]) {
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
        
        CLLocation *oldLocation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"Изменение расстояния: %f",[Me distanceFromLocation:oldLocation]);
        
        NSArray *catalogues = [[NSUserDefaults standardUserDefaults] objectForKey:@"Catalogues"];
        
        if ([Me distanceFromLocation:oldLocation] > 10
            || [[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"around %@",city]] == NULL) {
            NSLog(@"in if");

            [_locationManager stopUpdatingLocation];
            NSData *newLocation = [NSKeyedArchiver archivedDataWithRootObject:Me];
            [[NSUserDefaults standardUserDefaults] setObject:newLocation forKey:@"location"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^ {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                [defaults setObject:data forKey:[[NSString alloc] initWithFormat:@"around %@",city]];
                
                NSLog(@"Finished work in background");
                
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    NSLog(@"Back on main thread");
                });
            });
        }
        else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"langChanged"] == [NSNumber numberWithInt:1]) {
            [_locationManager stopUpdatingLocation];
            NSData *newLocation = [NSKeyedArchiver archivedDataWithRootObject:Me];
            [[NSUserDefaults standardUserDefaults] setObject:newLocation forKey:@"location"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^ {
                
                for (int i = 0; i < [catalogues count]; i++) {
                    NSString *cityName = [[catalogues objectAtIndex:i] objectForKey:@"city_EN"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[ExternalFunctions getPlacesAroundMyLocationInCity:cityName]];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    [defaults setObject:data forKey:[[NSString alloc] initWithFormat:@"around %@",cityName]];
                    
                    NSLog(@"Finished work in background");
                }
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:0] forKey:@"langChanged"];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    NSLog(@"Back on main thread");
                });
            });
        }
    }
    
    
    UIView *frame1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 93, 93)];
    frame1.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"1.png"] scaledToSize:CGSizeMake(93, 93)]];
    frame1.tag = 0;
    [frame1 addGestureRecognizer:tap];
    [frame1 setUserInteractionEnabled:YES];
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(5, 64, 83, 28)];
    text.text = AMLocalizedString([self.CellArray objectAtIndex:frame1.tag], nil);
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor whiteColor];
    [text setFont:[UIFont systemFontOfSize:14]];
    CALayer *layer = frame1.layer;
    layer.cornerRadius = 10;
    frame1.clipsToBounds = YES;
    [frame1 addSubview:text];
    [self.categoryView addSubview:frame1];
    
    UIView *fade = [[UIView alloc] initWithFrame:frame1.frame];
    fade.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    fade.tag = FADE_TAG;
    CALayer *layer1 = fade.layer;
    layer1.cornerRadius = 10;
    frame1.clipsToBounds = YES;

    [self.categoryView addSubview:fade];
    
    UIView *frame2 = [[UIView alloc] initWithFrame:CGRectMake(113, 20, 93, 93)];
    frame2.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"2.png"] scaledToSize:CGSizeMake(93, 93)]];

    frame2.tag = 1;
    [frame2 addGestureRecognizer:tap1];
    [frame2 setUserInteractionEnabled:YES];
    UILabel *text1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 64, 83, 28)];
    text1.text = AMLocalizedString([self.CellArray objectAtIndex:frame2.tag], nil);
    text1.backgroundColor = [UIColor clearColor];
    text1.textColor = [UIColor whiteColor];
    [text1 setFont:[UIFont systemFontOfSize:14]];
    [frame2 addSubview:text1];
    CALayer *layer2 = frame2.layer;
    layer2.cornerRadius = 10;
    frame2.clipsToBounds = YES;
    [self.categoryView addSubview:frame2];
    
    UIView *frame3 = [[UIView alloc] initWithFrame:CGRectMake(216, 20, 93, 93)];
    frame3.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"3.png"] scaledToSize:CGSizeMake(93, 93)]];

    frame3.tag = 2;
    [frame3 addGestureRecognizer:tap2];
    [frame3 setUserInteractionEnabled:YES];
    CALayer *layer3 = frame3.layer;
    layer3.cornerRadius = 10;
    frame3.clipsToBounds = YES;
    [self.categoryView addSubview:frame3];
    
    UIView *frame4 = [[UIView alloc] initWithFrame:CGRectMake(10, 133, 93, 93)];
    frame4.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"4.png"] scaledToSize:CGSizeMake(93, 93)]];

    frame4.tag = 3;
    [frame4 addGestureRecognizer:tap3];
    [frame4 setUserInteractionEnabled:YES];
    CALayer *layer4 = frame4.layer;
    layer4.cornerRadius = 10;
    frame4.clipsToBounds = YES;
    [self.categoryView addSubview:frame4];
    
    UIView *frame5 = [[UIView alloc] initWithFrame:CGRectMake(113, 133, 93, 93)];
    frame5.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"5.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer5 = frame5.layer;
    layer5.cornerRadius = 10;
    frame5.clipsToBounds = YES;
    frame5.tag = 4;
    [frame5 addGestureRecognizer:tap4];
    [frame5 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame5];
    
    UIView *frame6 = [[UIView alloc] initWithFrame:CGRectMake(216, 133, 93, 93)];
    frame6.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"6.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer6 = frame6.layer;
    layer6.cornerRadius = 10;
    frame6.clipsToBounds = YES;
    frame6.tag = 5;
    [frame6 addGestureRecognizer:tap5];
    [frame6 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame6];
    
    UIView *frame7 = [[UIView alloc] initWithFrame:CGRectMake(10, 246, 93, 93)];
    frame7.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"7.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer7 = frame7.layer;
    layer7.cornerRadius = 10;
    frame7.clipsToBounds = YES;
    frame7.tag = 6;
    [frame7 addGestureRecognizer:tap6];
    [frame7 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame7];
    
    UIView *frame8 = [[UIView alloc] initWithFrame:CGRectMake(113, 246, 93, 93)];
    frame8.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"8.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer8 = frame8.layer;
    layer8.cornerRadius = 10;
    frame8.clipsToBounds = YES;
    frame8.tag = 7;
    [frame8 addGestureRecognizer:tap7];
    [frame8 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame8];
    
    UIView *frame9 = [[UIView alloc] initWithFrame:CGRectMake(216, 246, 93, 93)];
    frame9.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"9.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer9 = frame9.layer;
    layer9.cornerRadius = 10;
    frame9.clipsToBounds = YES;
    frame9.tag = 8;
    [frame9 addGestureRecognizer:tap8];
    [frame9 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame9];
    
    UIView *frame10 = [[UIView alloc] initWithFrame:CGRectMake(10, 359, 93, 93)];
    frame10.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"10.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer10 = frame10.layer;
    layer10.cornerRadius = 10;
    frame10.clipsToBounds = YES;
    frame10.tag = 9;
    [frame10 addGestureRecognizer:tap9];
    [frame10 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame10];
    
    UIView *frame11 = [[UIView alloc] initWithFrame:CGRectMake(113, 359, 93, 93)];
    frame11.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"11.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer11 = frame11.layer;
    layer11.cornerRadius = 10;
    frame11.clipsToBounds = YES;
    frame11.tag = 10;
    [frame11 addGestureRecognizer:tap10];
    [frame1 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame11];
    
    UIView *frame12 = [[UIView alloc] initWithFrame:CGRectMake(216, 359, 93, 93)];
    frame12.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"12.png"] scaledToSize:CGSizeMake(93, 93)]];
    CALayer *layer12 = frame12.layer;
    layer12.cornerRadius = 10;
    frame12.clipsToBounds = YES;
    frame12.tag = 11;
    [frame12 addGestureRecognizer:tap11];
    [frame12 setUserInteractionEnabled:YES];
    [self.categoryView addSubview:frame12];

    
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




#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.CellArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.backgroundView = [InterfaceFunctions CellBG];
//    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    
//    
//    NSString *text = AMLocalizedString([self.CellArray objectAtIndex:[indexPath row]], nil);
//    if ([indexPath row]<8 && [indexPath row]!=0) {
//        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions mainTextColor:[indexPath row]+1]]];
//        [cell addSubview:[InterfaceFunctions actbwithColor:[indexPath row]]];//actbwithColor:[indexPath row]+1]];
//    }
//    else{
//        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions corporateIdentity]]];
//        if ([indexPath row] == 11) {
//            MLPAccessoryBadge *accessoryBadge;
//
//            accessoryBadge = [MLPAccessoryBadge new];
//            [cell setAccessoryView:accessoryBadge];
//            [accessoryBadge setText:AMLocalizedString(@"Soon", nil)];
//            [accessoryBadge setBackgroundColor:[InterfaceFunctions corporateIdentity]];
//            [cell addSubview:accessoryBadge];
//        }
//        else
//            [cell addSubview:[InterfaceFunctions corporateIdentity_actb]];
//    }
//    if(!PLACES_LOADED && [indexPath row] == 0){
//        UIView *fade = [[UIView alloc] initWithFrame:cell.frame];
//        fade.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
//        [cell addSubview:fade];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//        return cell;
//}
//#pragma mark - Table view delegate
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([indexPath row] == 11) {
//        return nil;
//    }
//    return indexPath;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//  //  if ([indexPath row] !=11)
//    [TestFlight passCheckpoint:[self.SegueArray objectAtIndex:[indexPath row]]];
//    if((indexPath.row == 0) && !PLACES_LOADED)
//        return;
//    [self performSegueWithIdentifier:[self.SegueArray objectAtIndex:[indexPath row]] sender:self];
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44.0;
//}
//
-(void)clearView:(UIView *)obj{
    for (UIView *subView in self.view.subviews){
        if(subView.tag == EF_TAG)
            [subView removeFromSuperview];
    }
}
-(void)customPush:(UIView *)sender{
    NSInteger number = [(UIGestureRecognizer *)sender view].tag;
    UIView *coolEf = [[UIView alloc] initWithFrame:[(UIGestureRecognizer *)sender view].frame];
    if(number > 0 && number < 8)
        coolEf.backgroundColor = [InterfaceFunctions mainTextColor:(number + 1)];
    else
        coolEf.backgroundColor = [InterfaceFunctions corporateIdentity];
    coolEf.tag = EF_TAG;
    [self.view addSubview:coolEf];
    [UIView animateWithDuration:0.3 animations:^{
        coolEf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        UIView *spin = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 50, 80, 80)];
        spin.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        CALayer *layer = spin.layer;
        layer.cornerRadius = 8;
        spin.clipsToBounds = YES;
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 3.0f;
        animation.repeatCount = HUGE_VAL;
        [spin.layer addAnimation:animation forKey:@"MyAnimation"];
        [coolEf addSubview:spin];

        self.navigationItem.leftBarButtonItem.enabled = NO;
    } completion:^(BOOL finished) {
        [TestFlight passCheckpoint:[self.SegueArray objectAtIndex:number]];
        if((number == 0) && !PLACES_LOADED)
            return;
        [self performSegueWithIdentifier:[self.SegueArray objectAtIndex:number] sender:sender];
        NSTimeInterval delay = 0.4; //in seconds
        [self performSelector:@selector(clearView:) withObject:nil afterDelay:delay];
    }];
    
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
    }
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        PlacesByCategoryViewController *destination =[segue destinationViewController];
        destination.CityName = self.Label;
        destination.Category = [self.CellArray objectAtIndex:row];
        destination.Image = [ExternalFunctions larkePictureOfCity:self.Label];
    }

    if ([[segue identifier] isEqualToString:@"FavoritesSegue"]) {
        FavViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
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
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)updateOffsets {
    
    CGFloat yOffset   = self.categoryView.contentOffset.y;
    
   if (yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,221.0-yOffset);
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
        //self.categoryView.frame = CGRectMake(self.categoryView.frame.origin.x,self.categoryView.frame.origin.y-yOffset,self.categoryView.frame.size.width,self.categoryView.frame.size.height);
    }
    else {
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,0.0,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
        
    }
    self.CityImage.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}

@end

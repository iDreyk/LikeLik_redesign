//
//  AroundMeViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "AroundMeViewController.h"
#import "PlaceViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <MapBox/MapBox.h>
//
//
static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;

@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
@synthesize HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
    
    NSURL *url;
    if ([self.CityNameText isEqualToString:@"Moscow"] || [self.CityNameText isEqualToString:@"Москва"] || [self.CityNameText isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityNameText isEqualToString:@"Vienna"] || [self.CityNameText isEqualToString:@"Вена"] || [self.CityNameText isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }

    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.Map = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.Map.delegate = self;
   // self.Map.hideAttribution = YES;
    self.Map.showsUserLocation = YES;
    if ([AppDelegate isiPhone5])
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    self.Map.minZoom = 13;
    self.Map.zoom = 13;
    //self.Map.maxzoom = 17;
    CLLocation *coord =[ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText];
    self.Map.centerCoordinate = coord.coordinate;
    [self.Map setAdjustTilesForRetinaDisplay:YES];
    
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
    
    self.PlacesTable.backgroundColor = [UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.CityImage.hidden = NO;
    self.CityName.hidden = NO;
    self.PlacesTable.hidden =NO;
    self.ViewforMap.hidden = YES;
    self.locationButton.hidden = YES;
    


    [self.ViewforMap addSubview:self.Map];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    Me = [locationManager location];
  //  NSLog(@"Around Me = %@", Me);
    
    
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    if ([CLLocationManager authorizationStatus] == 2) {
        
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.userInteractionEnabled = NO;

        HUD.mode = MBProgressHUDModeCustomView;

        HUD.removeFromSuperViewOnHide = YES;
        HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Apparently, you've disabled this application to access your geolocation", nil)];
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
   // NSLog(@"Ready array: %@", self.readyArray);
    AroundArray = [[NSArray alloc] initWithArray:self.readyArray];//[ExternalFunctions getPlacesAroundMyLocationInCity:self.CityNameText];
    NSLog(@"AroundArray: %@", AroundArray);
    RMAnnotation *marker1;
    for (int i=0; i<[AroundArray count]; i++) {
        CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = [[AroundArray objectAtIndex:i] objectForKey:@"Category"];
        marker1.userInfo = [AroundArray objectAtIndex:i];
        [self.Map addAnnotation:marker1];
    }
    
    
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    self.CityName.text = AMLocalizedString(@"Around Me", nil);
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityImage.image = [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:self.CityNameText]];
    
    
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIButton *btn = [InterfaceFunctions search_button];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
    [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}


-(IBAction)showLocation:(id)sender{
    [self.Map setCenterCoordinate:self.Map.userLocation.coordinate];
}

-(void)Search{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [TestFlight passCheckpoint:@"Around Me"];
    if ([[[CLLocation alloc] initWithLatitude:self.Map.userLocation.coordinate.latitude longitude:self.Map.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText]] > 50000.0) {
        self.Map.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityNameText].coordinate;
        NSLog(@"Взяли центер города");
        [self.locationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        self.locationButton.enabled = NO;
    }
    else{
        self.Map.centerCoordinate = self.Map.userLocation.coordinate;
        self.locationButton.enabled = YES;
        NSLog(@"Взяли локацию пользователя");
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [HUD setHidden:YES];
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
    PlaceCategory = annotation.subtitle;
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(IBAction) segmentedControlIndexChanged{
    self.CityImage.hidden=!self.CityImage.hidden;
    self.CityName.hidden=!self.CityName.hidden;
    self.PlacesTable.hidden=!self.PlacesTable.hidden;
    self.ViewforMap.hidden=!self.ViewforMap.hidden;
    self.locationButton.hidden=!self.locationButton.hidden;

    if (self.CityImage.hidden) {
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:0];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.PlacesTable deselectRowAtIndexPath:[self.PlacesTable indexPathForSelectedRow] animated:YES];
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
    return [AroundArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
   // NSLog(@"Around Me = %@",[[AroundArray objectAtIndex:row] objectForKey:@"Category"]);
    
    [cell addSubview:[InterfaceFunctions TableLabelwithText:[[AroundArray objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
    
    [cell addSubview:[InterfaceFunctions goLabelCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]]];
    [cell addSubview:[InterfaceFunctions actbwithCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]]];
    
    cell.backgroundView = [InterfaceFunctions CellBG];
    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    return cell;
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
        NSLog(@"%@", destinaton.Photos);
    }

    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        //    nslog(@"[[segue identifier] isEqualToString: SearchSegue");
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.CityNameText;
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
}



- (void)updateOffsets {
    
    
    
    CGFloat yOffset   = self.PlacesTable.contentOffset.y;

    CGFloat threshold = self.PlacesTable.frame.size.height - self.PlacesTable.frame.size.height;
    if (yOffset > -threshold && yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-yOffset,320.0,self.CityImage.frame.size.height);
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,-yOffset,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.gradient_under_cityname.frame = CGRectMake(self.gradient_under_cityname.frame.origin.x,-yOffset,self.gradient_under_cityname.frame.size.width,self.gradient_under_cityname.frame.size.height);
        
        // NSLog(@"1");

    } else if (yOffset < 0) {
        // NSLog(@"2");
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,221.0-yOffset + floorf(threshold / 2.0));
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,5-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.gradient_under_cityname.frame = CGRectMake(self.gradient_under_cityname.frame.origin.x,-yOffset,self.gradient_under_cityname.frame.size.width,self.gradient_under_cityname.frame.size.height);
      
    } else {
        // NSLog(@"3");
        self.CityImage.frame = CGRectMake(0, -44.0, 320, self.CityImage.frame.size.height);
     
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,5,self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        
        self.gradient_under_cityname.frame = CGRectMake(self.gradient_under_cityname.frame.origin.x,0,self.gradient_under_cityname.frame.size.width,self.gradient_under_cityname.frame.size.height);
        
    }
    self.CityImage.contentMode = UIViewContentModeScaleAspectFit;
//    self.CityImage.contentScaleFactor = 2.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}


- (void)viewDidUnload {
    [self setViewforMap:nil];
    [super viewDidUnload];
}
@end

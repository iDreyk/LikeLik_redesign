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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    CLLocation *Me = [_locationManager location];
    
    self.Table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];

    self.CityName.text = self.Label;
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityName.textColor = [UIColor whiteColor];
    self.CityImage.image =  [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:self.Label]];
    
    self.CellArray = @[@"Around Me", @"Restaurants",@"Night life",@"Shopping",@"Culture",@"Leisure", @"Beauty", @"Hotels",@"Favorites", @"Visual Tour", @"Metro",@"Practical Info"];
    
    self.SegueArray = @[@"AroundmeSegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"FavoritesSegue",@"VisualtourSegue",@"TransportationSegue",@"PracticalinfoSegue"];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    self.Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

    AroundArray = [ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text];
    RMAnnotation *marker1;
    for (int i=0; i<[AroundArray count]; i++) {
        CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = [[AroundArray objectAtIndex:i] objectForKey:@"Category"];
        marker1.userInfo = [AroundArray objectAtIndex:i];
        [self.MapPlace addAnnotation:marker1];
        //NSLog(@"! %@ %f %f",marker1.title,marker1.coordinate.latitude,marker1.coordinate.longitude);
    }
//    NSLog(@"%@",self.MapPlace.annotations);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *city = [[ExternalFunctions cityCatalogueForCity:self.CityName.text] objectForKey:@"city_EN"];
    if ([ExternalFunctions isDownloaded:city]) {
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
        
        CLLocation *oldLocation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"Изменение расстояния: %f",[Me distanceFromLocation:oldLocation]);
        
        NSArray *catalogues = [[NSUserDefaults standardUserDefaults] objectForKey:@"Catalogues"];
        
        if ([Me distanceFromLocation:oldLocation] > 100
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
        NSLog(@"Взяли центер города");
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
    [self.Table deselectRowAtIndexPath:[self.Table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.CellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundView = [InterfaceFunctions CellBG];
    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    NSString *text = AMLocalizedString([self.CellArray objectAtIndex:[indexPath row]], nil);
    if ([indexPath row]<8 && [indexPath row]!=0) {
        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions mainTextColor:[indexPath row]+1]]];
        [cell addSubview:[InterfaceFunctions actbwithColor:[indexPath row]]];//actbwithColor:[indexPath row]+1]];
    }
    else{
        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions corporateIdentity]]];
        if ([indexPath row] == 11) {
            MLPAccessoryBadge *accessoryBadge;

            accessoryBadge = [MLPAccessoryBadge new];
            [cell setAccessoryView:accessoryBadge];
            [accessoryBadge setText:AMLocalizedString(@"Soon", nil)];
            [accessoryBadge setBackgroundColor:[InterfaceFunctions corporateIdentity]];
            [cell addSubview:accessoryBadge];
        }
        else
            [cell addSubview:[InterfaceFunctions corporateIdentity_actb]];
    }
        return cell;
}
#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 11) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //  if ([indexPath row] !=11)
        [self performSegueWithIdentifier:[self.SegueArray objectAtIndex:[indexPath row]] sender:self];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.Table indexPathForSelectedRow];
     NSInteger row = [indexPath row];
    
    if ([[segue identifier] isEqualToString:@"AroundmeSegue"]) {
        AroundMeViewController *destination =
        [segue destinationViewController];
        destination.CityNameText = self.Label;
        destination.Image = self.Image; 
    }
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        PlacesByCategoryViewController *destination =[segue destinationViewController];
        destination.CityName = self.Label;
        destination.Category = [self.CellArray objectAtIndex:row];
        destination.Image = self.Image;
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
    
    CGFloat yOffset   = self.Table.contentOffset.y;
    CGFloat threshold = self.Table.frame.size.height - self.Table.frame.size.height;
    
    if (yOffset > -threshold && yOffset < 0) {
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,-yOffset,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
    }
    else if (yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,221.0-yOffset + floorf(threshold / 2.0));
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
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

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

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
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
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Moscow/2" ofType:@"mbtiles"]];
    }
    if ([self.CityNameText isEqualToString:@"Vienna"] || [self.CityNameText isEqualToString:@"Вена"] || [self.CityNameText isEqualToString:@"Wien"]){
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Vienna/vienna" ofType:@"mbtiles"]];
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
    self.TablePlaces.backgroundColor = [UIColor clearColor];
    self.TablePlaces.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.CityImage.hidden = NO;
    self.CityName.hidden = NO;
    self.TablePlaces.hidden =NO;
    self.ViewforMap.hidden = YES;
    self.locationButton.hidden = YES;
    


    [self.ViewforMap addSubview:self.Map];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    Me = [locationManager location];
    NSLog(@"Around Me = %@", Me);
    
    
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
    else{
    }
    Rest = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Restaurants & Cafes" listOrMap:@"list"];
    Shopping = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Shopping" listOrMap:@"list"];
    Entertainment = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Entertainment" listOrMap:@"list"];
    Sport = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Health & Beauty" listOrMap:@"list"];
    
    
    
    NSArray  *RestMap = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Restaurants & Cafes" listOrMap:@"map"];
    NSArray  *ShoppingMap = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Shopping" listOrMap:@"map"];
    NSArray *EntertainmentMap = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Entertainment" listOrMap:@"map"];
    NSArray *SportMap = [ExternalFunctions getPlacesAroundMe:self.CityNameText myLocation:Me category:@"Health & Beauty" listOrMap:@"map"];
    
    RMAnnotation *marker1;
    for (int i=0; i<[RestMap count]; i++) {
        CLLocation *tmp = [RestMap objectAtIndex:i];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [Rest objectAtIndex:i];
        marker1.subtitle = @"Restaurants & Cafes";
        [self.Map addAnnotation:marker1];
    }
    
    for (int i=0; i<[ShoppingMap count]; i++) {
        CLLocation *tmp = [ShoppingMap objectAtIndex:i];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [Shopping objectAtIndex:i];
        marker1.subtitle = @"Shopping";
        [self.Map addAnnotation:marker1];
    }
    
    for (int i=0; i<[EntertainmentMap count]; i++) {
        CLLocation *tmp = [EntertainmentMap objectAtIndex:i];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [Entertainment objectAtIndex:i];
        marker1.subtitle = @"Entertainment";
        [self.Map addAnnotation:marker1];
    }
    
    for (int i=0; i<[SportMap count]; i++) {
        CLLocation *tmp = [SportMap objectAtIndex:i];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [Sport objectAtIndex:i];
        marker1.subtitle = @"Health & Beauty";
        [self.Map addAnnotation:marker1];
    }
    
    
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    self.CityName.text = AMLocalizedString(@"Around Me", nil);
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityImage.image = [UIImage imageNamed:self.Image];
    
    
    self.TablePlaces.separatorStyle = UITableViewCellSeparatorStyleNone;

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
    NSLog(@"123");
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
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(IBAction) segmentedControlIndexChanged{
    self.CityImage.hidden=!self.CityImage.hidden;
    self.CityName.hidden=!self.CityName.hidden;
    self.TablePlaces.hidden=!self.TablePlaces.hidden;
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
    
    [self.TablePlaces deselectRowAtIndexPath:[self.TablePlaces indexPathForSelectedRow] animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    [self.TablePlaces reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = [Rest count];
            break;
        case 1:
            number = [Entertainment count];
            break;
        case 2:
            number = [Shopping count];
        default:
            break;
        case 3:
            number = [Sport count];
            break;
    }
    return number;
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

    switch ([indexPath section]) {
        case 0:
            [cell addSubview:[InterfaceFunctions TableLabelwithText:[Rest objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions colorTextCategory:@"Restaurants & Cafes"] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions goLabelCategory:@"Restaurants & Cafes"]];
            [cell addSubview:[InterfaceFunctions actbwithCategory:@"Restaurants & Cafes"]];
            break;
        case 1:
            
            [cell addSubview:[InterfaceFunctions TableLabelwithText:[Entertainment objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions colorTextCategory:@"Entertainment"] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions goLabelCategory:@"Entertainment"]];
            [cell addSubview:[InterfaceFunctions actbwithCategory:@"Entertainment"]];
            break;
        case 2:
            [cell addSubview:[InterfaceFunctions TableLabelwithText:[Shopping objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions colorTextCategory:@"Shopping"] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions goLabelCategory:@"Shopping"]];
            [cell addSubview:[InterfaceFunctions actbwithCategory:@"Shopping"]];
            break;
        case 3:
            [cell addSubview:[InterfaceFunctions TableLabelwithText:[Sport objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions colorTextCategory:@"Health & Beauty"] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions goLabelCategory:@"Health & Beauty"]];
            [cell addSubview:[InterfaceFunctions actbwithCategory:@"Health & Beauty"]];
            break;
        default:
            break;
    }
    

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    NSArray *categories = @[@"Restaurants & Cafes", @"Entertainment", @"Shopping", @"Health & Beauty"];
    UIView *header = [InterfaceFunctions headerwithCategory:[categories objectAtIndex:section]];
	return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
    
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = [Rest count];
            break;
        case 1:
            number = [Entertainment count];
            break;
        case 2:
            number = [Shopping count];
        default:
            break;
        case 3:
            number = [Sport count];
            break;
    }
    if (number == 0)
        return 0;
    else
        return 0;
}
 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"CellSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [HUD hide:YES];
    
    if ([[segue identifier] isEqualToString:@"CellSegue"]) {
        PlaceViewController *destination =[segue destinationViewController];
        NSIndexPath *indexPath = [self.TablePlaces indexPathForSelectedRow];
        
        destination.PlaceCityName = self.CityNameText;
        switch ([indexPath section]) {
            case 0:
                destination.PlaceName  = [Rest objectAtIndex:[indexPath row]];
                destination.PlaceCategory =  @"Restaurants & Cafes";
                 destination.Color = [InterfaceFunctions colorTextPlaceBackground: @"Restaurants & Cafes"];
                break;
            case 1:
                destination.PlaceName = [Entertainment objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Entertainment";
                 destination.Color = [InterfaceFunctions colorTextPlaceBackground:@"Entertainment"];
                break;
            case 2:
                destination.PlaceName = [Shopping objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Shopping";
                destination.Color = [InterfaceFunctions colorTextPlaceBackground:@"Shopping"];
                break;

            case 3:
                destination.PlaceName = [Sport objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Health & Beauty";
                destination.Color = [InterfaceFunctions colorTextPlaceBackground:@"Health & Beauty"];
            default:
                break;
                
        }
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
        PlaceView.PlaceCityName = self.CityNameText;
        PlaceView.Color = [InterfaceFunctions colorTextCategory:PlaceCategory];
    }
}



- (void)updateOffsets {
    
    
    
    CGFloat yOffset   = self.TablePlaces.contentOffset.y;
   // CGFloat xOffset   = self.TablePlaces.contentOffset.x;
    CGFloat threshold = self.TablePlaces.frame.size.height - self.TablePlaces.frame.size.height;
    
    // NSLog(@"%.4f %.4f %.4f",yOffset,xOffset,threshold);

    if (yOffset > -threshold && yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-yOffset,320.0,self.CityImage.frame.size.height);
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,-yOffset,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.gradient_under_cityname.frame = CGRectMake(self.gradient_under_cityname.frame.origin.x,-yOffset,self.gradient_under_cityname.frame.size.width,self.gradient_under_cityname.frame.size.height);
        
        // NSLog(@"1");

    } else if (yOffset < 0) {
        // NSLog(@"2");
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,152.0-yOffset + floorf(threshold / 2.0));
        
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

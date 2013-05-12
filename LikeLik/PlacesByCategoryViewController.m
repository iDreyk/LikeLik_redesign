//
//  PlacesByCategoryViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 10.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "PlacesByCategoryViewController.h"
#import "PlaceViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"

#import <MapBox/MapBox.h>

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;

@interface PlacesByCategoryViewController ()

@end

@implementation PlacesByCategoryViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"123");
    CategoryPlaces = [ExternalFunctions getArrayOfPlaceDictionariesInCategory:self.Category InCity:self.CityName];
    NSLog(@"%@",CategoryPlaces);
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
    
    #warning Андрей, сделай плз функцию
    NSURL *url;
    if ([self.CityName isEqualToString:@"Moscow"] || [self.CityName isEqualToString:@"Москва"] || [self.CityName isEqualToString:@"Moskau"]){
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Moscow/2" ofType:@"mbtiles"]];
    }
    if ([self.CityName isEqualToString:@"Vienna"] || [self.CityName isEqualToString:@"Вена"] || [self.CityName isEqualToString:@"Wien"]){
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Vienna/vienna" ofType:@"mbtiles"]];
    }
    
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.Map = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.Map.delegate = self;
    self.Map.hideAttribution = YES;
    self.Map.showsUserLocation = YES;
    if ([AppDelegate isiPhone5])
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    
    
    
    self.Map.minZoom = 13;
    self.Map.zoom = 13;
    //self.Map.maxzoom = 17;
    
    CLLocation *coord =[ExternalFunctions getCenterCoordinatesOfCity:self.CityName];
    self.Map.centerCoordinate = coord.coordinate;
    [self.Map setAdjustTilesForRetinaDisplay:YES];
    [self.ViewForMap addSubview:self.Map];
    
    RMAnnotation *marker1;
    for (int i=0; i<[CategoryPlaces count]; i++) {
        CLLocation *tmp = [[CategoryPlaces objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[CategoryPlaces objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = [[CategoryPlaces objectAtIndex:i] objectForKey:@"Category"];
        marker1.userInfo = [CategoryPlaces objectAtIndex:i];
        [self.Map addAnnotation:marker1];
    }
    
    
    
    [self.ViewForMap addSubview:self.Map];
    self.CityImage.hidden = NO;
    self.CategoryLabel.hidden = NO;
    self.PlacesTable.hidden =NO;
    self.GradientnderLabel.hidden = NO;
    self.ViewForMap.hidden = YES;
    self.locationButton.hidden = YES;
    
    self.CategoryLabel.text = AMLocalizedString(self.Category, nil);
    self.CategoryLabel.textColor = [UIColor whiteColor];
    self.CategoryLabel.font = [AppDelegate OpenSansSemiBold:60];
    
    
    self.CityImage.image = [UIImage imageNamed:self.Image];
    self.PlacesTable.backgroundColor = [UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btn = [InterfaceFunctions search_button];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
    [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];

}

-(IBAction)showLocation:(id)sender{
    
    [self.Map setCenterCoordinate:self.Map.userLocation.coordinate];
}


-(void)viewDidAppear:(BOOL)animated{
    if ([[[CLLocation alloc] initWithLatitude:self.Map.userLocation.coordinate.latitude longitude:self.Map.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName]] > 50000.0) {
        self.Map.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
        NSLog(@"Взяли центер города");
        self.locationButton.enabled = NO;

    }
    else{
        self.Map.centerCoordinate = self.Map.userLocation.coordinate;
        self.locationButton.enabled = YES;
    }
}

-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        //[NSString stringWithFormat:@"MapPin_1.png"]
        RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
        // NSLog(@"Hello %@",self.Сategory);
        [marker replaceUIImage:[InterfaceFunctions MapPin:self.Category].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return marker;
        
    }
    return nil;
}
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    
    PlaceName = annotation.title;
    PlaceCategory = annotation.subtitle;
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(void)Search{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
}




-(IBAction) segmentedControlIndexChanged{
    self.CityImage.hidden = !self.CityImage.hidden;
    self.CategoryLabel.hidden = !self.CategoryLabel.hidden;
    self.PlacesTable.hidden = !self.PlacesTable.hidden;
    self.ViewForMap.hidden = !self.ViewForMap.hidden;
    self.locationButton.hidden = !self.locationButton.hidden;
    self.GradientnderLabel.hidden = !self.GradientnderLabel.hidden;
    if (self.CityImage.hidden) {
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:0];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
        //self.navigationItem.titleView = titleview;
    }
    else{
        UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
        //self.navigationItem.titleView = titleview;
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.PlacesTable deselectRowAtIndexPath:[self.PlacesTable indexPathForSelectedRow] animated:YES];
}

- (void)viewDidUnload {
    [self setViewForMap:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CategoryPlaces count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell addSubview:[InterfaceFunctions TableLabelwithText:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
    
    [cell addSubview:[InterfaceFunctions goLabelCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]]];
    [cell addSubview:[InterfaceFunctions actbwithCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]]];
    
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
    
    if ([[segue identifier] isEqualToString:@"MapSegue"]) {
        PlaceViewController *PlaceView = [segue destinationViewController];
        PlaceView.PlaceName = PlaceName;
        PlaceView.PlaceCategory = [Place objectForKey:@"Category"];
        PlaceView.PlaceCityName = [Place objectForKey:@"City"];
        PlaceView.PlaceAddress = [Place objectForKey:@"Address"];
        PlaceView.PlaceAbout = [Place objectForKey:@"About"];
        PlaceView.PlaceTelephone = [Place objectForKey:@"Telephone"];
        PlaceView.PlaceWeb = [Place objectForKey:@"Web"];
        PlaceView.PlaceLocation = [Place objectForKey:@"Location"];
        PlaceView.PlaceCityName = self.CityName;
        PlaceView.Color = [InterfaceFunctions colorTextCategory:PlaceCategory];
    }
    
    if ([[segue identifier] isEqualToString:@"CellSegue"]) {
        
        PlaceViewController *destination =[segue destinationViewController];
        NSIndexPath *indexPath = [self.PlacesTable indexPathForSelectedRow];
        NSInteger row = [indexPath row];
        Place1 = [CategoryPlaces objectAtIndex:row];
        
        destination.PlaceName = [Place1 objectForKey:@"Name"];
        destination.PlaceCityName = self.CityName;
        destination.PlaceCategory = [Place1 objectForKey:@"Category"];
        destination.PlaceAddress = [Place1 objectForKey:@"Address"];
        destination.PlaceAbout = [Place1 objectForKey:@"About"];
        destination.PlaceWeb = [Place1 objectForKey:@"Web"];
        destination.PlaceTelephone = [Place1 objectForKey:@"Telephone"];
        destination.PlaceLocation = [Place1 objectForKey:@"Location"];
        destination.Color = [InterfaceFunctions colorTextPlaceBackground:self.Category];
    }
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.CityName;
    }
}



- (void)updateOffsets {
    
    
    
    CGFloat yOffset   = self.PlacesTable.contentOffset.y;
    CGFloat threshold = self.PlacesTable.frame.size.height - self.PlacesTable.frame.size.height;
    
    
    if (yOffset > -threshold && yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-yOffset,320.0,self.CityImage.frame.size.height);
        self.CategoryLabel.frame = CGRectMake(self.CategoryLabel.frame.origin.x,-yOffset,self.CategoryLabel.frame.size.width,self.CategoryLabel.frame.size.height);
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-yOffset,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
//        
        // NSLog(@"1");
        
    } else if (yOffset < 0) {
        // NSLog(@"2");
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,152.0-yOffset + floorf(threshold / 2.0));
        
        self.CategoryLabel.frame = CGRectMake(self.CategoryLabel.frame.origin.x,4-(yOffset),self.CategoryLabel.frame.size.width,self.CategoryLabel.frame.size.height);
//        
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-9-yOffset,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
    } else {
        // NSLog(@"3");
        self.CityImage.frame = CGRectMake(0, -44.0, 320, self.CityImage.frame.size.height);
        
        
        self.CategoryLabel.frame = CGRectMake(self.CategoryLabel.frame.origin.x,4,self.CategoryLabel.frame.size.width,self.CategoryLabel.frame.size.height);
//        
//        
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-9,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
        
    }
    self.CityImage.contentMode = UIViewContentModeScaleAspectFit;
    //    self.CityImage.contentScaleFactor = 2.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}
 
@end

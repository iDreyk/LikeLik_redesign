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
@interface PlacesByCategoryViewController ()

@end

@implementation PlacesByCategoryViewController
@synthesize Places;
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
    Places = [NSArray arrayWithArray:[ExternalFunctions getPlacesOfCategory:self.District inCity:self.CityName listOrMap:@"list"]];//getPlacesOfCategory:self.District inCity:self.CityName]];
    self.navigationItem.backBarButtonItem = [AppDelegate back_button];
    
    
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
    
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
    self.Map.showsUserLocation = YES;
    
    
    CLLocation *tmp;
    CLLocationCoordinate2D coord1;
    // Annotations
 //   NSLog(@"Ку-ку");
     NSString *Title;
     NSArray *array = [ExternalFunctions getPlacesOfCategory:self.District inCity:self.CityName listOrMap:@"map"];
     NSArray *arraytitle = [ExternalFunctions getPlacesOfCategory:self.District inCity:self.CityName listOrMap:@"list"];
     //    nslog(@"array = %@", array);
     ////    nslog(@"arraytitle = %@", arraytitle);
     for (int i = 0; i < [array count]; i++) {
         //название района
         //NSString *district = [[array objectAtIndex:i] objectForKey:@"District"];
         NSArray *coordinatesArrayInOneDistrict = [[array objectAtIndex:i] objectForKey:@"Coordinates"];
         NSInteger numberofpins = [coordinatesArrayInOneDistrict count];
        for (int j = 0; j < numberofpins; j++) {
             tmp = [coordinatesArrayInOneDistrict objectAtIndex:j];
             coord1 = tmp.coordinate;
             Title = @"Pin";
             RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:coord1 andTitle:@"Pin"];
             marker1.annotationType = @"marker";
            marker1.title = [[[arraytitle objectAtIndex:i] objectForKey:@"Places"] objectAtIndex:j];
             marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
             marker1.subtitle = self.District;
             [self.Map addAnnotation:marker1];
        }
    }
    
    
    
    [self.ViewForMap addSubview:self.Map];
    _dataPlaces = @[@"",@"",@""];
    
    self.CityImage.hidden = NO;
    self.DistrictLabel.hidden = NO;
    self.PlacesTable.hidden =NO;
    self.GradientnderLabel.hidden = NO;
    self.ViewForMap.hidden = YES;
    self.locationButton.hidden = YES;
    
    self.DistrictLabel.text = AMLocalizedString(self.District, nil);
    self.DistrictLabel.textColor = [UIColor whiteColor];
    self.DistrictLabel.font = [AppDelegate OpenSansSemiBold:60];//BoldwithSize:60];
    
    
    self.CityImage.image = [UIImage imageNamed:self.Image];
    //[self.view addSubview:[InterfaceFunctions backgroundView]];
    self.PlacesTable.backgroundColor = [UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btn = [AppDelegate search_button];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *titleview = [AppDelegate segmentbar_map_list:1];
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
//        [self.locationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        self.Map.centerCoordinate = self.Map.userLocation.coordinate;
        self.locationButton.enabled = YES;
        // NSLog(@"Взяли локацию пользователя");
    }
}

-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        //[NSString stringWithFormat:@"MapPin_1.png"]
        RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
        // NSLog(@"Hello %@",self.District);
        [marker replaceUIImage:[InterfaceFunctions MapPin:self.District].image];
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
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(void)Search{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
}




-(IBAction) segmentedControlIndexChanged{
    self.CityImage.hidden = !self.CityImage.hidden;
    self.DistrictLabel.hidden = !self.DistrictLabel.hidden;
    self.PlacesTable.hidden = !self.PlacesTable.hidden;
    self.ViewForMap.hidden = !self.ViewForMap.hidden;
    self.locationButton.hidden = !self.locationButton.hidden;
    self.GradientnderLabel.hidden = !self.GradientnderLabel.hidden;
    if (self.CityImage.hidden) {
        UIButton *titleview = [AppDelegate segmentbar_map_list:0];
        [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
        //self.navigationItem.titleView = titleview;
    }
    else{
        UIButton *titleview = [AppDelegate segmentbar_map_list:1];
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
    return [Places count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Places objectAtIndex:section] objectForKey:@"Places"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;//@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    [cell addSubview:[InterfaceFunctions TableLabelwithText:[[[Places objectAtIndex:section] objectForKey:@"Places"] objectAtIndex:row] AndColor:[InterfaceFunctions colorTextCategory:self.District] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
    
    [cell addSubview:[InterfaceFunctions goLabelCategory:self.District]];
    [cell addSubview:[InterfaceFunctions actbwithCategory:self.District]];
    
    cell.selectedBackgroundView = [AppDelegate SelectedCellBG];
    cell.backgroundView = [AppDelegate CellBG];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   UIView *header =  [InterfaceFunctions HeaderwithDistrict: [[Places objectAtIndex:section] objectForKey:@"District"]];
	return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
    //return 30;
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
        PlaceView.PlaceCategory = PlaceCategory;
        PlaceView.Color = [InterfaceFunctions colorTextPlaceBackground:PlaceCategory];
        PlaceView.PlaceCityName = self.CityName;
    }
    
    if ([[segue identifier] isEqualToString:@"CellSegue"]) {
        
        PlaceViewController *destination =[segue destinationViewController];
        NSIndexPath *indexPath = [self.PlacesTable indexPathForSelectedRow];
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
         
        destination.PlaceName = [[[Places objectAtIndex:section] objectForKey:@"Places"] objectAtIndex:row];
        destination.PlaceCityName = self.CityName;
        destination.PlaceCategory = self.District;
        destination.Color = [InterfaceFunctions colorTextPlaceBackground:self.District];
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
        self.DistrictLabel.frame = CGRectMake(self.DistrictLabel.frame.origin.x,-yOffset,self.DistrictLabel.frame.size.width,self.DistrictLabel.frame.size.height);
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-yOffset,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
//        
        // NSLog(@"1");
        
    } else if (yOffset < 0) {
        // NSLog(@"2");
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,152.0-yOffset + floorf(threshold / 2.0));
        
        self.DistrictLabel.frame = CGRectMake(self.DistrictLabel.frame.origin.x,4-(yOffset),self.DistrictLabel.frame.size.width,self.DistrictLabel.frame.size.height);
//        
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-9-yOffset,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
    } else {
        // NSLog(@"3");
        self.CityImage.frame = CGRectMake(0, -44.0, 320, self.CityImage.frame.size.height);
        
        
        self.DistrictLabel.frame = CGRectMake(self.DistrictLabel.frame.origin.x,4,self.DistrictLabel.frame.size.width,self.DistrictLabel.frame.size.height);
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

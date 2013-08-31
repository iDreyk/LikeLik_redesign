//
//  FavViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 15.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "FavViewController.h"


#import "AppDelegate.h"
#import "PlaceViewController.h"
#import "SearchViewController.h"
#import <MapBox/MapBox.h>
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;
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

@interface FavViewController ()

@end

@implementation FavViewController
//
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
    //    nslog(@"FavoritePlaceView CityName = %@",self.CityName);
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
    FavouritePlaces = [ExternalFunctions getAllFavouritePlacesInCity:self.CityName];
   
    self.FavTable.backgroundView = [InterfaceFunctions backgroundView];
    self.FavTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIButton *btn = [InterfaceFunctions search_button];
//    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
    NSURL *url;
    if ([self.CityName isEqualToString:@"Moscow"] || [self.CityName isEqualToString:@"Москва"] || [self.CityName isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityName isEqualToString:@"Vienna"] || [self.CityName isEqualToString:@"Вена"] || [self.CityName isEqualToString:@"Wien"]){
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
    self.Map.minZoom =13;
    self.Map.zoom = 13;
//#warning maxzoom
    CLLocation *coord =[ExternalFunctions getCenterCoordinatesOfCity:self.CityName];
    self.Map.centerCoordinate = coord.coordinate;
    [self.Map setAdjustTilesForRetinaDisplay:YES];
        [self.ViewforMap addSubview:self.Map];
    
    RMAnnotation *marker1;
    for (int i=0; i<[FavouritePlaces count]; i++) {
        CLLocation *tmp = [[FavouritePlaces objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[FavouritePlaces objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = AMLocalizedString([[FavouritePlaces objectAtIndex:i] objectForKey:@"Category"], nil);
        marker1.userInfo = [FavouritePlaces objectAtIndex:i];
        [self.Map addAnnotation:marker1];
    }
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.Map addSubview:self.locationButton];
}

-(IBAction)showLocation:(id)sender{
    [self.Map setCenterCoordinate:self.Map.userLocation.coordinate];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[[CLLocation alloc] initWithLatitude:self.Map.userLocation.coordinate.latitude longitude:self.Map.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName]] > 50000.0) {
        self.Map.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
        [self.locationButton setEnabled:NO];
        // NSLog(@"Взяли центер города");
    }
    else{
        self.Map.centerCoordinate = self.Map.userLocation.coordinate;
        [self.locationButton setEnabled:YES];
        // NSLog(@"Взяли локацию пользователя");
    }
}


-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        //[NSString stringWithFormat:@"MapPin_1.png"]
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
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    PlaceName = annotation.title;
    PlaceCategory = [annotation.userInfo objectForKey:@"Category"];
    Place = annotation.userInfo;
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(void)Search{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.FavTable deselectRowAtIndexPath:[self.FavTable indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) segmentedControlIndexChanged{
    self.FavTable.hidden = !self.FavTable.hidden;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([FavouritePlaces count] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/4, 0.0, 0.0)];
        [label setText:AMLocalizedString(@"Add to Favorites best places", nil)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
        [label setFont:[AppDelegate OpenSansRegular:32]];
        [label setBackgroundColor:[UIColor clearColor]];
        
        
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,label.frame.origin.y +label.frame.size.height +40.0,0.0,0.0)];
        [sublabel setText:AMLocalizedString(@"To do this, just click on a star when you look interesting place ", nil)];
        sublabel.numberOfLines = 0;
        sublabel.textAlignment = NSTextAlignmentCenter;
        [sublabel sizeToFit];
        [sublabel setFrame:CGRectMake((320.0-sublabel.frame.size.width)/2, label.frame.origin.y + label.frame.size.height + 40.0, sublabel.frame.size.width, sublabel.frame.size.height+30)];
        [sublabel setFont:[AppDelegate OpenSansRegular:32]];
        [sublabel setBackgroundColor:[UIColor clearColor]];
        
        
        [self.FavTable.backgroundView addSubview:[InterfaceFunctions favourite_star_empty]];
        self.FavTable.backgroundView.backgroundColor = [UIColor whiteColor];
        [self.FavTable.backgroundView addSubview:label];
        [self.FavTable.backgroundView addSubview:sublabel];
    }
    
    
    return [FavouritePlaces count];
    
}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSInteger row = [indexPath row];
//    static NSString *CellIdentifier = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    [cell addSubview:[InterfaceFunctions TableLabelwithText:[[FavouritePlaces objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[FavouritePlaces objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
//   
//    [cell addSubview:[InterfaceFunctions goLabelCategory:[[FavouritePlaces objectAtIndex:row] objectForKey:@"Category"]]];
//    [cell addSubview:[InterfaceFunctions actbwithCategory:[[FavouritePlaces objectAtIndex:row] objectForKey:@"Category"]]];
//    
//    cell.backgroundView = [InterfaceFunctions CellBG];
//    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *category = [[FavouritePlaces objectAtIndex:row] objectForKey:@"Category"];
    
    if (cell == nil) { // init the cell
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //202,148,78
        
        // плитка, на которую всё накладываем
        CGFloat x_dist = 3;
        CGFloat y_dist = 3;
        CGFloat cellWidth = 314;
        CGFloat cellHeight = 42;
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(x_dist, y_dist, cellWidth, cellHeight)];
        CALayer * back_layer = back.layer;
        back_layer.cornerRadius = 5;
        back.clipsToBounds = YES;
        back.tag = cellColorTag;
        back.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:back]; // добавили на cell
        
        
        cell.contentView.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer * imgLayer = back.layer;
        [imgLayer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imgLayer setBorderWidth:0.5f];
        [imgLayer setShadowColor: [[UIColor blackColor] CGColor]];
        [imgLayer setShadowOpacity:0.9f];
        [imgLayer setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer setShadowRadius:3.0];
        // [imgLayer setCornerRadius:4];
        imgLayer.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer setRasterizationScale:[UIScreen mainScreen].scale];
        
        // заголовок
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , cellWidth, 42)];
        CALayer *layer2 = nameLabel.layer;
        layer2.cornerRadius = 5;
        nameLabel.clipsToBounds = YES;
        nameLabel.tag = labelColorTag;
        [back addSubview:nameLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0,280, cell.center.y*2)];
        
        label.tag = tableLabelWithTextTag;
        label.font = [AppDelegate OpenSansSemiBold:35];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [back addSubview:label];
    }
    UILabel * buttonlabel = (UILabel *)[cell viewWithTag:buttonlabel1Tag];
    buttonlabel.backgroundColor =[InterfaceFunctions colorTextCategory:category];
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[FavouritePlaces objectAtIndex:row] objectForKey:@"Name"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:labelColorTag];
    label.backgroundColor = [InterfaceFunctions colorTextCategory:category];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"PlaceSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    nslog(@"Hello!");
    NSString *Place = [[FavouritePlaces objectAtIndex:[indexPath row]] objectForKey:@"Name"];
    NSString *Category = [[FavouritePlaces objectAtIndex:[indexPath row]] objectForKey:@"Category"];
    [ExternalFunctions removeFromFavoritesPlace:Place InCategory:Category InCity:self.CityName];
    FavouritePlaces = [ExternalFunctions getAllFavouritePlacesInCity:self.CityName];
    [tableView reloadData];
    
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"PlaceSegue"]) {
        PlaceViewController *destinaton  = [segue destinationViewController];
        NSIndexPath *indexpath = [self.FavTable indexPathForSelectedRow];
        Place1 = [FavouritePlaces objectAtIndex:[indexpath row]];
        destinaton.PlaceCityName = [Place1 objectForKey:@"City"];
        destinaton.PlaceName = [Place1 objectForKey:@"Name"];
        destinaton.PlaceCategory = [Place1 objectForKey:@"Category"];
        destinaton.PlaceAbout = [Place1 objectForKey:@"About"];
        destinaton.PlaceWeb = [Place1 objectForKey:@"Web"];
        destinaton.PlaceTelephone = [Place1 objectForKey:@"Telephone"];
        destinaton.PlaceLocation = [Place1 objectForKey:@"Location"];
        destinaton.PlaceAddress = [Place1 objectForKey:@"Address"];
        destinaton.Color = [InterfaceFunctions colorTextPlaceBackground:[Place1 objectForKey:@"Category"]];
        destinaton.Photos = [Place1 objectForKey:@"Photo"];
    }
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.CityName;
    }
    
    if ([[segue identifier] isEqualToString:@"MapSegue"]) {
        // NSLog(@"123");
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
        PlaceView.Color = [InterfaceFunctions colorTextPlaceBackground:PlaceCategory];
        PlaceView.Photos = [Place objectForKey:@"Photo"];
    }
}

@end

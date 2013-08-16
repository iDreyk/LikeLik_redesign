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
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#import <MapBox/MapBox.h>

#define tableLabelWithTextTag 87001
#define goLAbelTag 87002
#define arrowTag 87003
#define backgroundViewTag 87004

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;

NSInteger PREV_SECTION = 0;
static bool REVERSE_ANIM = false;


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
  //  NSLog(@"123");
    CategoryPlaces = [ExternalFunctions getArrayOfPlaceDictionariesInCategory:self.Category InCity:self.CityName];
 //   NSLog(@"%@ %d",CategoryPlaces, [CategoryPlaces count]);
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"List", nil) forSegmentAtIndex:0];
    [self.SegmentedMapandTable setTitle:AMLocalizedString(@"Map", nil) forSegmentAtIndex:1];
    
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
    self.Map.hideAttribution = YES;
    self.Map.showsUserLocation = YES;
    if ([AppDelegate isiPhone5])
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.Map.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    
    self.Map.minZoom = 10;
    self.Map.zoom = 13;
    self.Map.maxZoom = 17;
    
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
    
    
    self.CityImage.image = [UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:self.CityName]];
    self.PlacesTable.backgroundColor = [InterfaceFunctions BackgroundColor];//[UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btn = [InterfaceFunctions search_button];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *titleview = [InterfaceFunctions segmentbar_map_list:1];
    [titleview addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(!self.imageCache)
        self.imageCache = [[NSMutableDictionary alloc] init];
    
}

-(IBAction)showLocation:(id)sender{
    
    [self.Map setCenterCoordinate:self.Map.userLocation.coordinate];
}


-(void)viewDidAppear:(BOOL)animated{
    
//    if ([CategoryPlaces count] == 1) {
//        NSLog(@"hello");`
//        //self.CityImage.contentMode = UIViewContentModeScaleToFill;
//        self.CityImage.frame = CGRectMake(0, 0.0, 320, 76.0);
//        
//        
//    }
    
    [TestFlight passCheckpoint:self.Category];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)loadImageFromCache:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    UIImage* theImage = [self.imageCache objectForKey:url];
    if ((nil != theImage) && [theImage isKindOfClass:[UIImage class]]) {
        NSLog(@"img loaded from cache!");
        completionBlock(YES, theImage);
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage *cropedImage = [[UIImage alloc] init];
        UIImage *image = [UIImage imageWithContentsOfFile:url];
        CGImageRef imgRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 400, 640, 360));
        cropedImage = [UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
        [self.imageCache setObject:cropedImage forKey:url];
        NSLog(@"img saved to cache! (%@)", [self.imageCache objectForKey:url]);
        NSLog(@"Images in cache: %d", [self.imageCache count]);
            dispatch_async(dispatch_get_main_queue(), ^ {
                completionBlock(YES,cropedImage);
            });

        });
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:[NSOperationQueue mainQueue]
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                                   if ( !error )
//                                   {
//                                       UIImage *image = [[UIImage alloc] initWithData:data];
//                                       [self.imageCache setObject:image forKey:url];
//                                       NSLog(@"img saved to cache! (%@)", [self.imageCache objectForKey:url]);
//                                       NSLog(@"Images in cache: %d", [self.imageCache count]);
//                                       completionBlock(YES,image);
//                                   } else{
//                                       completionBlock(NO, nil);
//                                   }
//                               }];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
#warning Временно ?
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 170)];
        preview.tag = backgroundViewTag;
        preview.backgroundColor = [UIColor whiteColor];
        preview.clipsToBounds = NO;
        CALayer * imgLayer = preview.layer;
        
        [imgLayer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imgLayer setBorderWidth:0.5f];
        [imgLayer setShadowColor: [[UIColor blackColor] CGColor]];
        [imgLayer setShadowOpacity:0.9f];
        [imgLayer setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer setShadowRadius:3.0];
        //        [imgLayer setCornerRadius:4];
        imgLayer.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer setRasterizationScale:[UIScreen mainScreen].scale];

        [cell.contentView addSubview:preview];

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)];
        
        //[InterfaceFunctions TableLabelwithText:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)];
        label.tag = tableLabelWithTextTag;  
        label.font = [AppDelegate OpenSansRegular:28];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
//        label.text = [[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"];
        label.textColor = [InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [preview addSubview:label];
        
        
        
        UILabel *goLabel = [InterfaceFunctions goLabelCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        [preview addSubview:goLabel];
        UIImageView *arrow = [InterfaceFunctions actbwithCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        [preview addSubview:arrow];
        
    }
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"];
    
    Place1 = [CategoryPlaces objectAtIndex:row];
    NSArray *photos = [Place1 objectForKey:@"Photo"];
       [self loadImageFromCache:[photos objectAtIndex:0] completionBlock:^(BOOL succeeded, UIImage *image) {
        if(succeeded){
            UIImageView *preview = (UIImageView *)[cell viewWithTag:backgroundViewTag];
            preview.image = image;
        }
    }];
    //cell.backgroundView = bkgView;
    
    //cell.backgroundView = [InterfaceFunctions CellBG];
    //cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    if(PREV_SECTION > row)
        REVERSE_ANIM = true;
    else
        REVERSE_ANIM = false;
    
    PREV_SECTION = row;
    UIView *myView = [[cell subviews] objectAtIndex:0];
    CALayer *layer = myView.layer;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/2, 1, 0, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -1, 1, 1, 1);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI, -M_PI, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI, 0, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 2 * M_PI / 2, 100, 1, 100);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, -8.0f, 1.0f, 0.0f);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, 0, 1.0f, 0.0f);
        //  rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, -2.0f, 1.0f, 0.0f);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 1, 0, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 1, -1, -1, 1);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI, M_PI, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI, 0, M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 2 * M_PI / 2, -100, 1, 100);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, -8.0f, 1.0f, 0.0f);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, 0, 1.0f, 0.0f);
        // rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, -2.0f, 1.0f, 0.0f);
    }
    
    layer.transform = rotationAndPerspectiveTransform;
    
    
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.75];
    //[cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 1, 0, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 1, 1, 1, 1);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, -M_PI, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, 0, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -2 * M_PI / 2, 100, 1, 100);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, -8.0f, 1.0f, 0.0f);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, 0, 1.0f, 0.0f);
        // rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, -2.0f, 1.0f, 0.0f);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/2, 1, 0, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -1, -1, -1, 1);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, M_PI, -M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, 0, M_PI, 0);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -2 * M_PI / 2, -100, 1, 100);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, -8.0f, 1.0f, 0.0f);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -90.0f * M_PI / 180.0f, 0, 1.0f, 0.0f);
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, -2.0f, 1.0f, 0.0f);
    }
    layer.transform = rotationAndPerspectiveTransform;
    [UIView commitAnimations];
    
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
        PlaceView.Photos = [Place objectForKey:@"Photo"];
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
        destination.Photos = [Place1 objectForKey:@"Photo"];
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
        
//        if ([CategoryPlaces count] == 1)
//            self.CityImage.frame = CGRectMake(0,-44.0,320.0,76.0-yOffset + floorf(threshold / 2.0));
//        else
            self.CityImage.frame = CGRectMake(0,-44.0,320.0,221.0-yOffset + floorf(threshold / 2.0));
        
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

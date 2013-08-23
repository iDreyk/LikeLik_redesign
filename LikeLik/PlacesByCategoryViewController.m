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
#define backTag 87005
#define distanceTag 87006

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
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];//[InterfaceFunctions colorTextCategory:self.Category];
    
    //  NSLog(@"123");
    CategoryPlaces = self.categoryArray;//[ExternalFunctions getArrayOfPlaceDictionariesInCategory:self.Category InCity:self.CityName];
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
        marker1.subtitle = AMLocalizedString([[CategoryPlaces objectAtIndex:i] objectForKey:@"Category"], nil);
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
    self.PlacesTable.backgroundColor = [UIColor clearColor];//[InterfaceFunctions colorTextCategory:self.Category];
    //[InterfaceFunctions BackgroundColor];//[UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PlacesTable.showsVerticalScrollIndicator = NO;
    self.PlacesTable.showsHorizontalScrollIndicator = NO;
    
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
        NSLog(@"Взяли центр города");
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
        [marker replaceUIImage:[InterfaceFunctions MapPin:AMLocalizedString(self.Category, nil)].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return marker;
        
    }
    return nil;
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




-(IBAction) segmentedControlIndexChanged{
    self.backgroundView.hidden = !self.backgroundView.hidden;
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

- (void)loadImageFromCache:(NSString *)url :(NSString *)backup completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    UIImage* theImage = [self.imageCache objectForKey:url];
    UIImage* backupImg = [self.imageCache objectForKey:backup];
    
    if ((nil != theImage) && [theImage isKindOfClass:[UIImage class]]) {
        NSLog(@"img loaded from cache!");
        completionBlock(YES, theImage);
    }
    else if((nil != backupImg) && [backupImg isKindOfClass:[UIImage class]]){
        NSLog(@"img loaded from cache!");
        completionBlock(YES, backupImg);
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:url];
            UIImage *cropedImage = [[UIImage alloc] init];
            if(!image){
                image = [UIImage imageWithContentsOfFile:backup];
                CGImageRef imgRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 400, 640, 360));
                cropedImage = [UIImage imageWithCGImage:imgRef];
                CGImageRelease(imgRef);
                [self.imageCache setObject:cropedImage forKey:backup];
                NSLog(@"img saved to cache! (%@)", [self.imageCache objectForKey:backup]);
            }
            else{
                cropedImage = image;
                [self.imageCache setObject:cropedImage forKey:url];
                NSLog(@"img saved to cache! (%@)", [self.imageCache objectForKey:url]);
            }
            NSLog(@"Images in cache: %d", [self.imageCache count]);
            dispatch_async(dispatch_get_main_queue(), ^ {
                completionBlock(YES,cropedImage);
            });
            
        });
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 306, 166)];
        back.backgroundColor = [InterfaceFunctions colorTextCategory:self.Category];
        back.tag = backTag;
        [cell.contentView addSubview:back];
        
        
        cell.contentView.backgroundColor =[UIColor whiteColor];//[[InterfaceFunctions colorTextCategory:self.Category] colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = 220;
        UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, width, width / 1.852)];
        preview.tag = backgroundViewTag;
        preview.backgroundColor = [UIColor whiteColor];
        preview.clipsToBounds = NO;
        
        CALayer * imgLayer1 = preview.layer;
        [imgLayer1 setBorderColor: [[UIColor whiteColor] CGColor]];
        [imgLayer1 setBorderWidth:0.5f];
        [imgLayer1 setShadowColor: [[UIColor whiteColor] CGColor]];
        [imgLayer1 setShadowOpacity:0.9f];
        [imgLayer1 setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer1 setShadowRadius:3.0];
        //        [imgLayer setCornerRadius:4];
        imgLayer1.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer1 setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer1.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer1 setRasterizationScale:[UIScreen mainScreen].scale];
        
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(12, preview.frame.size.height + 10, preview.frame.size.width, 30)];
        text.text = @"Комплимент от заведения: чашка кофе.";
        text.backgroundColor = [UIColor clearColor];
        text.textColor = [UIColor whiteColor];
        text.font = [UIFont boldSystemFontOfSize:10];
        [back addSubview:text];
        
        
        CALayer * imgLayer = back.layer;
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
        
        [back addSubview:preview];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, -12.0, 260, cell.center.y*2)];
        
        label.tag = tableLabelWithTextTag;
        label.font = [AppDelegate OpenSansRegular:28];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
        //        label.text = [[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"];
        label.textColor = [UIColor whiteColor];//[InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [back addSubview:label];
        
        UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(preview.frame.size.width + 20, preview.frame.origin.y, 55, 20)];
        distance.font = [UIFont systemFontOfSize:10];
        distance.tag = distanceTag;
        distance.textColor = [UIColor whiteColor];
        distance.backgroundColor = [UIColor clearColor];
        [back addSubview:distance];
        
        //        UILabel *goLabel = [InterfaceFunctions goLabelCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        //        [back addSubview:goLabel];
        //        UIImageView *arrow = [InterfaceFunctions actbwithCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        //        [back addSubview:arrow];
        
    }
    //    NSLog(@"PLACE1: %@", Place1);
    NSNumber *distance = [[CategoryPlaces objectAtIndex:row] objectForKey:@"Distance"];
    float intDist = [distance floatValue];
    
    UILabel *dist = (UILabel *)[cell viewWithTag:distanceTag];
    if(intDist > 1000)
        dist.text = [NSString stringWithFormat:@"%.2f km", intDist / 1000.];
    else
        dist.text = [NSString stringWithFormat:@"%.0f m", intDist];
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"];
    
    Place1 = [CategoryPlaces objectAtIndex:row];
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
    if(PREV_SECTION > row)
        REVERSE_ANIM = true;
    else
        REVERSE_ANIM = false;
    
    PREV_SECTION = row;
    //UIView *myView = [[cell subviews] objectAtIndex:0];
    UIView *myView = (UIView *)[cell viewWithTag:backTag];
    CALayer *layer = myView.layer;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/3, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/3, 1, 0, 0);
    }
    
    layer.transform = rotationAndPerspectiveTransform;
    
    
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.75];
    //[cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/3, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/3, 1, 0, 0);
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
        destinaton.readyArray = self.categoryArray;
    }
}



- (void)updateOffsets {
    CGFloat yOffset   = self.PlacesTable.contentOffset.y;
    if (yOffset < 0) {
        self.backgroundView.frame = CGRectMake(0, self.PlacesTable.frame.origin.y - yOffset, 320, self.PlacesTable.frame.size.height);
        self.CityImage.frame = CGRectMake(0, -280.0, 320.0, 568.0 - yOffset);
        self.CategoryLabel.frame = CGRectMake(self.CategoryLabel.frame.origin.x,4-(yOffset),self.CategoryLabel.frame.size.width,self.CategoryLabel.frame.size.height);
        //
        self.GradientnderLabel.frame = CGRectMake(self.GradientnderLabel.frame.origin.x,-9-yOffset,self.GradientnderLabel.frame.size.width,self.GradientnderLabel.frame.size.height);
    } else {
        // NSLog(@"3");
        self.backgroundView.frame = CGRectMake(0, self.PlacesTable.frame.origin.y , 320, self.PlacesTable.frame.size.height);
        self.CityImage.frame = CGRectMake(0, -280.0, 320, self.CityImage.frame.size.height);
        
        
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

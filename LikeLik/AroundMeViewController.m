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
#import "CheckViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapBox/MapBox.h>
#import "RegistrationViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

//
//
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
#define afterregister             @"l27h7RU2dzVfP12aoQssda"

static NSString *PlaceName = @"";
static NSString *PlaceCategory = @"";
static NSDictionary *Place;
static NSDictionary *Place1;
static CGFloat width = 180;//220;

NSInteger PREV_SECTION_AROUNDME = 0;
bool REVERSE_ANIM = false;

@interface UIButtonWithAditionalNum ()

@end

@implementation UIButtonWithAditionalNum

@end

@interface AroundMeViewController ()

@end


@implementation AroundMeViewController
@synthesize HUD,knuck;
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
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:216/255.0 green:219/255.0 blue:220/255.0 alpha:1];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:216/255.0 green:219/255.0 blue:220/255.0 alpha:1];//[InterfaceFunctions colorTextCategory:self.Category];

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
    
    self.PlacesTable.backgroundColor = [UIColor clearColor];
    self.PlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PlacesTable.showsHorizontalScrollIndicator = NO;
    self.PlacesTable.showsVerticalScrollIndicator = NO;
    
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
        HUD.detailsLabelFont = [AppDelegate OpenSansBoldwithSize:28];
        HUD.detailsLabelText = AMLocalizedString(@"Apparently, you've disabled this application to access your geolocation", nil);//customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Apparently, you've disabled this application to access your geolocation", nil)];
        
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
    // NSLog(@"Ready array: %@", self.readyArray);
    AroundArray = [[NSArray alloc] initWithArray:self.readyArray];
    RMAnnotation *marker1;
    for (int i=0; i<[AroundArray count]; i++) {
        CLLocation *tmp = [[AroundArray objectAtIndex:i] objectForKey:@"Location"];
        marker1 = [[RMAnnotation alloc]initWithMapView:self.Map coordinate:tmp.coordinate andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        marker1.title = [[AroundArray objectAtIndex:i] objectForKey:@"Name"];
        marker1.subtitle = AMLocalizedString([[AroundArray objectAtIndex:i] objectForKey:@"Category"], nil);
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
    
    if(!self.imageCache)
        self.imageCache = [[NSMutableDictionary alloc] init];
    
    if ([AppDelegate isiPhone5])
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
    else
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController35" bundle:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(test:)
                                                 name: afterregister
                                               object: nil];
}

-(void)test:(id)sender{
    
    NSLog(@"test : %@ %@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"], [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"],[[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"]);
    
    [self presentSemiViewController:VC withOptions:@{
     KNSemiModalOptionKeys.pushParentBack    : @(YES),
     KNSemiModalOptionKeys.animationDuration : @(0.5),
     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
     }];
    
    
    VC.view.backgroundColor = [UIColor clearColor];
    VC.PlaceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"];
    VC.PlaceCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"];
    VC.PlaceCity =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"];
    VC.color = [InterfaceFunctions colorTextCategory:@"Category"];
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
    PlaceCategory = [annotation.userInfo objectForKey:@"Category"];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
            UIImage * image = [UIImage imageWithContentsOfFile:url];
            UIImage *cropedImage = [[UIImage alloc] init];
            NSLog(@"here");
            if(!image){
                image = [UIImage imageWithContentsOfFile:backup];
                CGImageRef imgRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 400,width, width/1.852));
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


//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = [indexPath row];
//    static NSString *CellIdentifier = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//
//
//   // NSLog(@"Around Me = %@",[[AroundArray objectAtIndex:row] objectForKey:@"Category"]);
//
//    [cell addSubview:[InterfaceFunctions TableLabelwithText:[[AroundArray objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
//
//    [cell addSubview:[InterfaceFunctions goLabelCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]]];
//    [cell addSubview:[InterfaceFunctions actbwithCategory:[[AroundArray objectAtIndex:row] objectForKey:@"Category"]]];
//
//    cell.backgroundView = [InterfaceFunctions CellBG];
//    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
//    return cell;
//}

#pragma mark - cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *category = [[AroundArray objectAtIndex:row] objectForKey:@"Category"];
    
    if (cell == nil) { // init the cell
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //202,148,78
        
        // плитка, на которую всё накладываем
        CGFloat x_dist = 3;
        CGFloat y_dist = 3;
        CGFloat cellWidth = 314;
        CGFloat cellHeight = 181;
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(x_dist, y_dist, cellWidth, cellHeight)];
        CALayer * back_layer = back.layer;
        back_layer.cornerRadius = 5;
        back.clipsToBounds = YES;
        back.tag = cellColorTag;
        back.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:back]; // добавили на cell
        
        
        cell.contentView.backgroundColor =[UIColor lightGrayColor];//[UIColor colorWithRed:216/255.0 green:219/255.0 blue:220/255.0 alpha:1];//[[InterfaceFunctions colorTextCategory:category] colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //  картинка
        CGFloat img_x_dist = 7;
        CGFloat img_y_dist = 63;
        UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(img_x_dist, img_y_dist, width, width / 1.852)];
        preview.tag = backgroundViewTag;
        preview.backgroundColor =  [UIColor whiteColor];
        preview.clipsToBounds = NO;
        
        CALayer * imgLayer1 = preview.layer;
        [imgLayer1 setBorderColor: [[UIColor blackColor] CGColor]];
        [imgLayer1 setBorderWidth:0.5f];
        [imgLayer1 setShadowColor: [[UIColor blackColor] CGColor]];
        [imgLayer1 setShadowOpacity:0.9f];
        [imgLayer1 setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer1 setShadowRadius:3.0];
        // [imgLayer setCornerRadius:4];
        imgLayer1.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer1 setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer1.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer1 setRasterizationScale:[UIScreen mainScreen].scale];
        
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
        
        [back addSubview:preview];
        // картинку сделали
        
        
        // анонс
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(width + 2*img_x_dist, img_y_dist, cellWidth - width - 2*img_x_dist, 65)];
        //text.backgroundColor = [UIColor blackColor];
//        text.backgroundColor = [UIColor clearColor];
        //text.textAlignment = NSTextAlignment;
        text.textColor = [UIColor blackColor];
        text.font = [AppDelegate OpenSansRegular:20];//[UIFont systemFontOfSize:10];
        text.tag = announceTag;
        text.numberOfLines = 5;
        [back addSubview:text];
        
        // заголовок
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , cellWidth, 42)];
        CALayer *layer2 = nameLabel.layer;
        layer2.cornerRadius = 5;
        nameLabel.clipsToBounds = YES;
        
        // первая кнопка
//        UILabel * buttonlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(width + 2*img_x_dist - 2 + img_x_dist + 5, img_y_dist + width/1.852 - 24 -2 , 26, 26)];
//        CALayer *layer1 = buttonlabel1.layer;
//        layer1.cornerRadius = 3;
//        buttonlabel1.clipsToBounds = YES;
//        buttonlabel1.tag = buttonlabel1Tag;
        
        // кнопка с кулаком
        knuck = [[UIButtonWithAditionalNum alloc] initWithFrame:CGRectMake(width + 2*img_x_dist + 2*img_x_dist + 2*img_x_dist  + 5, img_y_dist + width/1.852 - 2*img_x_dist - 11, 60, 26)];
        knuck.tag = checkTag;
        knuck.backgroundColor = [InterfaceFunctions corporateIdentity];
        knuck.layer.cornerRadius = 3;
        [knuck addSubview:[[UIImageView alloc]initWithImage:[self imageWithImage:[UIImage imageNamed:@"kul_90"] scaledToSize:CGSizeMake(24,24)]]];
        
        UILabel *checkText = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, knuck.frame.size.width - 26, knuck.frame.size.height)];
        checkText.text = @"Use";
        checkText.font = [AppDelegate OpenSansBoldwithSize:32];
        checkText.backgroundColor = [UIColor clearColor];
        checkText.textColor = [UIColor whiteColor];
        [knuck addSubview:checkText];
        // knuck.imageView.image = [UIImage imageNamed:@"kul_90"];
        [knuck addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        nameLabel.tag = labelColorTag;
        
//        [back addSubview:buttonlabel1];
        [back addSubview:nameLabel];
        [back addSubview:knuck];

        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0,280, cell.center.y*2)];
        
        //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        //        line.backgroundColor = [[InterfaceFunctions colorTextCategory:category] colorWithAlphaComponent:0.3];
        //        [preview addSubview:line];
        
        
        //      [InterfaceFunctions TableLabelwithText:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)];
        
        
        label.tag = tableLabelWithTextTag;
        label.font = [AppDelegate OpenSansSemiBold:45];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [back addSubview:label];
        
        UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(img_x_dist, cellHeight - 15, 100, 15)];
        distance.textAlignment = NSTextAlignmentLeft;
        distance.font = [AppDelegate OpenSansBoldwithSize:20];//[UIFont systemFontOfSize:10];
        distance.tag = distanceTag;
        distance.textColor = [UIColor grayColor];
        distance.backgroundColor = [UIColor clearColor];
        [back addSubview:distance];
        
        //        UILabel *goLabel = [InterfaceFunctions goLabelCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        //        [back addSubview:goLabel];
        //        UIImageView *arrow = [InterfaceFunctions actbwithCategory:[[CategoryPlaces objectAtIndex:row] objectForKey:@"Category"]];
        //        [back addSubview:arrow];
        
    }

    NSNumber *distance = [[AroundArray objectAtIndex:row] objectForKey:@"Distance"];
    float intDist = [distance floatValue];
    
    UILabel *dist = (UILabel *)[cell viewWithTag:distanceTag];
    if(intDist > 1000)
        dist.text = [NSString stringWithFormat:@"%.2f km", intDist / 1000.];
    else
        dist.text = [NSString stringWithFormat:@"%.0f m", intDist];
    
    
    UIButtonWithAditionalNum * check = (UIButtonWithAditionalNum *)[cell viewWithTag:checkTag];
    check.tagForCheck = [indexPath row];
    
    UILabel * buttonlabel = (UILabel *)[cell viewWithTag:buttonlabel1Tag];
    buttonlabel.backgroundColor =[InterfaceFunctions colorTextCategory:category];
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[AroundArray objectAtIndex:row] objectForKey:@"Name"];
    
    UILabel *previewText = (UILabel *)[cell viewWithTag:announceTag];
    
#warning СДЕЛАТЬ ТАК ЖЕ В PlacesByCategory !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!, OK BOSS
    NSString *preview = [[AroundArray objectAtIndex:row] objectForKey:@"Preview"];
    if(!preview)
        previewText.text = AMLocalizedString(@"Please, update catalogues to get access to newest features.", nil);
                            //Добавить в локализации
    else
        previewText.text = preview;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    previewText.numberOfLines = 0;
    [previewText sizeToFit];
    
    
    UILabel *label = (UILabel *)[cell viewWithTag:labelColorTag];
    label.backgroundColor = [InterfaceFunctions colorTextCategory:category];
    
    Place1 = [AroundArray objectAtIndex:row];
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
    if(PREV_SECTION_AROUNDME > row)
        REVERSE_ANIM = true;
    else
        REVERSE_ANIM = false;
    
    PREV_SECTION_AROUNDME = row;
    //UIView *myView = [[cell subviews] objectAtIndex:0];
    UIView *myView = (UIView *)[cell viewWithTag:cellColorTag];
    CALayer *layer = myView.layer;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/6, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/6, 1, 0, 0);
    }
    
    layer.transform = rotationAndPerspectiveTransform;
    
    
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.75];
    //[cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/6, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/6, 1, 0, 0);
    }
    layer.transform = rotationAndPerspectiveTransform;
    [UIView commitAnimations];
    
    return cell;
}

-(void)check:(UIButtonWithAditionalNum *)sender{
    
    NSDictionary *temp = [AroundArray objectAtIndex:sender.tagForCheck];
    NSLog(@"TagforCheck = %d",sender.tagForCheck);
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"Name"] forKey:@"PlaceTemp"];
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"Category"] forKey:@"CategoryTemp"];
    [[NSUserDefaults standardUserDefaults] setObject:[temp objectForKey:@"City"] forKey:@"CityTemp"];
    
    NSLog(@"Check: %@ %@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"],[[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"],[[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"]);
    
    if ([ExternalFunctions isCheckUsedInPlace:[temp objectForKey:@"Name"] InCategory:[temp objectForKey:@"Category"] InCity:self.CityNameText]){
        NSLog(@"Уже использован");
    }
    else{
        NSLog(@"Еще не использован");
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"]) {
            [self presentSemiViewController:VC withOptions:@{
             KNSemiModalOptionKeys.pushParentBack    : @(YES),
             KNSemiModalOptionKeys.animationDuration : @(0.5),
             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
             }];
            
            
            VC.view.backgroundColor = [UIColor clearColor];
            VC.PlaceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceTemp"];
            VC.PlaceCategory = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryTemp"];
            VC.PlaceCity =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CityTemp"];
            VC.color = [InterfaceFunctions colorTextCategory:@"Category"];
        }
        else{
            [self showRegistrationMessage:self];
            
        }
    }
}
-(IBAction)showRegistrationMessage:(id)sender{
    
    UIAlertView  *message = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Registration", nil)
                                                       message:AMLocalizedString(@"To use all the features of the world LikeLik, please register", nil)
                                                      delegate:nil
                                             cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
                                             otherButtonTitles:AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil), nil];
    message.delegate = self;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
        [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
    if (buttonIndex == 2)
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    
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
        destinaton.readyArray = self.readyArray;
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
    
    if ([[segue identifier] isEqualToString:@"RegisterSegue"]) {
        
        RegistrationViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.Parent = @"Place";
    }
    
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        
        LoginViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.Parent = @"Place";
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
        self.CityImage.frame = CGRectMake(0, -280.0, 320.0, 568.0 - yOffset);
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,5-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.gradient_under_cityname.frame = CGRectMake(self.gradient_under_cityname.frame.origin.x,-yOffset,self.gradient_under_cityname.frame.size.width,self.gradient_under_cityname.frame.size.height);
        
    } else {
        // NSLog(@"3");
        self.CityImage.frame = CGRectMake(0, -280.0, 320.0, self.CityImage.frame.size.height);
        
        
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

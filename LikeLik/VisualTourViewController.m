//
//  VisualTourViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "VisualTourViewController.h"

#import "AppDelegate.h"
#import <MapBox/MapBox.h>
#import "LocalizationSystem.h"
#import "SubText.h"
#import "MapViewAnnotation.h"
CGFloat X=0;
CGFloat Y=0;
NSArray *photos;
static BOOL infoViewIsOpen = NO;
@interface VisualTourViewController ()

@end

@implementation VisualTourViewController
@synthesize Red_line;
@synthesize label;
@synthesize Annotation;
-(IBAction)clickPageControl:(RMAnnotation *)sender
{
    
    int page=self.pageControl.currentPage;
    CGRect frame=_scroll.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [_scroll scrollRectToVisible:frame animated:YES];
  //  NSLog(@"%d",page);
    
}


-(IBAction)MapPageControl:(RMAnnotation *)sender
{
    
    int page=[sender.subtitle intValue];
    CGRect frame=_scroll.frame;
    frame.origin.x=self.scroll.frame.size.width*page;
    frame.size.width =320.;
    frame.origin.y=0;
    self.pageControl.currentPage=page;
    [_scroll scrollRectToVisible:frame animated:YES];
    if (infoViewIsOpen == YES) {
        [self tapDetected:nil];
    }
    
    
    Red_line.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"Name"];
    label.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"About"];
    
}

-(IBAction)MKMapPageControl:(NSInteger)i
{
  //  NSLog(@"Hello!");
    
    int page=i;
    //NSLog(@"page = %d",page);
    CGRect frame=_scroll.frame;
    frame.origin.x=self.scroll.frame.size.width*page;
    frame.size.width =320.;
    frame.origin.y=0;
    self.pageControl.currentPage=page;
    [_scroll scrollRectToVisible:frame animated:YES];
    if (infoViewIsOpen == YES) {
        [self tapDetected:nil];
    }
    
    
    //#warning Смена описаний
    Red_line.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"Name"];
    label.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"About"];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage=page;
  //  NSLog(@"Page = %d",self.pageControl.currentPage);
    Red_line.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"Name"];
    label.text = [[photos objectAtIndex:self.pageControl.currentPage] objectForKey:@"About"];
    [self.MapPhoto deselectAnnotation:self.MapPhoto.selectedAnnotation animated:NO];
    [self.MapPhoto selectAnnotation:[self.Annotation objectAtIndex:page] animated:NO];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)move:(id)sender {
    [self.PhotoCard bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.PhotoCard];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        X = [[sender view] center].x;
        Y = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(X, Y+translatedPoint.y);
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.PhotoCard].y);
        
        if (velocityY>0 && infoViewIsOpen == YES) {
            // NSLog(@"Вниз");
            
            [UIView animateWithDuration:0.6 animations:^{
                if ([AppDelegate isiPhone5]){
                    [self.PhotoCard setFrame:CGRectMake(0.0, 506.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                    
                    
                }
                else{
                    [self.PhotoCard setFrame:CGRectMake(0.0, 417.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                    
                }
            }];
            
            infoViewIsOpen = NO;
            //            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            
        }
        
        if (velocityY<0 && infoViewIsOpen == NO) {
            [UIView animateWithDuration:0.6 animations:^{
                CGRect Frame = self.PhotoCard.frame;
                Frame.origin.y = 15.0;
                if ([AppDelegate isiPhone5]) {
                    
                    [self.PhotoCard setFrame:CGRectMake(0.0, 209.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                    
                }
                else{
                    [self.PhotoCard setFrame:CGRectMake(0.0, 170.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                }
            }];
            
            infoViewIsOpen = YES;
            //            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, 20.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            //            self.navigationController.navigationBar.hidden = NO;
            
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _scroll.delegate=self;
        photos = [ExternalFunctions getVisualTourImagesFromCity:self.CityName];
//    NSLog(@"photos count = %d",[photos count]);
    CGFloat xOrigin = 0 * self.view.frame.size.width;
    UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/1 green:0.5 blue:0.5 alpha:1];
    awesomeView.image = [UIImage imageWithContentsOfFile:[[photos objectAtIndex:0] objectForKey:@"Picture"]];
    if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:0] objectForKey:@"Picture"]]].size.height == 640.0) {
        awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:0] objectForKey:@"Picture"]]].size.height/4);
    }
    [_scroll addSubview:awesomeView];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    self.navigationItem.titleView =[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Visual Tour", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
 
    
        NSArray *coord = [ExternalFunctions getVisualTourImagesFromCity:self.CityName];
     
    Red_line = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 10.0, 250.0, 50.0)];
    Red_line.text =  [[coord objectAtIndex:0] objectForKey:@"Name"];
    Red_line.font =[AppDelegate OpenSansSemiBold:28];
    Red_line.textColor = [UIColor whiteColor];
    Red_line.numberOfLines = 10;
    Red_line.backgroundColor =  [UIColor clearColor];
    Red_line.numberOfLines = 0;
    
    [Red_line sizeToFit];
    CGSize size1 =Red_line.frame.size;
    size1.width=292.0;
    Red_line.frame = CGRectMake(Red_line.frame.origin.x, Red_line.frame.origin.y, size1.width, size1.height);
    [Red_line sizeThatFits:size1];
    
    label = [[SubText alloc] initWithFrame:CGRectMake(14.0, Red_line.frame.origin.y+Red_line.frame.size.height, 292.0, 50.0)];
    label.text =  [[coord objectAtIndex:0] objectForKey:@"About"];
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor whiteColor];
    
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5])
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, 260.0);//textViewSize.height+35);
    else
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, 225.0);//textViewSize.height+35);
    
    
    [label setScrollEnabled:YES];
    
    [_infoScroll setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:204/255.0 blue:191/255.0 alpha:1]];
    
    [_infoScroll addSubview:Red_line];
    
    [_infoScroll addSubview:label];
    
    //    CGSize size = _infoScroll.frame.size;
    //    size.height = self.Red_line.frame.size.height+self.label.frame.size.height;//+20;//earth.frame.size.height+earth.frame.origin.y + 32.0;
    //    _infoScroll.contentSize = size;
    
    [self.locationButton setHidden:YES];
    [self.MapPhoto addSubview:self.locationButton];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    
#if LIKELIK
    self.MKMap.hidden = YES;
    NSURL *url;
    if ([self.CityName isEqualToString:@"Moscow"] || [self.CityName isEqualToString:@"Москва"] || [self.CityName isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.CityName isEqualToString:@"Vienna"] || [self.CityName isEqualToString:@"Вена"] || [self.CityName isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.MapPhoto = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.MapPhoto.delegate = self;
    self.MapPhoto.hideAttribution = YES;
    self.MapPhoto.showsUserLocation = YES;
    self.MapPhoto.hidden = YES;
    if ([AppDelegate isiPhone5])
        self.MapPhoto.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    else
        self.MapPhoto.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    
    
    
    self.MapPhoto.minZoom = 13;
    self.MapPhoto.zoom = 13;
    
    
    CLLocation *coord2 =[ExternalFunctions getCenterCoordinatesOfCity:self.CityName];
    self.MapPhoto.centerCoordinate = coord2.coordinate;
    [self.MapPhoto setAdjustTilesForRetinaDisplay:YES];
    self.MapPhoto.showsUserLocation = YES;
    
    
    CLLocation *tmp = [[coord objectAtIndex:0] objectForKey:@"Location"];
    CLLocationCoordinate2D coord1 = tmp.coordinate;
    // Annotations
    self.Annotation = [[NSMutableArray alloc] initWithCapacity:[coord count]];
    NSString *Title;
    NSInteger numberofpins = [coord count];
    for (int i = 0; i<numberofpins; i++) {
        tmp = [[coord objectAtIndex:i] objectForKey:@"Location"];
        coord1 = tmp.coordinate;
        //#warning Сюда название достопремичательности на карту (Аналогично Red_title)
        Title = [[coord objectAtIndex:i] objectForKey:@"Name"];
        RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPhoto coordinate:coord1 andTitle:Title];
        marker1.annotationType = @"marker";
        marker1.subtitle = [NSString stringWithFormat:@"%d",i];
        marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
        [self.MapPhoto addAnnotation:marker1];
        [self.Annotation addObject:marker1];
    }
    [self.MapPhoto selectAnnotation:[self.Annotation objectAtIndex:0] animated:YES];
    [self.visualMap setHidden:YES];
    [self.view addSubview:self.MapPhoto];
#else
    self.MKMap.hidden = YES;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    
    CLLocationCoordinate2D location = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
    region.span=span;
    region.center=location;
    
    [self.MKMap setRegion:region animated:TRUE];
    [self.MKMap regionThatFits:region];
    
    for (int i=0; i<[coord count]; i++) {
        NSLog(@"%d",[coord count]);
        CLLocation *tmp = [[coord objectAtIndex:i] objectForKey:@"Location"];
        
        MapViewAnnotation *Annotation1 = [[MapViewAnnotation alloc] initWithTitle:[[coord objectAtIndex:i] objectForKey:@"Name"] andCoordinate:tmp.coordinate andUserinfo:[coord objectAtIndex:i] andSubtitle:[NSString stringWithFormat:@"%d",i] AndTag:[[NSString alloc] initWithFormat:@"%d",i]];
        [self.MKMap addAnnotation:Annotation1];
        [self.Annotation addObject:Annotation1];
        
    }
#endif
    
}
#if LIKELIK


-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        
        RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
        [marker replaceUIImage:[InterfaceFunctions MapPinVisualTour].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 30.0)];
        UIImage *image = [UIImage imageWithContentsOfFile:[[[ExternalFunctions getVisualTourImagesFromCity:self.CityName] objectAtIndex:[annotation.subtitle intValue]] objectForKey:@"Picture"]];
        
        [imageview setImage:image];
        marker.leftCalloutAccessoryView = imageview;
        //showLabel];
        
        return marker;
        
    }
    return nil;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    [self ShowMap:self];
    [map deselectAnnotation:annotation animated:YES];
    [self MapPageControl:annotation];
    
}

#else
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapViewAnnotation *)annotation {
    static NSString *identifier = @"MyLocation";
    //NSLog(@"%@",identifier);
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [InterfaceFunctions MapPinVisualTour].image;
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = [annotation.tag intValue];
        [rightButton addTarget:self action:@selector(map_tu:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 30.0)];
        UIImage *image = [UIImage imageWithContentsOfFile:[[[ExternalFunctions getVisualTourImagesFromCity:self.CityName] objectAtIndex:[annotation.subtitle intValue]] objectForKey:@"Picture"]];
        imageview.image = image;
        [annotationView setLeftCalloutAccessoryView:imageview];
        
        return annotationView;
    }
    
    return nil;
}

-(void)map_tu:(UIButton *)sender{
    
    [self ShowMap:self];
    NSLog(@"sender.tag = %d",sender.tag);
    [self MKMapPageControl:sender.tag];
    
}
#endif

-(IBAction)showLocation:(id)sender{
#if LIKELIK
    [self.MapPhoto setCenterCoordinate:self.MapPhoto.userLocation.coordinate];
#else
    [self.MKMap setCenterCoordinate:self.MKMap.userLocation.coordinate animated:YES];
#endif
}







-(void)viewDidAppear:(BOOL)animated{
    
    [TestFlight passCheckpoint:@"VisualTour"];
   
    
#if LIKELIK
    if ([[[CLLocation alloc] initWithLatitude:self.MapPhoto.userLocation.coordinate.latitude longitude:self.MapPhoto.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName]] > 50000.0) {
        self.MapPhoto.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
        self.locationButton.enabled = NO;
        // NSLog(@"Взяли центер города");
    }
    else{
        self.MapPhoto.centerCoordinate = self.MapPhoto.userLocation.coordinate;
        //  NSLog(@"Взяли локацию пользователя");
        self.locationButton.enabled = YES;
    }
#warning выпало после закачки сразу
#else
#warning Фон под навбаром
#warning  обновлять пин на карте при пролистывании
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    // define starting point for map
    CLLocationCoordinate2D start;
    if ([[[CLLocation alloc] initWithLatitude:self.MKMap.userLocation.coordinate.latitude longitude:self.MKMap.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName]] > 50000.0){
        start = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
        self.locationButton.enabled = NO;
    }
    else{
        start = self.MKMap.userLocation.coordinate;
        self.locationButton.enabled = YES;
    }
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    [self.MKMap setRegion:region animated:YES];
#endif
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [[self view] addGestureRecognizer:panRecognizer];
    
    

    
    for (UIView * view in self.view.subviews) {
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        recognizer.delegate = self;
        if ([view isEqual:self.locationButton] == NO) {
            [view addGestureRecognizer:recognizer];
        }
        
    }
    
    
   
    
   // photos = [ExternalFunctions getVisualTourImagesFromCity:self.CityName];
    
    
    self.pageControl.numberOfPages=[photos count];
    self.pageControl.currentPage=0;
    
    
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor clearColor];
    NSInteger numberOfViews = [photos count];
    for (int i = 1; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height+44)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageWithContentsOfFile:[[photos objectAtIndex:i] objectForKey:@"Picture"]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:i] objectForKey:@"Picture"]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:i] objectForKey:@"Picture"]]].size.height/4);
        }
        
        [_scroll addSubview:awesomeView];
    }
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, 400.0);
    //#warning visual tour подготовить материалы
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha andPict:(UIImage *)pic{
    UIGraphicsBeginImageContextWithOptions(pic.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, pic.size.width, pic.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, pic.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(IBAction)ShowMap:(id)sender{
#if LIKELIK
    self.MapPhoto.hidden = !self.MapPhoto.hidden;
#else
    self.MKMap.hidden = !self.MKMap.hidden;
#endif
    self.locationButton.hidden =!self.locationButton.hidden;
    if (self.MapPhoto.hidden){
        UIButton *btn = [InterfaceFunctions map_button:1];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];

    }
    else{
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (IBAction)tapDetected:(UIGestureRecognizer *)sender {
    
    //    NSLog(@"333");
    if (infoViewIsOpen == NO) {
        [UIView animateWithDuration:0.6 animations:^{
            CGRect Frame = self.PhotoCard.frame;
            Frame.origin.y = 15.0;
            if ([AppDelegate isiPhone5]) {
                
                [self.PhotoCard setFrame:CGRectMake(0.0, 209.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                
            }
            else{
                [self.PhotoCard setFrame:CGRectMake(0.0, 170.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
            }
        }];
        infoViewIsOpen = YES;
    }
    else{
        [UIView animateWithDuration:0.6 animations:^{
            if ([AppDelegate isiPhone5]){
                [self.PhotoCard setFrame:CGRectMake(0.0, 506.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                
                
            }
            else{
                [self.PhotoCard setFrame:CGRectMake(0.0, 417.0, self.PhotoCard.frame.size.width, self.PhotoCard.frame.size.height)];
                
            }
        }];
        
        infoViewIsOpen = NO;
    }
}

- (void)viewDidUnload {
    [self setPlaceonMap:nil];
    [super viewDidUnload];
}
@end

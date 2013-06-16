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

#import "SubText.h"
CGFloat X=0;
CGFloat Y=0;
NSArray *photos;
static BOOL infoViewIsOpen = NO;
@interface VisualTourViewController ()

@end

@implementation VisualTourViewController
@synthesize Red_line;
@synthesize label;
-(IBAction)clickPageControl:(RMAnnotation *)sender
{
    
    int page=self.pageControl.currentPage;
    CGRect frame=_scroll.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [_scroll scrollRectToVisible:frame animated:YES];
   // NSLog(@"%d",page);
    
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
#warning Смена описаний
    Red_line.text = [NSString stringWithFormat:@"Название %d",self.pageControl.currentPage];
    label.text = [NSString stringWithFormat:@"Описание %d",self.pageControl.currentPage];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage=page;
    NSLog(@"Page = %d",self.pageControl.currentPage);
#warning Смена описаний
    Red_line.text = [NSString stringWithFormat:@"Название %d",self.pageControl.currentPage];
    label.text = [NSString stringWithFormat:@"Описание %d",self.pageControl.currentPage];
//    NSLog(@"123");
    
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
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [[self view] addGestureRecognizer:panRecognizer];
    
    
    [super viewDidLoad];
    _scroll.delegate=self;
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    self.navigationItem.titleView =[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Visual Tour", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    
    
    for (UIView * view in self.view.subviews) {
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        recognizer.delegate = self;
        if ([view isEqual:self.locationButton] == NO) {
            [view addGestureRecognizer:recognizer];
        }
        
    }
    
    
#warning Андрей, сделай плз функцию и еще мне нужно знать, какие minZoom и MaxZoom выставлять
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
    
    
    NSArray *coord = [ExternalFunctions getVisualTourImagesFromCity:self.CityName];
    CLLocation *tmp = [[coord objectAtIndex:0] objectForKey:@"Location"];
    CLLocationCoordinate2D coord1 = tmp.coordinate;
    // Annotations
    
    NSString *Title;
    NSInteger numberofpins = [coord count];
    for (int i = 0; i<numberofpins; i++) {
        tmp = [[coord objectAtIndex:i] objectForKey:@"Location"];
        coord1 = tmp.coordinate;
#warning Сюда название достопремичательности на карту (Аналогично Red_title)
        Title = @"Название места";
        RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPhoto coordinate:coord1 andTitle:Title];
        marker1.annotationType = @"marker";
        marker1.subtitle = [NSString stringWithFormat:@"%d",i];
        marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
        [self.MapPhoto addAnnotation:marker1];
    }
    
    
    [self.visualMap setHidden:YES];
    [self.view addSubview:self.MapPhoto];
    
    photos = [ExternalFunctions getVisualTourImagesFromCity:self.CityName];
    
    
    self.pageControl.numberOfPages=[photos count];
    self.pageControl.currentPage=0;
    
    
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor blackColor];
    NSInteger numberOfViews = [photos count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageWithContentsOfFile:[[photos objectAtIndex:i] objectForKey:@"Picture"]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:i] objectForKey:@"Picture"]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[photos objectAtIndex:i] objectForKey:@"Picture"]]].size.height/4);
        }
        
        [_scroll addSubview:awesomeView];
    }
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, 400.0);
    //#warning visual tour подготовить материалы
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    Red_line = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 10.0, 250.0, 50.0)];
#warning название достопремичательности первой
    Red_line.text =  @"Visual Tour";
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
#warning текст достопремичательности первой
    label.text = @"123213213";
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor whiteColor];
    
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    
    
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+35);
    }
    else{
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+50);
    }
    [label setScrollEnabled:NO];
    
    [_infoScroll setBackgroundColor:[InterfaceFunctions corporateIdentity]];
    
    [_infoScroll addSubview:Red_line];
    
    [_infoScroll addSubview:label];
    [self.locationButton setHidden:YES];
    [self.MapPhoto addSubview:self.locationButton];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)showLocation:(id)sender{
    
    // NSLog(@"asd");
    [self.MapPhoto setCenterCoordinate:self.MapPhoto.userLocation.coordinate];
}





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


-(void)viewDidAppear:(BOOL)animated{
    
    
    if ([[[CLLocation alloc] initWithLatitude:self.MapPhoto.userLocation.coordinate.latitude longitude:self.MapPhoto.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.CityName]] > 50000.0) {
        self.MapPhoto.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.CityName].coordinate;
        self.locationButton.enabled = NO;
        NSLog(@"Взяли центер города");
    }
    else{
        self.MapPhoto.centerCoordinate = self.MapPhoto.userLocation.coordinate;
        NSLog(@"Взяли локацию пользователя");
        self.locationButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(IBAction)ShowMap:(id)sender{
    self.MapPhoto.hidden = !self.MapPhoto.hidden;
    self.locationButton.hidden =!self.locationButton.hidden;
    if (self.MapPhoto.hidden){
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

//
//  ViewController.m
//  PageView
//
//  Created by Vladimir Malov on 05.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "PlaceViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "AppDelegate.h"
#import <MapBox/MapBox.h>
#import "CheckViewController.h"
#import "MBProgressHUD.h"
#import "RegistrationViewController.h"
#import "MapViewAnnotation.h"
#define MAX_HEIGHT 2000
#define afternotification             @"l27h7RU2dzVfPoQssda"
#define backgroundg @"l27h7RU2123123132dzVfPoQssda"
#define checkOpen                 @"l27h7RU2dzVfP12aoQssdasasa"
static BOOL PlaceCardOpen = YES;
static UIAlertView *alertView = nil;
static NSString * currentCity = @"";

CGFloat firstX=0;
CGFloat firstY=0;
CGFloat alpha = 0.5;


CGRect PlaceCardFrame;

static NSString *LorR = nil;



@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize Use,pageControl;

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
    if (PlaceCardOpen == YES)
        [self PlaceCardMove:self];
    
    
}

-(IBAction)PlaceCardMove:(id)sender {
#warning учитывать направление свайпа
    if (PlaceCardOpen == YES) {
        [UIView transitionWithView:self.PlaceCard
                          duration:0.4
                           options:UIViewAnimationOptionCurveLinear
                        animations:^
         {
                 [self.PlaceCard setFrame:CGRectMake(0.0, self.view.frame.size.height, self.PlaceCard.frame.size.width, self.PlaceCard.frame.size.height)];
         }
                        completion:NULL];
        PlaceCardOpen = NO;
    }
    else{
        [UIView transitionWithView:self.PlaceCard
                          duration:0.4
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [self.PlaceCard setFrame:PlaceCardFrame];
                        }
                        completion:NULL];
        PlaceCardOpen = YES;
    }
    
}


-(IBAction)ShowMap:(id)sender{
    //[self hide_hint:self];
#if LIKELIK
    self.MapPlace.hidden = !self.MapPlace.hidden;
    if (self.MapPlace.hidden){
        UIButton *btn = [InterfaceFunctions map_button:1];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    else{
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    
#else
    self.mapView.hidden = !self.mapView.hidden;
    if (self.mapView.hidden){
        [self.locationButton setHidden:YES];
        UIButton *btn = [InterfaceFunctions map_button:1];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        
    }
    else{
        [self.locationButton setHidden:NO];
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
#endif
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@" %@ %@ %@",currentCity,self.PlaceCategory,self.PlaceNameEn ]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
#if LIKELIK
    if ([[[CLLocation alloc] initWithLatitude:self.MapPlace.userLocation.coordinate.latitude longitude:self.MapPlace.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName]] > 50000.0) {
        self.MapPlace.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName].coordinate;
    }
    else{
        self.MapPlace.centerCoordinate = self.MapPlace.userLocation.coordinate;
    }
#else
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    CLLocationCoordinate2D start;
    if ([[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName]] > 50000.0){
        start = [ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName].coordinate;
        self.locationButton.enabled = NO;
    }
    else{
        start = self.mapView.userLocation.coordinate;
        self.locationButton.enabled = YES;
    }
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    [self.mapView setRegion:region animated:YES];
#endif
}

#if  LIKELIK
-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
        
        
        [marker replaceUIImage:[InterfaceFunctions MapPin:AMLocalizedString(self.PlaceCategory, nil)].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return marker;
    }
    return nil;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    [self ShowMap:map];
}

#else
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapViewAnnotation *)annotation {
    
    static NSString *identifier = @"MyLocation";
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
        annotationView.image = [InterfaceFunctions MapPin:AMLocalizedString(annotation.subtitle, NULL)].image;
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = [annotation.tag intValue];
        [rightButton addTarget:self action:@selector(map_tu:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        leftButton.tag = [annotation.tag intValue];
        [leftButton addTarget:self action:@selector(showAppleMap:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setLeftCalloutAccessoryView:leftButton];
        
        return annotationView;
    }
    
    return nil;
}

-(void)showAppleMap:(UIButton *)sender{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.PlaceLocation.coordinate.latitude,self.PlaceLocation.coordinate.longitude);
    
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
}

-(void)map_tu:(UIButton *)sender{
    self.mapView.hidden= !self.mapView.hidden;
    self.locationButton.hidden =! self.locationButton.hidden;
}
#endif

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        RegistrationViewController *destination = [segue destinationViewController];
        destination.LorR = LorR;
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
#warning кнопки сделать шире
    self.PlaceCardScroll.translatesAutoresizingMaskIntoConstraints= NO;
    PlaceCardFrame = self.PlaceCard.frame;
    
    if ([AMLocalizedString(@"Moscow", nil) isEqualToString:self.PlaceCityName]) {
        currentCity = @"Moscow";
    }
    else{
        currentCity = @"Vienna";
    }
    
    [self.info_button setImage:[InterfaceFunctions Info_buttonwithCategory:self.PlaceCategory].image forState:UIControlStateNormal];
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    
//    self.hint.userInteractionEnabled = YES;
//    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide_hint:)];
//    recognizer.delegate = self;
//    
//    [self.hint addGestureRecognizer:recognizer];
//    NSString *tmp = [[NSString alloc] init];
//    NSString *Lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"Language"];
//    if ([Lang isEqualToString:@"Русский"])
//        tmp = @"ru";
//    if ([Lang isEqualToString:@"Deutsch"])
//        tmp = @"de";
//    if ([Lang isEqualToString:@"English"])
//        tmp = @"en";
//    if ([Lang isEqualToString:@"Japanese"]) {
//        tmp = @"jp";
//    }
//    if (![[[NSUserDefaults standardUserDefaults ] objectForKey:@"hint"] isEqualToString:@"YES"]) {
//        [AppDelegate LLLog:[NSString stringWithFormat:@"%@",LocalizationGetLanguage]];
//        if ([AppDelegate isiPhone5]) {
//            [self.hint setImage:[UIImage imageNamed:[NSString stringWithFormat:@"5-%@.png",tmp]]];
//        }
//        else{
//            [self.hint setImage:[UIImage imageNamed:[NSString stringWithFormat:@"4-%@.png",tmp]]];
//        }
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hint"];
//    }
//    else{
//        self.hint.hidden = YES;
//    }
//
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(semiModalDismissed:)
//                                                 name:kSemiModalDidHideNotification
//                                               object:nil];
//    

    VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
 
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = [UIColor blackColor];
    NSInteger numberOfViews = [self.Photos count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageWithContentsOfFile:[self.Photos objectAtIndex:i]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[self.Photos objectAtIndex:i]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[self.Photos objectAtIndex:i]]].size.height/4);
        }
        [_scroll addSubview:awesomeView];
    }
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, 400.0);
    //_infoScroll.showsHorizontalScrollIndicator = NO;

    
    _scroll.delegate=self;
    pageControl.numberOfPages=[self.Photos count];
    pageControl.currentPage=0;

//
//    
//    _Separator.image = [UIImage imageNamed:@"separator_line.png"];
//    _Separator1.image = [UIImage imageNamed:@"separator_line.png"];
//    _Separator3.image = [UIImage imageNamed:@"separator_line.png"];
//    _WebPinimage.image = [UIImage imageNamed:@"ico_point.png"];
//    _TelPinimage.image = [UIImage imageNamed:@"ico_tel.png"];
//    _PlacePinimage.image = [UIImage imageNamed:@"ico_earth.png"];
//    
//    
//	_TextPlace.backgroundColor =  [UIColor clearColor];
//	_TextPlace.font = [AppDelegate OpenSansRegular:28];
//	_TextPlace.textColor = [UIColor whiteColor];
//    _TextPlace.scrollEnabled = YES;
//    _TextPlace.editable = NO;
//    _infoScroll.contentSize = CGSizeMake(320.0, 512.0);
//    
//
    
    //tabitems
    [self.Favourite setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_normal"].image forState:UIControlStateNormal];
    [self.Favourite setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_selected"].image forState:UIControlStateHighlighted];
    [self.Use setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_normal"].image forState:UIControlStateNormal];
    [self.Use setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_selected"].image forState:UIControlStateHighlighted];
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_normal"].image forState:UIControlStateNormal];
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_selected"].image forState:UIControlStateHighlighted];
    
    [self.Favourite addSubview:[InterfaceFunctions favouritestarPlaceView]];
    [self.Use addSubview:[InterfaceFunctions UsePlaceViewInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]];
    [self.Share addSubview:[InterfaceFunctions SharePlaceView]];
    
    if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName])
            self.Use.enabled = NO;
    if ([ExternalFunctions isFavorite:self.PlaceName InCity:self.PlaceCityName InCategory:self.PlaceCategory])
        self.Favourite.enabled = NO;
    

    [InterfaceFunctions UseLabelPlaceView:self.Use];
    [InterfaceFunctions ShareLabelPlaceView:self.Share];
    [InterfaceFunctions FavouriteLabelPlaceView:self.Favourite];
    
    //---//
    [self.PlaceCardScroll setBackgroundColor:self.Color];
    
    
    
    
    self.Red_Line.text = self.PlaceName;
    self.Red_Line.text = self.PlaceName;
    self.Red_Line.font =[AppDelegate OpenSansSemiBold:28];
    self.Red_Line.textColor = [UIColor whiteColor];
    self.Red_Line.numberOfLines = 10;
    self.Red_Line.backgroundColor =  [UIColor clearColor];
    self.Red_Line.numberOfLines = 0;
    [ self.Red_Line sizeToFit];
    CGSize size1 = self.Red_Line.frame.size;
    size1.width=292.0;
    [ self.Red_Line sizeThatFits:size1];

    
    
    
    self.PlaceText.text = self.PlaceAbout;
    self.PlaceText.font = [AppDelegate OpenSansRegular:28];
    self.PlaceText.textColor = [UIColor whiteColor];

    self.PlaceText.backgroundColor =  [UIColor clearColor];
    self.PlaceText.editable = NO;
CGSize textViewSize = [self.PlaceText.text sizeWithFont:self.PlaceText.font constrainedToSize:CGSizeMake(self.PlaceText.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    self.PlaceText.frame = CGRectMake(14.0, self.PlaceText.frame.origin.y, 292.0, textViewSize.height+70.0);
    [self.PlaceText sizeToFit];
    //[self.PlaceText setScrollEnabled:NO];
    
    
    [self.Address setTitle:self.PlaceAddress forState:UIControlStateNormal];
    [self.Address.titleLabel setFont:[AppDelegate OpenSansRegular:28]];
    
    
    [self.http setTitle: self.PlaceWeb forState:UIControlStateNormal];
    [self.http.titleLabel setFont:[AppDelegate OpenSansRegular:28]];
    
    [self.Telephone setTitle:self.PlaceTelephone forState:UIControlStateNormal];
    [self.Telephone.titleLabel setFont:[AppDelegate OpenSansRegular:28]];
#if LIKELIK
    NSURL *url;
    self.mapView.hidden = YES;
    if ([self.PlaceCityName isEqualToString:@"Moscow"] || [self.PlaceCityName isEqualToString:@"Москва"] || [self.PlaceCityName isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.PlaceCityName isEqualToString:@"Vienna"] || [self.PlaceCityName isEqualToString:@"Вена"] || [self.PlaceCityName isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.MapPlace.showsUserLocation = YES;
    self.MapPlace.tileSource = offlineSource;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    self.MapPlace.minZoom = 13;
    self.MapPlace.zoom = 13;
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    self.MapPlace.showsUserLocation = YES;
    [self.MapPlace setHidden:YES];
    
    CLLocation *placecoord = self.PlaceLocation;
    self.MapPlace.centerCoordinate =  placecoord.coordinate;
    CLLocationCoordinate2D coord = placecoord.coordinate;
    RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:CLLocationCoordinate2DMake(coord.latitude, coord.longitude) andTitle:@"Pin"];
    marker1.annotationType = @"marker";
    marker1.title = self.PlaceName;
    marker1.subtitle = AMLocalizedString(self.PlaceCategory, nil);
    marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
    [self.MapPlace addAnnotation:marker1];
#else
    self.placeViewMap.hidden = YES;
    self.mapView.hidden = YES;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    
    CLLocationCoordinate2D location = self.PlaceLocation.coordinate;
    region.span=span;
    region.center=location;
    
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
    MapViewAnnotation *Annotation = [[MapViewAnnotation alloc] initWithTitle:self.PlaceName andCoordinate:self.PlaceLocation.coordinate andUserinfo:nil andSubtitle:self.PlaceCategory AndTag:0];
    [self.mapView addAnnotation:Annotation];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:Annotation.title forState:UIControlStateNormal];
    
    
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton setHidden:YES];
#endif
}





//-(void)afterreg{
//  UIButton *tmp = [[UIButton alloc] init];
//    tmp.tag = 1;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
//    {
//        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Done"                                                       action:@"Register" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceName forKey:@"PlaceTemp"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCategory forKey:@"CategoryTemp"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCityName forKey:@"CityTemp"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceNameEn forKey:@"PlaceTempEN"];
//        [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CityTempEN"];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:checkOpen
//                                                            object:self];
//        
//        infoViewIsOpen = !infoViewIsOpen;
//
//        VC.view.backgroundColor = [UIColor clearColor];
//        
//
//
//        VC.color = self.Color;
//        _labelonPhoto.hidden = NO;
//        _background.hidden = NO;
//    }
//}
//
//-(BOOL)launchPhoneWithNumber:(UIButton *)sender {
//
//    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Call" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//    
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Call", nil)
//                                                             delegate:self
//                                                    cancelButtonTitle:AMLocalizedString(@"Close",nil)
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles: sender.titleLabel.text, nil];
//    
//    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    return YES;
//}
//
//-(void)webPressed:(UIButton *)sender{
//    
//     [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Web" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//    NSString *url = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Web", nil)
//                                                             delegate:self
//                                                    cancelButtonTitle :AMLocalizedString(@"Close",nil)
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles: url, nil];
//    
//    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    
//    
//}
//
//
//- (void)semiModalDismissed:(NSNotification *) notification {
//    if (notification.object == self) {
//        if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]){
//            self.GOUSE.enabled = NO;
//            [Use stopAnimating];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableInPlaces" object:nil];
//        }        
//    }
//}
//
//
//-(void) setNewFontToTextViews:(UIView*) theView {
//    if([[theView subviews] count])
//        for( UIView * subView in [theView subviews])
//            [self setNewFontToTextViews:subView] ;
//    else if([theView isKindOfClass:[UITextView class]])
//        [(UITextView*)theView setFont:[AppDelegate OpenSansRegular:28]];
//}
//
//- (void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
//}
//

//-(IBAction)buttonPressed:(UIButton*)sender{
//        if (sender.tag == 2) {
//        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        if ([AppDelegate isiPhone5])
//            [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//        else
//            [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//        infoViewIsOpen = !infoViewIsOpen;
//            
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                  delegate:self
//                                         cancelButtonTitle:AMLocalizedString(@"Close",nil)
//                                    destructiveButtonTitle:nil
//                                                    otherButtonTitles: AMLocalizedString(@"Share on facebook", nil),AMLocalizedString(@"Share on twitter", nil),AMLocalizedString(@"Share on VK", nil),/*AMLocalizedString(@"Share on Jen Jen", nil),*/AMLocalizedString(@"Send Email",nil),nil];
//        
//        [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];//showInView: [[self navigationController] navigationBar]];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        
//        
//    }
//    
//    if (sender.tag == 1) {
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"]) {
//            [UIView animateWithDuration:1.0 animations:^{
//                if ([AppDelegate isiPhone5])
//                    [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//                else
//                    [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//            }];
//            infoViewIsOpen = !infoViewIsOpen;
//            
//            
//            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceName forKey:@"PlaceTemp"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCategory forKey:@"CategoryTemp"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCityName forKey:@"CityTemp"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceNameEn forKey:@"PlaceTempEN"];
//            [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CityTempEN"];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:checkOpen
//                                                                object:self];
//            
//            
//             [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Use Check" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//            
//            
//            
//            [self presentSemiViewController:VC withOptions:@{
//             KNSemiModalOptionKeys.pushParentBack    : @(YES),
//             KNSemiModalOptionKeys.animationDuration : @(0.5),
//             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
//             }];
//            
//            VC.view.backgroundColor = [UIColor clearColor];
////            VC.PlaceName = self.PlaceName;
////            VC.PlaceCategory = self.PlaceCategory;
////            VC.PlaceCity = self.PlaceCityName;
//            VC.color = self.Color;
//            _labelonPhoto.hidden = NO;
//            _background.hidden = NO;
//            
//        }
//        else{
//        [self showRegistrationMessage:self];
//        }
//        
//    }
//    
//    if (sender.tag == 0) {
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is"                                                       action:@"Favorited" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        HUD = [MBProgressHUD showHUDAddedTo:self.PlaceView animated:YES];
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.margin = 10.f;
//        HUD.yOffset = -100.f;
//        HUD.removeFromSuperViewOnHide = YES;
//        
//
//        HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Object added to favourites", nil)];
//        
//        HUD.mode = MBProgressHUDModeCustomView;
//       
//        HUD.delegate = self;
//        [ExternalFunctions addToFavouritesPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName];
//
//        [HUD show:YES];
//        [HUD hide:YES afterDelay:2];
//            self.Favorites.enabled = NO;
//            
//            self.favImage.alpha = alpha;
//            
//            [self.favText removeFromSuperview];
//            self.favText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
//            self.favText.numberOfLines = 0;
//            [self.favText setText:AMLocalizedString(@"Favorited", nil)];
//            self.favText.font = [AppDelegate OpenSansBoldwithSize:18];
//            self.favText.textColor  = [UIColor whiteColor];
//            self.favText.backgroundColor = [UIColor clearColor];
//            [self.favText setCenter:CGPointMake(self.Favorites.center.x, self.Favorites.center.y)];
//            [self.favText sizeToFit];
//            [self.favText setFrame:CGRectMake((107.0-self.favText.frame.size.width)/2, 50-20.0, self.favText.frame.size.width, self.favText.frame.size.height)];
//            [self.Favorites addSubview:self.favText];
//        self.favText.alpha = alpha;
//    }
//}
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Call", nil)]) {
//        if (buttonIndex == 0){
//             [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Call" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//            
//            NSString *tel =[actionSheet buttonTitleAtIndex:0];
//            NSString* launchUrl = [NSString stringWithFormat:@"tel:%@",tel];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
//        }
//    }
//    
//    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Web", nil)]) {
//        if (buttonIndex == 0){
//            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Site" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//            NSURL *address =[[NSURL alloc] initWithString:[actionSheet buttonTitleAtIndex:0]];
//            [[UIApplication sharedApplication] openURL:address];
//            
//        }
//    }
//    
//    
//    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on VK", nil)]) {
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share VK" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        _vkontakte = [Vkontakte sharedInstance];
//        _vkontakte.delegate = self;
//
//        if (![_vkontakte isAuthorized])
//        {
//            [_vkontakte authenticate];
//            
//
//        }
//        else
//        {
//            [_vkontakte postMessageToWall:self.PlaceAbout link:[[NSURL alloc] initWithString:@"http://likelik.com"]];
//           // [AppDelegate LLLog:[NSString stringWithFormat:@"%@",[[NSURL alloc] initWithString:@"http://likelik.com"]);
//        }
//        
//        
//        
//    }
//    
//    
//    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on twitter", nil)]) {
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share Twitter" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        
//    }
//    
//    
//    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AMLocalizedString(@"Share on facebook", nil)]) {
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share FB" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
////        loadingView.hidden = NO;
////        [SCFacebook loginCallBack:^(BOOL success, id result) {
////            loadingView.hidden = YES;
////            if (success) {
////                [SCFacebook feedPostWithLinkPath:@"http://www.likelik.com" caption:self.PlaceAbout callBack:^(BOOL success, id result) {
////                    loadingView.hidden = YES;
////                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
////                    [self.navigationController.view addSubview:HUD];
////                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
////                    
////                    // Set custom view mode
////                    HUD.mode = MBProgressHUDModeCustomView;
////                    
////                    HUD.delegate = self;
////                    HUD.labelText = AMLocalizedString(@"Done", nil);
////                    
////                    [HUD show:YES];
////                    [HUD hide:YES afterDelay:1];
////                }];
////            }
////        }];       
//    }
//    
//    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AMLocalizedString(@"Send Email", nil)]) {
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share e-mail" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        [self openMail:self];
//    }
//}
//

//- (void)viewDidUnload {
//
//    [self setScrollView:nil];
//    [self setTextPlace:nil];
//    [super viewDidUnload];
//}
//
//
//#pragma mark - VkontakteDelegate
//
//- (void)vkontakteDidFailedWithError:(NSError *)error{
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}
//
//- (void)showVkontakteAuthController:(UIViewController *)controller{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        controller.modalPresentationStyle = UIModalPresentationFormSheet;
//    }
//    [self presentViewController:controller animated:YES completion:^{}];
//}
//
//- (void)vkontakteAuthControllerDidCancelled{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self tapDetected:nil];
//    }];
//   
//   // [AppDelegate LLLog:[NSString stringWithFormat:@"123");
//}
//
//- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte{
//     [_vkontakte postMessageToWall:self.PlaceAbout link:[[NSURL alloc] initWithString:@"http://likelik.com"]];
//    [self dismissViewControllerAnimated:YES completion:^{}];//
//}
//
//- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce{
//     [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is"                                                       action:@"Posted on the wall" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.delegate = self;
//    HUD.labelText = AMLocalizedString(@"Done", nil);
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:1];
//    
//}
//
//
//-(IBAction)showRegistrationMessage:(id)sender{
//
//  UIAlertView  *message = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Registration", nil)
//                                     message:AMLocalizedString(@"To use all the features of the world LikeLik, please register", nil)
//                                    delegate:nil
//                           cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
//                           otherButtonTitles:AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil), nil];
//    message.delegate = self;
//    [message show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1){
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Login" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        LorR = @"Registration";
//        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
//    }
//    if (buttonIndex == 2){
//         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Register" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
//        LorR = @"Login";
//        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
//    }
//}
//
//- (IBAction)openMail:(id)sender{
//    if ([MFMailComposeViewController canSendMail]){
//        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
//        mailer.mailComposeDelegate = self;
//        [mailer setSubject:AMLocalizedString(@"Email Subject", nil)];
//        NSString *emailBody = AMLocalizedString(@"Email Text", nil);
//        [mailer setMessageBody:emailBody isHTML:NO];
//        [self presentViewController:mailer animated:YES completion:^{}];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
//                                                        message:@"Your device doesn't support the composer sheet"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
//}
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail cancelled: you cancelled the operation and no email message was queued.");
//            break;
//        case MFMailComposeResultSaved:
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail saved: you saved the email message in the drafts folder.");
//            break;
//        case MFMailComposeResultSent:
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail send: the email message is queued in the outbox. It is ready to send.");
//            break;
//        case MFMailComposeResultFailed:
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail failed: the email message was not saved or queued, possibly due to an error.");
//            break;
//        default:
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail not sent.");
//            break;
//    }
// 
//}


//-(IBAction)hide_hint:(id)sender{
//    self.hint.hidden = YES;
//    self.hide_button.hidden = YES;
//}

- (IBAction)Telephone:(id)sender {
}
- (IBAction)Call:(id)sender {
}
- (IBAction)Surf:(id)sender {
}
- (IBAction)OpenMap:(id)sender {
}
@end

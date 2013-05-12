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
#import "SubText.h"
#import "CheckViewController.h"

#import "SplashViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SCFacebook.h"
#import "MBProgressHUD.h"
#import "RegistrationViewController.h"
#include "LoginViewController.h"
#define kOAuthConsumerKey				@"XGaxa31EoympFhxLZooQ"		//REPLACE ME
#define kOAuthConsumerSecret			@"IbUE5lud22evmrtxjtU1vKvh6VDqRMSHHFJ73rtHI"

#define MAX_HEIGHT 2000
#define afterCall             @"l27h7RU2dzVfPoQQQQ"
#define afternotification             @"l27h7RU2dzVfPoQssda"
#define afterregister             @"l27h7RU2dzVfP12aoQssda"
#define backgroundg @"l27h7RU2123123132dzVfPoQssda"
//static NSInteger prevPhoto;
static BOOL infoViewIsOpen = NO;
//static BOOL MapIsOpen = NO;
static UIAlertView *alertView = nil;
CGFloat firstX=0;
CGFloat firstY=0;
//static UIActivityIndicatorView *activity = nil;

@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize Use,pageControl;
@synthesize message;

-(IBAction)clickPageControl:(id)sender
{
    int page=pageControl.currentPage;
    CGRect frame=_scroll.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [_scroll scrollRectToVisible:frame animated:YES];
    // NSLog(@"Hello");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
    
    if (page == 0) {
        
        [UIView animateWithDuration:0.3 animations:^() {
            _labelonPhoto.alpha = 1.0;
            _background.alpha = 1.0;
        }];
        
    }
    else{
        [UIView animateWithDuration:0.3 animations:^() {
            _labelonPhoto.alpha = 0.0;
            _background.alpha = 0.0;
        }];
        if (infoViewIsOpen == YES) {
            [self tapDetected:nil];
        }
    }
}

-(void)move:(id)sender {
    [self.PlaceView bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.PlaceView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(firstX, firstY+translatedPoint.y);
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {

        
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.PlaceView].y);
        
        if (velocityY>0 && infoViewIsOpen == YES) {
            // NSLog(@"Вниз");
            [UIView transitionWithView:self.PlaceView
                              duration:0.4
                               options:UIViewAnimationOptionCurveLinear
                            animations:^
             {
                 
                 if ([AppDelegate isiPhone5]){
                     [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                     
                 }
                 else{
                     [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                 }
             }
                            completion:NULL];
            
            infoViewIsOpen = NO;
            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            _labelonPhoto.hidden = NO;
            _background.hidden = NO;
        }
        
        if (velocityY<0 && infoViewIsOpen == NO) {
            [UIView transitionWithView:self.PlaceView
                              duration:0.4
                               options:UIViewAnimationOptionCurveLinear
                            animations:^
             {
                 if ([AppDelegate isiPhone5]) {
                     
                     [self.PlaceView setFrame:CGRectMake(0.0, 152.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                 }
                 else{
                     [self.PlaceView setFrame:CGRectMake(0.0, 170.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                 }
             }
                            completion:NULL];
            infoViewIsOpen = YES;
            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, 20.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            self.navigationController.navigationBar.hidden = NO;
            _labelonPhoto.hidden = YES;
            _background.hidden = YES;
        }
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];


    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [[self view] addGestureRecognizer:panRecognizer];
    

    [self.info_button setImage:[InterfaceFunctions Info_buttonwithCategory:self.PlaceCategory].image forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    for (UIView * view in self.view.subviews) {
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        recognizer.delegate = self;
        if ([view isEqual:self.locationButton] == NO || [view isEqual:self.MapPlace] || [view isEqual:self.placeViewMap]) {
            [view addGestureRecognizer:recognizer];
        }
        
    }
    
    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.navigationController.navigationBar.hidden = YES;
   // [self hideStuff];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(aftercall:)
                                                 name: afterCall
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(afternot)
                                                 name: afternotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(afterreg)
                                                 name: afterregister
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(backgroundgo)
                                                 name: backgroundg
                                               object: nil];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
   
    self.PlaceView.backgroundColor =  [UIColor clearColor];
    self.ScrollView.backgroundColor = self.Color;
    _ScrollView.contentSize = CGSizeMake(320.0, 400.0);
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:self.PlaceName AndColor:[InterfaceFunctions mainTextColor:6]];
   // [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    
    
    [self.scroll addGestureRecognizer:singleTap];
    NSArray *photos = [ExternalFunctions getImagesOfPlaceInCity:self.PlaceCityName InCategory:self.PlaceCategory WithPlaceName:self.PlaceName];
    
    
    if ([AppDelegate isiPhone5])
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
    else
        VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController35" bundle:nil];
    self.LabelOnScroll.text = self.PlaceName;
    self.LabelOnScroll.textColor = [UIColor whiteColor];
    self.LabelOnScroll.font = [AppDelegate OpenSansSemiBold:60];
    
    
    
    if ([AppDelegate isiPhone5]) {
        self.labelonPhoto = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 290.0, 0.0)];
        _labelonPhoto.text = self.LabelOnScroll.text;
        _labelonPhoto.textColor = [UIColor whiteColor];
        _labelonPhoto.font = [AppDelegate OpenSansSemiBold:60];
        _labelonPhoto.numberOfLines =0;
        _labelonPhoto.backgroundColor = [UIColor clearColor];
        
        [_labelonPhoto sizeToFit];
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, _labelonPhoto.frame.origin.y, 320.0, _labelonPhoto.frame.size.height)];
        _background.image = [UIImage imageNamed:@"Bg_gradient.png"];
        [self.view addSubview:_background];
        [self.view addSubview:_labelonPhoto];
        
        self.LabelOnScroll.hidden = YES;
    }
    else{
        self.labelonPhoto = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 290.0, 0.0)];
        _labelonPhoto.text = self.LabelOnScroll.text;
        _labelonPhoto.textColor = [UIColor whiteColor];
        _labelonPhoto.font = [AppDelegate OpenSansSemiBold:60];
        _labelonPhoto.numberOfLines =0;
        _labelonPhoto.backgroundColor = [UIColor clearColor];
        
        [_labelonPhoto sizeToFit];
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, _labelonPhoto.frame.origin.y, 320.0, _labelonPhoto.frame.size.height)];
        _background.image = [UIImage imageNamed:@"Bg_gradient.png"];
        [self.view addSubview:_background];
        [self.view addSubview:_labelonPhoto];
        self.LabelOnScroll.hidden = YES;
    }
    
    self.view.backgroundColor =  [UIColor redColor];
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = [UIColor blackColor];
    NSInteger numberOfViews = [photos count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageNamed:[photos objectAtIndex:i]];
        if ([UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height/4);
        }
        [_scroll addSubview:awesomeView];
    }
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, 400.0);
    _infoScroll.showsHorizontalScrollIndicator = NO;
    UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 512.0)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/2 green:0.5 blue:0.5 alpha:1];
    
        
    
    _scroll.delegate=self;
    pageControl.numberOfPages=[photos count];
    pageControl.currentPage=0;

    
    
    _Separator.image = [UIImage imageNamed:@"separator_line.png"];
    _Separator1.image = [UIImage imageNamed:@"separator_line.png"];
    _Separator3.image = [UIImage imageNamed:@"separator_line.png"];
    _WebPinimage.image = [UIImage imageNamed:@"ico_point.png"];
    _TelPinimage.image = [UIImage imageNamed:@"ico_tel.png"];
    _PlacePinimage.image = [UIImage imageNamed:@"ico_earth.png"];
    
    
	_TextPlace.backgroundColor =  [UIColor clearColor];
	_TextPlace.font = [AppDelegate OpenSansRegular:26];
	_TextPlace.textColor = [UIColor whiteColor];
    _TextPlace.scrollEnabled = YES;
    _TextPlace.editable = NO;
    _infoScroll.contentSize = CGSizeMake(320.0, 512.0);
    

//    
    [self.Favorites setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_normal"].image forState:UIControlStateNormal];
    [self.Favorites setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_selected"].image forState:UIControlStateHighlighted];
    
//
//    
    [self.GOUSE setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_normal"].image forState:UIControlStateNormal];
    [self.GOUSE setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_selected"].image forState:UIControlStateHighlighted];
    
//
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_normal"].image forState:UIControlStateNormal];
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_selected"].image forState:UIControlStateHighlighted];
    
    
    UIImageView *fav = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1fav.png"]];
    fav.frame = CGRectMake(45.0, 10.0, fav.frame.size.width, fav.frame.size.height);
    [fav setCenter:CGPointMake(53, fav.center.y)];
    [self.Favorites addSubview:fav];
    
    
    Use = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2use.png"]];
    Use.frame = CGRectMake(45.0, 10.0, Use.frame.size.width, Use.frame.size.height);


    
    NSMutableArray *animation = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 1; i<8; i++) {
        NSString *image = [[NSString alloc] initWithFormat:@"Fist_animated_%d.png",i];
        [animation addObject:[UIImage imageNamed:image]];
    }
    //[Use setCenter:CGPointMake(53, Use.center.y)];
    Use.animationImages = animation;
    Use.animationDuration = 1.0;
    [Use startAnimating];
    if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]){
        self.GOUSE.enabled = NO;
        [Use stopAnimating];
    }
    [self.GOUSE addSubview:Use];
    
    
    
    UIImageView *share = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3share.png"]];
    share.frame = CGRectMake(45.0, 10.0, share.frame.size.width, share.frame.size.height);
    [share setCenter:CGPointMake(54, fav.center.y)];
    [self.Share addSubview:share];
    
    self.favText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    self.favText.numberOfLines = 0;
    [self.favText setText:AMLocalizedString(@"Add to Favourites", nil)];
    self.favText.font = [AppDelegate OpenSansBoldwithSize:18];
    self.favText.textColor  = [UIColor whiteColor];
    self.favText.backgroundColor = [UIColor clearColor];
    [self.favText setCenter:CGPointMake(self.Favorites.center.x, self.Favorites.center.y)];
    [self.favText sizeToFit];
    [self.favText setFrame:CGRectMake((107.0-self.favText.frame.size.width)/2, 50-20.0, self.favText.frame.size.width, self.favText.frame.size.height)];
    [self.Favorites addSubview:self.favText];
    
    if ([ExternalFunctions isFavorite:self.PlaceName InCity:self.PlaceCityName InCategory:self.PlaceCategory]) {
        self.Favorites.enabled = NO;
        [self.favText setText:@""];//:AMLocalizedString(@"Favorited", nil)];
        
  //      self.favText.numberOfLines = 0;
//        [self.favText sizeToFit];
    }
    
    UILabel *UseText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];//[[UITextView //stringWithFormat:AMLocalizedString(@"Favorites", nil)]];
    UseText.numberOfLines = 0;
    [UseText setText:AMLocalizedString(@"Use", nil)];
    UseText.font = [AppDelegate OpenSansBoldwithSize:18];
    UseText.textColor  = [UIColor whiteColor];
    UseText.backgroundColor = [UIColor clearColor];
    [UseText sizeToFit];
    [UseText setFrame:CGRectMake((106.0-UseText.frame.size.width)/2, 50-20.0, UseText.frame.size.width, UseText.frame.size.height)];
    [UseText setCenter:CGPointMake(Use.center.x, UseText.center.y)];
    [self.GOUSE addSubview:UseText];
    
    
    UILabel *ShareText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];//[[UITextView //stringWithFormat:AMLocalizedString(@"Favorites", nil)]];
    ShareText.numberOfLines = 0;
    [ShareText setText:AMLocalizedString(@"Share", nil)];
    ShareText.font = [AppDelegate OpenSansBoldwithSize:18];
    ShareText.textColor  = [UIColor whiteColor];
    ShareText.backgroundColor = [UIColor clearColor];
    [ShareText sizeToFit];
    [ShareText setFrame:CGRectMake((107.0-ShareText.frame.size.width)/2, 50-20.0, ShareText.frame.size.width, ShareText.frame.size.height)];
    [ShareText setCenter:CGPointMake(share.center.x, ShareText.center.y)];
    [self.Share addSubview:ShareText];
    
    
    [self.Share setTitle:@"" forState:UIControlStateNormal];
    
    NSDictionary *dict = [ExternalFunctions placeDictionaryInCity:self.PlaceCityName InCategory:self.PlaceCategory withName:self.PlaceName];
    _TextPlace.text = [dict objectForKey:@"about"];
    _Teltext.text = [dict objectForKey:@"Telephone"];
    _webtext.text = [dict objectForKey:@"web"];
    _Placeadress.text = [dict objectForKey:@"address"];
   
    
    [_ScrollView setBackgroundColor:self.Color];
    
    UILabel *Red_line = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 10.0, 250.0, 50.0)];
    Red_line.text = self.PlaceName;
    Red_line.font =[AppDelegate OpenSansSemiBold:26];
    Red_line.textColor = [UIColor whiteColor];
    Red_line.numberOfLines = 10;
    Red_line.backgroundColor =  [UIColor clearColor];
    Red_line.numberOfLines = 0;
   // Red_line.backgroundColor =  [UIColor clearColor];
    [Red_line sizeToFit];
    ////    nslog(@"%f %f",Red_line.frame.size.width,Red_line.frame.size.height);
    CGSize size1 =Red_line.frame.size;
    size1.width=292.0;
     //   //    nslog(@"%f %f",size1.width, size1.height);
    Red_line.frame = CGRectMake(Red_line.frame.origin.x, Red_line.frame.origin.y, size1.width, size1.height);
    [Red_line sizeThatFits:size1];
     //   //    nslog(@"%f %f",Red_line.frame.size.width,Red_line.frame.size.height);
    
    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(14.0, Red_line.frame.origin.y+Red_line.frame.size.height, 292.0, 50.0)];

    label.text = [ExternalFunctions placeInfoTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName];
    label.font = [AppDelegate OpenSansRegular:26];
    label.textColor = [UIColor whiteColor];
    //label.numberOfLines = 10;
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 500.0) lineBreakMode:NSLineBreakByTruncatingTail];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+35);
    }
    else{
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+50);
    }
  
//    demoLabel= [[OHAttributedLabel alloc]initWithFrame:label.frame];
//    //    [demoLabel setFrame:label.frame];
//    [demoLabel setAttributedText:attrStr];
//    [demoLabel setBackgroundColor:[UIColor clearColor]];
 //   [_ScrollView addSubview:demoLabel];
    
    
    [label setScrollEnabled:NO];
   // [label1 setFrame:label.frame];
    
    

    UIButton *address = [UIButton buttonWithType:UIButtonTypeCustom];
    [address setFrame:CGRectMake(35.0, label.frame.origin.y+label.frame.size.height, 250.0, 32.0)];
    [address setTitle:[ExternalFunctions placeAddresTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName] forState:UIControlStateNormal];
    [address setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [address setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [address sizeToFit];
    CGRect frame = address.frame;
    frame.size.height*=2;
    address.frame = frame;
    [address.titleLabel setFont:[AppDelegate OpenSansRegular:26]];//[UIFont boldSystemFontOfSize:20]];
    [address addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *Point =  [[UIImageView alloc] initWithFrame:CGRectMake(14.0, label.frame.origin.y+label.frame.size.height+10, 14.0, 16.0)];
    Point.backgroundColor =  [UIColor clearColor];
    Point.image = [UIImage imageNamed:@"ico_point.png"];
    CGPoint center = address.center;
    center.x = Point.center.x;
    Point.center = center;//tel.center;
    [address setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];//
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, address.frame.origin.y+address.frame.size.height, 292.0, 1.0)];
    line1.backgroundColor =  [UIColor clearColor];
    line1.image = [UIImage imageNamed:@"separator_line.png"];
    
    
    
    UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
    [tel setFrame:CGRectMake(35.0,address.frame.origin.y+address.frame.size.height, 250.0, 32.0)];
    [tel setTitle:[ExternalFunctions placeTelephoneTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName] forState:UIControlStateNormal];
    [tel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [tel setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [tel sizeToFit];
    frame = tel.frame;
    frame.size.height*=2;
    tel.frame = frame;
   // [tel setBackgroundColor:[UIColor blackColor]];
    [tel.titleLabel setFont:[AppDelegate OpenSansRegular:26]];//[UIFont boldSystemFontOfSize:20]];
    [tel addTarget:self action:@selector(launchPhoneWithNumber:) forControlEvents:UIControlEventTouchUpInside];
 
    
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(250,16, 9, 14)];
    _actb.image=[UIImage imageNamed:@"actb_white"];
    [tel addSubview:_actb];
    
    size1 =tel.frame.size;
    size1.width=271.0;
    tel.frame = CGRectMake(tel.frame.origin.x,tel.frame.origin.y, size1.width, size1.height);

//#warning renren
    UIImageView *Phone = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, address.frame.origin.y+address.frame.size.height+20.0, 12.0, 18.0)];
    Phone.backgroundColor =  [UIColor clearColor];
    Phone.image = [UIImage imageNamed:@"ico_tel.png"];
   
    center = tel.center;
    center.x = Phone.center.x;
    Phone.center = center;//tel.center;
    [tel setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];//setConVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //center.y = tel.center.y;
    //Phone.center = center;
    
   UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, tel.frame.origin.y+tel.frame.size.height, 292.0, 1.0)];
    line2.backgroundColor =  [UIColor clearColor];
    line2.image = [UIImage imageNamed:@"separator_line.png"];
    

    UIButton *web = [UIButton buttonWithType:UIButtonTypeCustom];
    [web setFrame:CGRectMake(35.0,tel.frame.origin.y+tel.frame.size.height, 250.0, 32.0)];
    [web setTitle: [ExternalFunctions placeWebSiteTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName] forState:UIControlStateNormal];
    [web setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [web setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [web sizeToFit];
    frame = web.frame;
    frame.size.height*=2;
    web.frame = frame;
    //[web setBackgroundColor:[UIColor blackColor]];
    
    [web.titleLabel setFont:[AppDelegate OpenSansRegular:26]];
    [web addTarget:self action:@selector(webPressed:) forControlEvents:UIControlEventTouchUpInside];
 
    size1 =web.frame.size;
    size1.width=271.0;
    web.frame = CGRectMake(web.frame.origin.x,web.frame.origin.y, size1.width, size1.height);

    _actb = [[UIImageView alloc] initWithFrame:CGRectMake(250,16, 9, 14)];
    _actb.image=[UIImage imageNamed:@"actb_white"];
    [web addSubview:_actb];
    
    UIImageView *earth = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, tel.frame.origin.y+tel.frame.size.height+20.0, 16.0, 16.0)];
    earth.backgroundColor =  [UIColor clearColor];
    earth.image = [UIImage imageNamed:@"ico_earth.png"];
    
    center = web.center;
    center.x = earth.center.x;
    earth.center = center;//tel.center;
    [web setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];
    
    
    _actb = [[UIImageView alloc] initWithFrame:CGRectMake(250,16, 9, 14)];
    _actb.image=[UIImage imageNamed:@"actb_white"];
    [address addSubview:_actb];
    
    CGSize size = _ScrollView.frame.size;
    size.height = earth.frame.size.height+earth.frame.origin.y + 32.0;
    _ScrollView.contentSize = size;
    
    [_ScrollView addSubview:label];
    [_ScrollView addSubview:Red_line];
    
    [_ScrollView addSubview:address];
    [_ScrollView addSubview:Point];
    [_ScrollView addSubview:line1];
    
    [_ScrollView addSubview:tel];
    [_ScrollView addSubview:Phone];
    [_ScrollView addSubview:line2];
    
    [_ScrollView addSubview:web];
    [_ScrollView addSubview:earth];

    
    UIButton *btn = [InterfaceFunctions map_button:1];
    [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
 
    
    
    
    NSURL *url;
    if ([self.PlaceCityName isEqualToString:@"Moscow"] || [self.PlaceCityName isEqualToString:@"Москва"] || [self.PlaceCityName isEqualToString:@"Moskau"]){
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Moscow/2" ofType:@"mbtiles"]];
    }
    if ([self.PlaceCityName isEqualToString:@"Vienna"] || [self.PlaceCityName isEqualToString:@"Вена"] || [self.PlaceCityName isEqualToString:@"Wien"]){
        url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Vienna/vienna" ofType:@"mbtiles"]];
    }
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:url];
    self.MapPlace.showsUserLocation = YES;
    self.MapPlace = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    self.MapPlace.hidden = NO;
    self.MapPlace.hideAttribution = YES;
    self.MapPlace.delegate = self;
    
    if ([AppDelegate isiPhone5])
        self.MapPlace.frame = CGRectMake(0.0, 44.0, 320.0, 504.0);
    else
        self.MapPlace.frame = CGRectMake(0.0, 10.0, 320.0, 450.0);
    
    
    
    self.MapPlace.minZoom = 13;
    self.MapPlace.zoom = 13;
//    self.MapPlace.maxZoom = 17;
   
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    self.MapPlace.showsUserLocation = YES;
    [self.placeViewMap setHidden:YES];
    [self.placeViewMap addSubview:self.MapPlace];
    
    CLLocation *placecoord = [ExternalFunctions getPlaceCoordinatesInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName];
    //    nslog(@"%f %f",placecoord.coordinate.latitude,placecoord.coordinate.longitude);
    self.MapPlace.centerCoordinate =  placecoord.coordinate;
    CLLocationCoordinate2D coord = placecoord.coordinate;
 
    NSInteger numberofpins = 1;
    for (int i = 0; i<numberofpins; i++) {
 
        RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:CLLocationCoordinate2DMake(coord.latitude, coord.longitude) andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        
        marker1.title = self.PlaceName;
        marker1.subtitle = self.PlaceCategory;
        marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
        
        [self.MapPlace addAnnotation:marker1];
    }
    [self refreshButtonState];
    [self.locationButton setHidden:YES];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.MapPlace addSubiew:self.locationButton];
    
}


-(void)backgroundgo{
  //  NSLog(@"backgroundgo");
    if (infoViewIsOpen == YES) {
        [self tapDetected:nil];
    }
}

-(IBAction)showLocation:(id)sender{
    NSLog(@"showlocation");
   
    if (self.navigationController.navigationBar.frame.origin.y !=20) {
        infoViewIsOpen = !infoViewIsOpen;
        _labelonPhoto.hidden = YES;
        _background.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
    }
    
    [self.MapPlace setCenterCoordinate:self.MapPlace.userLocation.coordinate];
}

- (void)refreshButtonState
{
    if (![_vkontakte isAuthorized])
    {
        [_loginB setTitle:@"Login"
                 forState:UIControlStateNormal];
        // [self hideControls:YES];
    }
    else
    {
        [_loginB setTitle:@"Logout"
                 forState:UIControlStateNormal];
        [_vkontakte getUserInfo];
        
    }
}



- (void)oneFingerSwipeUp:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    // NSLog(@"%@",recognizer);
    if (infoViewIsOpen == NO) {
        [self tapDetected:recognizer];
    }
}

- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)recognizer {
    if (infoViewIsOpen == YES) {
        [self tapDetected:recognizer];
    }
}

-(void)afternot{
    
}

-(void)afterreg{
    // NSLog(@"Hello after reg");
    self.labelonPhoto.hidden = NO;
    self.background.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.view setFrame:CGRectMake(0.0, -44.0, self.view.frame.size.width, self.view.frame.size.height+44.0)];    
}

-(void)gesture:(UIGestureRecognizer *)gestureRecognizer{
    //    nslog(@"like!");
    [self tapDetected:gestureRecognizer];
}

-(BOOL)launchPhoneWithNumber:(UIButton *)sender {

    
    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([AppDelegate isiPhone5])
        [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
    else
        [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
    infoViewIsOpen = !infoViewIsOpen;
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Call", nil)
                                                             delegate:self
                                                    cancelButtonTitle:@"Close"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: sender.titleLabel.text, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    return YES;
}




-(void)webPressed:(UIButton *)sender{
    
    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([AppDelegate isiPhone5])
        [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
    else
        [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
    infoViewIsOpen = !infoViewIsOpen;
    
    NSString *url = [NSString stringWithFormat:@"http://%@",sender.titleLabel.text];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Web", nil)
                                                             delegate:self
                                                    cancelButtonTitle:@"Close"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: url, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    
}

-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    
    if ([annotation.annotationType isEqualToString:@"marker"]) {
        //    nslog(@"Marker %@",annotation.title);
 
                RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                          tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                            sizeString:[annotation.userInfo objectForKey:@"marker-size"]];


        [marker replaceUIImage:[InterfaceFunctions MapPin:self.PlaceCategory].image];
        marker.canShowCallout = YES;
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return marker;
    }
    return nil;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    [self ShowMap:map];//t:nil];
//    PlaceName = annotation.title;
//    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

-(void)aftercall:(NSNotification *)notification{
    NSLog(@"some thing");
    if (self.navigationController.navigationBar.frame.origin.y ==20) {
        infoViewIsOpen = !infoViewIsOpen;
        _labelonPhoto.hidden = NO;
        _background.hidden = NO;
    }
    //    nslog(@"%f",self.navigationController.navigationBar.frame.origin.y);
    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.navigationController.navigationBar.hidden = YES;
    if ([AppDelegate isiPhone5]){
        [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        
        
    }
    else{
        [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        
    }
    NSLog(@"aftercall");
    if (self.placeViewMap.hidden == NO){
        _background.hidden = NO;
        _labelonPhoto.hidden = NO;
        [self ShowMap:self];
    }
//    [[NSNotificationCenter defaultCenter] observationInfo];

}

- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
        self.navigationController.navigationBar.hidden = YES;
        if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]){
            self.GOUSE.enabled = NO;
            [Use stopAnimating];
        }        
    }
}


-(void) setNewFontToTextViews:(UIView*) theView {
    if([[theView subviews] count])
        for( UIView * subView in [theView subviews])
            [self setNewFontToTextViews:subView] ;
    else if([theView isKindOfClass:[UITextView class]])
        [(UITextView*)theView setFont:[AppDelegate OpenSansRegular:26]];
}

-(void)viewWillDisappear:(BOOL)animated{
  //  NSLog(@"viewWillDisapper");
    infoViewIsOpen = NO;

}

-(void)viewDidDisappear:(BOOL)animated{
    if ([self.fromNotification isEqualToString:@"YES"]) {
        NSLog(@"disappear");
        self.navigationController.navigationBar.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    //    nslog(@"viewWillAppear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
            [self tapDetected:nil];
    if ([self.fromNotification isEqualToString:@"YES"]){

        
        UIButton *btn = [InterfaceFunctions home_button];
        [btn addTarget:self action:@selector(testmethod) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.ScrollView.backgroundColor = [InterfaceFunctions colorTextCategory:self.PlaceCategory];        
    }
    
    else{
        
    //    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
      //  self.navigationController.navigationBar.hidden = YES;
    }
}

-(void)testmethod{

    SplashViewController *view1 = [[UIStoryboard storyboardWithName:@"iPhone5" bundle:nil] instantiateViewControllerWithIdentifier:@"Splash"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:view1];
    [navController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    navController.navigationBarHidden = YES;
    [self.navigationController pushViewController:view1 animated:YES];
}
-(IBAction)infotap:(id)sender{
    [self tapDetected:nil];
    
}

- (IBAction)tapDetected:(UIGestureRecognizer *)sender {
   
        if (infoViewIsOpen == NO) {
            [UIView transitionWithView:self.PlaceView
                              duration:0.4
                               options:UIViewAnimationOptionCurveLinear
                            animations:^
             {
                 if ([AppDelegate isiPhone5]) {
                     
                     [self.PlaceView setFrame:CGRectMake(0.0, 152.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                 }
                 else{
                     [self.PlaceView setFrame:CGRectMake(0.0, 170.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                 }
             }
                            completion:NULL];
            infoViewIsOpen = YES;
            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, 20.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            self.navigationController.navigationBar.hidden = NO;
            _labelonPhoto.hidden = YES;
            _background.hidden = YES;
            _infobutton.hidden = YES;
        }
        else{
            [UIView transitionWithView:self.PlaceView
                              duration:0.4
                               options:UIViewAnimationOptionCurveLinear
                            animations:^
             {
                 
                 if ([AppDelegate isiPhone5]){
                     [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                     
                 }
                 else{
                     [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                     
                 }
             }
                            completion:NULL];
            
            infoViewIsOpen = NO;
            [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
            self.navigationController.navigationBar.hidden = YES;
            _labelonPhoto.hidden = NO;
            _background.hidden = NO;
            _infobutton.hidden = NO;
        }
}

 
-(IBAction)buttonPressed:(UIButton*)sender{

    
 //   //    nslog(@"Button Tab = %d",sender.tag);
    
    if (sender.tag == 2) {

        [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, -26.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
        self.navigationController.navigationBar.hidden = YES;
        
        if ([AppDelegate isiPhone5])
            [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        else
            [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        infoViewIsOpen = !infoViewIsOpen;
            
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Close"
                                    destructiveButtonTitle:nil
                                                    otherButtonTitles: AMLocalizedString(@"Share on facebook", nil),AMLocalizedString(@"Share on twitter", nil),AMLocalizedString(@"Share on VK", nil),AMLocalizedString(@"Share on Jen Jen", nil),AMLocalizedString(@"Send Email",nil),nil];
        
        [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];//showInView: [[self navigationController] navigationBar]];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        
        
    }
    
    if (sender.tag == 1) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"]) {
            [UIView animateWithDuration:1.0 animations:^{
                if ([AppDelegate isiPhone5])
                    [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
                else
                    [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
            }];
            infoViewIsOpen = !infoViewIsOpen;
            [self presentSemiViewController:VC withOptions:@{
             KNSemiModalOptionKeys.pushParentBack    : @(YES),
             KNSemiModalOptionKeys.animationDuration : @(0.5),
             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
             }];
            
            VC.view.backgroundColor = [UIColor clearColor];
            VC.PlaceName = self.PlaceName;
            VC.PlaceCategory = self.PlaceCategory;
            VC.PlaceCity = self.PlaceCityName;
            VC.color = self.Color;
            _labelonPhoto.hidden = NO;
            _background.hidden = NO;
            
        }
        else{

        [self showRegistrationMessage:self];
        }
        
    }
    
    if (sender.tag == 0) {
        HUD = [MBProgressHUD showHUDAddedTo:self.PlaceView animated:YES];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.margin = 10.f;
        HUD.yOffset = -100.f;
        HUD.removeFromSuperViewOnHide = YES;
        

        HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Object added to favourites", nil)];
        
        HUD.mode = MBProgressHUDModeCustomView;
       
        HUD.delegate = self;
        [ExternalFunctions addToFavouritesPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName];

        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        self.Favorites.enabled = NO;
        [self.favText setText:@""];//AMLocalizedString(@"Favorited", nil)];
      //  [self.favText sizeToFit];
    }
}

    

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    
    
    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Call", nil)]) {
        
        if (buttonIndex == 0){
            
            
            NSString *tel =[actionSheet buttonTitleAtIndex:0];
            NSString* launchUrl = [NSString stringWithFormat:@"tel:%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
    }
    
    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Web", nil)]) {
        if (buttonIndex == 0){
            
            NSURL *address =[[NSURL alloc] initWithString:[actionSheet buttonTitleAtIndex:0]];
            [[UIApplication sharedApplication] openURL:address];
            
        }
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on VK", nil)]) {
        
        _vkontakte = [Vkontakte sharedInstance];
        _vkontakte.delegate = self;

        if (![_vkontakte isAuthorized])
        {
            [_vkontakte authenticate];
            

        }
        else
        {
            [_vkontakte postMessageToWall:[ExternalFunctions placeInfoTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName]];
        }
        
        
        
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on twitter", nil)]) {
        if (_engine) return;
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
        
        UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        if (controller)
            [self presentViewController:controller animated:YES completion:^{}];//presentModalViewController: controller animated: YES];
        else {
            [_engine sendUpdate: [ExternalFunctions placeInfoTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName]];
        }
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AMLocalizedString(@"Share on facebook", nil)]) {
        loadingView.hidden = NO;
//#warning текстика со ссылочкой!
        [SCFacebook loginCallBack:^(BOOL success, id result) {
            loadingView.hidden = YES;
            if (success) {
                
                [SCFacebook feedPostWithLinkPath:@"http://www.likelik.com" caption:@"Best Service!" callBack:^(BOOL success, id result) {
                    loadingView.hidden = YES;
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    
                    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
                    
                    // Set custom view mode
                    HUD.mode = MBProgressHUDModeCustomView;
                    
                    HUD.delegate = self;
                    HUD.labelText = AMLocalizedString(@"Done", nil);
                    
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1];
                }];
            }
        }];       
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AMLocalizedString(@"Send Email", nil)]) {
        [self openMail:self];
    }
    
    //[TestFlight passCheckpoint:[actionSheet buttonTitleAtIndex:buttonIndex]];
}


- (void) finish
{ 
   
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
     self.Favorites.enabled = YES;
}

-(IBAction)showQR:(id)sender{
    
}

-(IBAction)ShowMap:(id)sender{
    self.placeViewMap.hidden = !self.placeViewMap.hidden;
//    self.locationButton.hidden = !self.locationButton.hidden;
//    if (self.locationButton.hidden == YES){
//        [_scroll setScrollEnabled:YES];
//        [_ScrollView setScrollEnabled:YES];
//        [pageControl setEnabled:YES];
//        NSLog(@"scroll enabled");
//    }
//    else{
//        [_scroll setScrollEnabled:NO];
//        [_ScrollView setScrollEnabled:NO];
//        [pageControl setEnabled:NO];
//        NSLog(@"scroll disabled");
//    }
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
}

- (void)viewDidUnload {
    [self setGradientunderLabel:nil];
    [self setViewWithContent:nil];
    [self setScrollView:nil];
    [self setTextPlace:nil];
    [self setText:nil];
    [super viewDidUnload];
}


#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
//#warning охуенно было бы сделать ссылку сюда
           [_vkontakte postMessageToWall:[ExternalFunctions placeInfoTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName]];
    [self dismissViewControllerAnimated:YES completion:^{}];//
}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
   // [self refreshButtonState];
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    // NSLog(@"%@", info);
    
    
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{

    // NSLog(@"%@", responce);
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = AMLocalizedString(@"Done", nil);
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	// NSLog(@"Authenicated for %@", username);
    
//#warning текст twitter
   [_engine sendUpdate: [ExternalFunctions placeInfoTextInCity:self.PlaceCityName InCategory:self.PlaceCategory WithName:self.PlaceName]];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	// NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	// NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	// NSLog(@"Request %@ succeeded", requestIdentifier);
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    

    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = AMLocalizedString(@"Done", nil);
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	// NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


-(IBAction)showRegistrationMessage:(id)sender{

    message = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Registration", nil)
                                     message:AMLocalizedString(@"To use all the features of the world LikeLik, please register", nil)
                                    delegate:nil
                           cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
                           otherButtonTitles:AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil), nil];
    message.delegate = self;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{//dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    if (buttonIndex == 1) {
        // NSLog(@"Whant to Register");
        //[TestFlight passCheckpoint:@"Whant to Register"];
        [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
    }
    if (buttonIndex == 2) {
        NSLog(@"Login");
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    if (buttonIndex == 0){
        //[TestFlight passCheckpoint:@"Cancel Register"];
    }
}

- (IBAction)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
//#warning Тема
        [mailer setSubject:AMLocalizedString(@"Email Subject", nil)];
//#warning Адресаты
        //NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        //[mailer setToRecipients:toRecipients];
 //       UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
   //     NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
//#warning Текст
        NSString *emailBody = AMLocalizedString(@"Email Text", nil);
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:^{}];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            // NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            // NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            // NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            // NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:^{}];//dismissModalViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"RegisterSegue"]) {
        
        [UIView animateWithDuration:1.0 animations:^{
            if ([AppDelegate isiPhone5])
                [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
            else
                [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        }];
        infoViewIsOpen = !infoViewIsOpen;
        
        RegistrationViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.Parent = @"Place";
    }
    
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        
        [UIView animateWithDuration:1.0 animations:^{
            if ([AppDelegate isiPhone5])
                [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
            else
                [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
        }];
        infoViewIsOpen = !infoViewIsOpen;
        
        LoginViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.Parent = @"Place";
    }
}
@end

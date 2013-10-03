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

#import "SplashViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SCFacebook.h"
#import "MBProgressHUD.h"
#import "RegistrationViewController.h"
#import "MapViewAnnotation.h"

#define kOAuthConsumerKey				@"WMLtzHCcXrkaDXzNovw"
#define kOAuthConsumerSecret			@"AcFQTmoGxkPdOgif68FzYgRBylSXIbeaYTbwnZaR9SE"

#define MAX_HEIGHT 2000
#define afterCall             @"l27h7RU2dzVfPoQQQQ"
#define afternotification             @"l27h7RU2dzVfPoQssda"
#define afterregister             @"l27h7RU2dzVfP12aoQssda"
#define backgroundg @"l27h7RU2123123132dzVfPoQssda"
#define checkOpen                 @"l27h7RU2dzVfP12aoQssdasasa"
static BOOL infoViewIsOpen = YES;
static UIAlertView *alertView = nil;
static NSString * currentCity = @"";

CGFloat firstX=0;
CGFloat firstY=0;
CGFloat alpha = 0.5;
static NSString *LorR = nil;

CGRect PlaceCardRectOpen;
CGRect PlaceCardRectClose;

@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize pageControl;


-(IBAction)clickPageControl:(id)sender
{
    int page=pageControl.currentPage;
    CGRect frame=_scroll.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [_scroll scrollRectToVisible:frame animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
    
}


-(IBAction)MovePlaceCard:(UISwipeGestureRecognizer *)sender{
    
    [UIView transitionWithView:self.PlaceView duration:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
        if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
            [self.PlaceView setFrame:PlaceCardRectOpen];
        }
        if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
            
            [self.PlaceView setFrame:PlaceCardRectClose];
        }
        infoViewIsOpen =!infoViewIsOpen;

    } completion:NULL];
}


//-(void)move:(id)sender {
//       CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.PlaceView].y);
//        
//        if (velocityY>0 && infoViewIsOpen == YES) {
//            // [AppDelegate LLLog:[NSString stringWithFormat:@"Вниз");
//            [UIView transitionWithView:self.PlaceView
//                              duration:0.4
//                               options:UIViewAnimationOptionCurveLinear
//                            animations:^
//             {
//                 
//                 if ([AppDelegate isiPhone5]){
//                     [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//                 }
//                 else{
//                     [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//                     
//                 }
//             }
//                            completion:NULL];
//            infoViewIsOpen = NO;
//        
//        }
//        
//        if (velocityY<0 && infoViewIsOpen == NO) {
//            [UIView transitionWithView:self.PlaceView
//                              duration:0.4
//                               options:UIViewAnimationOptionCurveLinear
//                            animations:^
//             {
//                 if ([AppDelegate isiPhone5]) {
//                     
//                     [self.PlaceView setFrame:CGRectMake(0.0, 152.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//                     
//                 }
//                 else{
//                     [self.PlaceView setFrame:CGRectMake(0.0, 170.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//                 }
//             }
//                            completion:NULL];
//            infoViewIsOpen = YES;
//        }
//  //  }
//}

- (void)viewDidLoad{
    [super viewDidLoad];

#warning HARD CODING
#warning маленький дрыг
    PlaceCardRectOpen = CGRectMake(0.0,  self.view.frame.size.height-self.self.PlaceView.frame.size.height-40.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height);
    
    
    PlaceCardRectClose = CGRectMake(0.0, self.view.frame.size.height, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height);
    
    [self.info_button setImage:[InterfaceFunctions Info_buttonwithCategory:self.PlaceCategory].image forState:UIControlStateNormal];
    if ([AMLocalizedString(@"Moscow", nil) isEqualToString:self.PlaceCityName]) {
        currentCity = @"Moscow";
    }
    else{
        currentCity = @"Vienna";
    }
    self.hint.userInteractionEnabled = YES;
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide_hint:)];
    recognizer.delegate = self;
    
    [self.hint addGestureRecognizer:recognizer];
    NSString *tmp = [[NSString alloc] init];
    NSString *Lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"Language"];
    if ([Lang isEqualToString:@"Русский"])
        tmp = @"ru";
    if ([Lang isEqualToString:@"Deutsch"])
        tmp = @"de";
    if ([Lang isEqualToString:@"English"])
        tmp = @"en";
    if ([Lang isEqualToString:@"Japanese"]) {
        tmp = @"jp";
    }
    if (![[[NSUserDefaults standardUserDefaults ] objectForKey:@"hint"] isEqualToString:@"YES"]) {
        [AppDelegate LLLog:[NSString stringWithFormat:@"%@",LocalizationGetLanguage]];
        if ([AppDelegate isiPhone5]) {
            [self.hint setImage:[UIImage imageNamed:[NSString stringWithFormat:@"5-%@.png",tmp]]];
        }
        else{
            [self.hint setImage:[UIImage imageNamed:[NSString stringWithFormat:@"4-%@.png",tmp]]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hint"];
    }
    else{
        self.hint.hidden = YES;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
//    if ([self.fromNotification isEqualToString:@"NO"])
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(aftercall:)
//                                                 name: afterCall
//                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(afterreg)
                                                 name: afterregister
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(backgroundgo)
                                                 name: backgroundg
                                               object: nil];
    
    

    self.PlaceView.backgroundColor =  [UIColor clearColor];
    self.ScrollView.backgroundColor = self.Color;
    _ScrollView.contentSize = CGSizeMake(320.0, 400.0);
    
    self.navigationItem.title = @"";
//    [self.scroll addGestureRecognizer:singleTap];
    NSArray *photos = self.Photos;
    
    VC = [[CheckViewController alloc] initWithNibName:@"CheckViewController" bundle:nil];
    [AppDelegate LLLog:[NSString stringWithFormat:@"Hello = %@",VC.nibName]];


    
    self.view.backgroundColor = [UIColor redColor];
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = [UIColor blackColor];
    NSInteger numberOfViews = [photos count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageWithContentsOfFile:[photos objectAtIndex:i]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height/4);
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
	_TextPlace.font = [AppDelegate OpenSansRegular:28];
	_TextPlace.textColor = [UIColor whiteColor];
    _TextPlace.scrollEnabled = YES;
    _TextPlace.editable = NO;
    _infoScroll.contentSize = CGSizeMake(320.0, 512.0);
    

    [self.Favorites setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_normal"].image forState:UIControlStateNormal];
    [self.Favorites setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"1fav_selected"].image forState:UIControlStateHighlighted];
    [self.GOUSE setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_normal"].image forState:UIControlStateNormal];
    [self.GOUSE setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"2use_selected"].image forState:UIControlStateHighlighted];
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_normal"].image forState:UIControlStateNormal];
    [self.Share setBackgroundImage:[InterfaceFunctions TabitemwithCategory:self.PlaceCategory andtag:@"3share_selected"].image forState:UIControlStateHighlighted];
    
    self.favImage = [InterfaceFunctions favouritestarPlaceView];
    [self.Favorites addSubview:self.favImage];
    
    
    self.Use = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2use.png"]];
    self.Use.frame = CGRectMake(45.0, 10.0, self.Use.frame.size.width, self.Use.frame.size.height);


    
    NSMutableArray *animation = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 1; i<8; i++) {
        NSString *image = [[NSString alloc] initWithFormat:@"Fist_animated_%d.png",i];
        [animation addObject:[UIImage imageNamed:image]];
    }
    
    self.Use.animationImages = animation;
    self.Use.animationDuration = 1.0;
    [self.Use startAnimating];
    
    if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]){
        self.GOUSE.enabled = NO;
        [self.Use stopAnimating];
    }
    [self.GOUSE addSubview:self.Use];
    
    
    
    UIImageView *share = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3share.png"]];
    share.frame = CGRectMake(45.0, 10.0, share.frame.size.width, share.frame.size.height);
    [share setCenter:CGPointMake(54, self.favImage.center.y)];
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
        self.favImage.alpha = alpha;
        [self.favText removeFromSuperview];
        self.favText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        self.favText.numberOfLines = 0;
        [self.favText setText:AMLocalizedString(@"Favorited", nil)];
        self.favText.font = [AppDelegate OpenSansBoldwithSize:18];
        self.favText.textColor  = [UIColor whiteColor];
        self.favText.backgroundColor = [UIColor clearColor];
        [self.favText setCenter:CGPointMake(self.Favorites.center.x, self.Favorites.center.y)];
        [self.favText sizeToFit];
        [self.favText setFrame:CGRectMake((107.0-self.favText.frame.size.width)/2, 50-20.0, self.favText.frame.size.width, self.favText.frame.size.height)];
        [self.Favorites addSubview:self.favText];
        self.favText.alpha = alpha;
    }
    
    UILabel *UseText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    UseText.numberOfLines = 0;
    [UseText setText:AMLocalizedString(@"Use", nil)];
    UseText.font = [AppDelegate OpenSansBoldwithSize:18];
    UseText.textColor  = [UIColor whiteColor];
    UseText.backgroundColor = [UIColor clearColor];
    [UseText sizeToFit];
    [UseText setFrame:CGRectMake((106.0-UseText.frame.size.width)/2, 50-20.0, UseText.frame.size.width, UseText.frame.size.height)];
    [UseText setCenter:CGPointMake(self.Use.center.x, UseText.center.y)];
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
    
    _TextPlace.text = self.PlaceAbout;
    _Teltext.text = self.PlaceTelephone;
    _webtext.text = self.PlaceWeb;
   
    
    [_ScrollView setBackgroundColor:self.Color];
    
    UILabel *Red_line = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 10.0, 250.0, 50.0)];
    Red_line.text = self.PlaceName;
    Red_line.font =[AppDelegate OpenSansSemiBold:28];
    Red_line.textColor = [UIColor whiteColor];
    Red_line.numberOfLines = 10;
    Red_line.backgroundColor =  [UIColor clearColor];
    Red_line.numberOfLines = 0;
   // Red_line.backgroundColor =  [UIColor clearColor];
    [Red_line sizeToFit];
    ////    [AppDelegate LLLog:[NSString stringWithFormat:@"%f %f",Red_line.frame.size.width,Red_line.frame.size.height);
    CGSize size1 =Red_line.frame.size;
    size1.width=292.0;
     //   //    [AppDelegate LLLog:[NSString stringWithFormat:@"%f %f",size1.width, size1.height);
    Red_line.frame = CGRectMake(Red_line.frame.origin.x, Red_line.frame.origin.y, size1.width, size1.height);
    [Red_line sizeThatFits:size1];
     //   //    [AppDelegate LLLog:[NSString stringWithFormat:@"%f %f",Red_line.frame.size.width,Red_line.frame.size.height);
    
    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(14.0, Red_line.frame.origin.y+Red_line.frame.size.height, 292.0, 50.0)];
    label.text = self.PlaceAbout;
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor whiteColor];
    //label.numberOfLines = 10;
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
   // label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(6.0,label.frame.origin.y, 320.0, textViewSize.height+70);
    }
    else{
        label.frame = CGRectMake(6.0,label.frame.origin.y, 320.0, textViewSize.height+70);
    }
    [label sizeToFit];

    [label setScrollEnabled:NO];
    
    

    UILabel *address = [[UILabel alloc] init];//[UIButton buttonWithType:UIButtonTypeCustom];
    [address setFrame:CGRectMake(35.0, label.frame.origin.y+label.frame.size.height, 262.0, 32.0)];
    //[address setTitle:self.PlaceAddress forState:UIControlStateNormal];
    [address setText:self.PlaceAddress];
    //[address setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //[address setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    //[address sizeToFit];
    CGRect frame = address.frame;
    frame.size.height*=2;
    address.frame = frame;
    address.backgroundColor = [UIColor clearColor];
    address.textColor = [UIColor whiteColor];
    [address setFont:[AppDelegate OpenSansRegular:28]];//[UIFont boldSystemFontOfSize:20]];
    //[address addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowMap:)];
    [address addGestureRecognizer:tap];
    [address setUserInteractionEnabled:YES];

    UIImageView *Point =  [[UIImageView alloc] initWithFrame:CGRectMake(14.0, label.frame.origin.y+label.frame.size.height+10, 14.0, 16.0)];
    Point.backgroundColor =  [UIColor clearColor];
    Point.image = [UIImage imageNamed:@"ico_point.png"];
    CGPoint center = address.center;
    center.x = Point.center.x;
    Point.center = center;//tel.center;
    //[address setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];//
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, address.frame.origin.y+address.frame.size.height, 292.0, 1.0)];
    line1.backgroundColor =  [UIColor clearColor];
    line1.image = [UIImage imageNamed:@"separator_line.png"];
    
    
    
    UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
    [tel setFrame:CGRectMake(35.0,address.frame.origin.y+address.frame.size.height, 250.0, 32.0)];
    [tel setTitle:self.PlaceTelephone forState:UIControlStateNormal];
    [tel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [tel setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [tel sizeToFit];
    frame = tel.frame;
    frame.size.height*=2;
    tel.frame = frame;
   // [tel setBackgroundColor:[UIColor blackColor]];
    [tel.titleLabel setFont:[AppDelegate OpenSansRegular:28]];//[UIFont boldSystemFontOfSize:20]];
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
    [web setTitle: self.PlaceWeb forState:UIControlStateNormal];
    [web setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [web setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [web sizeToFit];
    frame = web.frame;
    frame.size.height*=2;
    web.frame = frame;
    //[web setBackgroundColor:[UIColor blackColor]];
    
    [web.titleLabel setFont:[AppDelegate OpenSansRegular:28]];
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
    
    
    _actb = [[UIImageView alloc] initWithFrame:CGRectMake(250, 26, 9, 14)];
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
#if LIKELIK
    NSURL *url;
    self.mapView.hidden = YES;
    if ([self.PlaceCityName isEqualToString:@"Moscow"] || [self.PlaceCityName isEqualToString:@"Москва"] || [self.PlaceCityName isEqualToString:@"Moskau"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Moscow/2.mbtiles",[ExternalFunctions docDir]]];
    }
    if ([self.PlaceCityName isEqualToString:@"Vienna"] || [self.PlaceCityName isEqualToString:@"Вена"] || [self.PlaceCityName isEqualToString:@"Wien"]){
        url = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"%@/Vienna/vienna.mbtiles",[ExternalFunctions docDir]]];
    }

    
    [self.MapPlace setShowsUserLocation:YES];
    [self.MapPlace setTileSource:[[RMMBTilesSource alloc] initWithTileSetURL:url]];
    [self.MapPlace setHideAttribution:YES];
    [self.MapPlace setMinZoom:13];
    [self.MapPlace setMaxZoom:13];
    [self.MapPlace setAdjustTilesForRetinaDisplay:YES];
    [self.MapPlace setHidden:YES];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 100.0, 30.0, 30.0)];
    [self.MapPlace addSubview:button];
    
    CLLocation *placecoord = self.PlaceLocation;
    //    [AppDelegate LLLog:[NSString stringWithFormat:@"%f %f",placecoord.coordinate.latitude,placecoord.coordinate.longitude);
    self.MapPlace.centerCoordinate =  placecoord.coordinate;
    CLLocationCoordinate2D coord = placecoord.coordinate;
 
    NSInteger numberofpins = 1;
    for (int i = 0; i<numberofpins; i++) {
 
        RMAnnotation *marker1 = [[RMAnnotation alloc]initWithMapView:self.MapPlace coordinate:CLLocationCoordinate2DMake(coord.latitude, coord.longitude) andTitle:@"Pin"];
        marker1.annotationType = @"marker";
        
        marker1.title = self.PlaceName;
       marker1.subtitle = AMLocalizedString(self.PlaceCategory, nil);
        marker1.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blueColor],@"foregroundColor", nil];
        
        [self.MapPlace addAnnotation:marker1];
    }
    [self refreshButtonState];
  //  [self.locationButton setHidden:YES];

//    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_normal"].image forState:UIControlStateNormal];
//    [self.locationButton setImage:[InterfaceFunctions UserLocationButton:@"_pressed"].image forState:UIControlStateHighlighted];
//    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
//    [self.MapPlace addSubview:self.locationButton];
#else
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
    
   // [self.mapView addSubview:self.locationButton];
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
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
}

-(void)map_tu:(UIButton *)sender{
    self.mapView.hidden= !self.mapView.hidden;
    self.locationButton.hidden =! self.locationButton.hidden;
}
#endif

-(BOOL)canBecomeFirstResponder{
    return NO;
}

-(void)backgroundgo{
//  //  [AppDelegate LLLog:[NSString stringWithFormat:@"backgroundgo");
//   // [AppDelegate LLLog:[NSString stringWithFormat:@"Hello!");
//    if (infoViewIsOpen == YES) {
//        [self tapDetected:nil];
//        self.MapPlace.hidden = YES;
//        self.mapView.hidden = YES;
//        [self hide_hint:self];
//    }
}

-(IBAction)showLocation:(id)sender{
    
#if LIKELIK
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate];
#else
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
#endif
}

- (void)refreshButtonState{

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

-(void)afterreg{
    UIButton *tmp = [[UIButton alloc] init];
    tmp.tag = 1;
//    [UIView animateWithDuration:1.0 animations:^{
//        if ([AppDelegate isiPhone5])
//            [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//        else
//            [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//    }];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
    {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Done"                                                       action:@"Register" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceName forKey:@"PlaceTemp"];
        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCategory forKey:@"CategoryTemp"];
        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCityName forKey:@"CityTemp"];
        [[NSUserDefaults standardUserDefaults] setObject:self.PlaceNameEn forKey:@"PlaceTempEN"];
        [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CityTempEN"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:checkOpen
                                                            object:self];
        
        infoViewIsOpen = !infoViewIsOpen;
//        [self presentSemiViewController:VC withOptions:@{
//         KNSemiModalOptionKeys.pushParentBack    : @(YES),
//         KNSemiModalOptionKeys.animationDuration : @(0.5),
//         KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
//         }];
        
        VC.view.backgroundColor = [UIColor clearColor];
        

        
//        VC.PlaceName = self.PlaceName;
//        VC.PlaceCategory = self.PlaceCategory;
//        VC.PlaceCity = self.PlaceCityName;
        VC.color = self.Color;

    }
}

-(BOOL)launchPhoneWithNumber:(UIButton *)sender {

    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Call" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
    
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Call", nil)
                                                             delegate:self
                                                    cancelButtonTitle:AMLocalizedString(@"Close",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: sender.titleLabel.text, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    return YES;
}

-(void)webPressed:(UIButton *)sender{
    
     [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Web" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Web", nil)
                                                             delegate:self
                                                    cancelButtonTitle :AMLocalizedString(@"Close",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: url, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    
}

-(void)aftercall:(NSNotification *)notification{
//    if ([AppDelegate isiPhone5]){
//        [self.PlaceView setFrame:CGRectMake(0.0, 496.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//        
//        
//    }
//    else{
//        [self.PlaceView setFrame:CGRectMake(0.0, 406.0, self.PlaceView.frame.size.width, self.PlaceView.frame.size.height)];
//        
//    }
//  //  [AppDelegate LLLog:[NSString stringWithFormat:@"aftercall");
//    if (self.placeViewMap.hidden == NO){
//        _background.hidden = NO;
//        _labelonPhoto.hidden = NO;
//        [self ShowMap:self];
//    }
}

- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        if ([ExternalFunctions isCheckUsedInPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCityName]){
            self.GOUSE.enabled = NO;
            [self.Use stopAnimating];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableInPlaces" object:nil];
        }        
    }
}


-(void) setNewFontToTextViews:(UIView*) theView {
    if([[theView subviews] count])
        for( UIView * subView in [theView subviews])
            [self setNewFontToTextViews:subView] ;
    else if([theView isKindOfClass:[UITextView class]])
        [(UITextView*)theView setFont:[AppDelegate OpenSansRegular:28]];
}

-(void)viewWillDisappear:(BOOL)animated{
    infoViewIsOpen = NO;
 //   [AppDelegate LLLog:[NSString stringWithFormat:@"Cammon");
}

-(void)viewDidDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@" %@ %@ %@",currentCity,self.PlaceCategory,self.PlaceNameEn ]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
          //  [self tapDetected:nil];
    // [testflight passCheckpoint:self.PlaceName];
//    if ([self.fromNotification isEqualToString:@"YES"]){
//        UIButton *btn = [InterfaceFunctions home_button];
//        [btn addTarget:self action:@selector(testmethod) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        self.ScrollView.backgroundColor = [InterfaceFunctions colorTextCategory:self.PlaceCategory];        
//    }
//    
#if LIKELIK
if ([[[CLLocation alloc] initWithLatitude:self.MapPlace.userLocation.coordinate.latitude longitude:self.MapPlace.userLocation.coordinate.longitude] distanceFromLocation:[ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName]] > 50000.0) {
    self.MapPlace.centerCoordinate = [ExternalFunctions getCenterCoordinatesOfCity:self.PlaceCityName].coordinate;
    //self.locationButton.enabled = NO;
    
}
else{
    self.MapPlace.centerCoordinate = self.MapPlace.userLocation.coordinate;
   // self.locationButton.enabled = YES;
}
#else
MKCoordinateSpan span;
span.latitudeDelta = 0.2;
span.longitudeDelta = 0.2;
// define starting point for map
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

-(void)testmethod{
//    SplashViewController *view1 = [[UIStoryboard storyboardWithName:@"iPhone5" bundle:nil] instantiateViewControllerWithIdentifier:@"Splash"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:view1];
////    [navController.navigationBar setTintColor:[UIColor colorWithRed:150.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1]];
////    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
//    navController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:view1 animated:YES];
}

 
-(IBAction)buttonPressed:(UIButton*)sender{
    
    if (sender.tag == 2) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        infoViewIsOpen = !infoViewIsOpen;
            
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:AMLocalizedString(@"Close",nil)
                                    destructiveButtonTitle:nil
                                                    otherButtonTitles: AMLocalizedString(@"Share on facebook", nil),AMLocalizedString(@"Share on twitter", nil),AMLocalizedString(@"Share on VK", nil),/*AMLocalizedString(@"Share on Jen Jen", nil),*/AMLocalizedString(@"Send Email",nil),nil];
        
        [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];//showInView: [[self navigationController] navigationBar]];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        
        
    }
    
    if (sender.tag == 1) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"]) {
            
            
            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceName forKey:@"PlaceTemp"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCategory forKey:@"CategoryTemp"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceCityName forKey:@"CityTemp"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PlaceNameEn forKey:@"PlaceTempEN"];
            [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CityTempEN"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:checkOpen
                                                                object:self];
            
            
             [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Use Check" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
            [self presentSemiViewController:VC withOptions:@{
             KNSemiModalOptionKeys.pushParentBack    : @(YES),
             KNSemiModalOptionKeys.animationDuration : @(0.5),
             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
             }];
            
            VC.view.backgroundColor = [UIColor clearColor];
//            VC.PlaceName = self.PlaceName;
//            VC.PlaceCategory = self.PlaceCategory;
//            VC.PlaceCity = self.PlaceCityName;
            VC.color = self.Color;

            
        }
        else{
        [self showRegistrationMessage:self];
        }
        
    }
    
    if (sender.tag == 0) {
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is"                                                       action:@"Favorited" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
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
            
            self.favImage.alpha = alpha;
            
            [self.favText removeFromSuperview];
            self.favText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
            self.favText.numberOfLines = 0;
            [self.favText setText:AMLocalizedString(@"Favorited", nil)];
            self.favText.font = [AppDelegate OpenSansBoldwithSize:18];
            self.favText.textColor  = [UIColor whiteColor];
            self.favText.backgroundColor = [UIColor clearColor];
            [self.favText setCenter:CGPointMake(self.Favorites.center.x, self.Favorites.center.y)];
            [self.favText sizeToFit];
            [self.favText setFrame:CGRectMake((107.0-self.favText.frame.size.width)/2, 50-20.0, self.favText.frame.size.width, self.favText.frame.size.height)];
            [self.Favorites addSubview:self.favText];
        self.favText.alpha = alpha;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Call", nil)]) {
        if (buttonIndex == 0){
             [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Call" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
            
            NSString *tel =[actionSheet buttonTitleAtIndex:0];
            NSString* launchUrl = [NSString stringWithFormat:@"tel:%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
    }
    
    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Web", nil)]) {
        if (buttonIndex == 0){
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Site" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
            NSURL *address =[[NSURL alloc] initWithString:[actionSheet buttonTitleAtIndex:0]];
            [[UIApplication sharedApplication] openURL:address];
            
        }
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on VK", nil)]) {
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share VK" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        _vkontakte = [Vkontakte sharedInstance];
        _vkontakte.delegate = self;

        if (![_vkontakte isAuthorized])
        {
            [_vkontakte authenticate];
            

        }
        else
        {
            [_vkontakte postMessageToWall:self.PlaceAbout link:[[NSURL alloc] initWithString:@"http://likelik.com"]];
           // [AppDelegate LLLog:[NSString stringWithFormat:@"%@",[[NSURL alloc] initWithString:@"http://likelik.com"]);
        }
        
        
        
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: AMLocalizedString(@"Share on twitter", nil)]) {
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share Twitter" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        if (_engine){
         //   [AppDelegate LLLog:[NSString stringWithFormat:@"123");
            [_engine sendUpdate: self.PlaceAbout];
            return;
        }
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
        
        UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        if (controller)
            [self presentViewController:controller animated:YES completion:^{}];//presentModalViewController: controller animated: YES];
        else {

        //    [AppDelegate LLLog:[NSString stringWithFormat:@"321");
            [_engine sendUpdate: self.PlaceAbout];
        }
    }
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AMLocalizedString(@"Share on facebook", nil)]) {
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share FB" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        loadingView.hidden = NO;
        [SCFacebook loginCallBack:^(BOOL success, id result) {
            loadingView.hidden = YES;
            if (success) {
                [SCFacebook feedPostWithLinkPath:@"http://www.likelik.com" caption:self.PlaceAbout callBack:^(BOOL success, id result) {
                    loadingView.hidden = YES;
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
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
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Share e-mail" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        [self openMail:self];
    }
}

- (void) finish{ 
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
     self.Favorites.enabled = YES;
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
    [self hide_hint:self];
#warning хинт
#if LIKELIK
    NSLog(@"MapPlace");
    [self.MapPlace setHidden:!self.MapPlace.hidden];
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
     //   [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:0.0 andPict:[UIImage imageNamed:@"navigationbar.png"]] forBarMetrics:UIBarMetricsDefault];

    }
    else{
        [self.locationButton setHidden:NO];
        UIButton *btn = [InterfaceFunctions map_button:0];
        [btn addTarget:self action:@selector(ShowMap:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];

    }

#endif
}

- (void)viewDidUnload {

    [self setScrollView:nil];
    [self setTextPlace:nil];
    [super viewDidUnload];
}


#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showVkontakteAuthController:(UIViewController *)controller{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)vkontakteAuthControllerDidCancelled{
    [self dismissViewControllerAnimated:YES completion:^{
       // [self tapDetected:nil];
    }];
   
   // [AppDelegate LLLog:[NSString stringWithFormat:@"123");
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte{
     [_vkontakte postMessageToWall:self.PlaceAbout link:[[NSURL alloc] initWithString:@"http://likelik.com"]];
    [self dismissViewControllerAnimated:YES completion:^{}];//
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce{
     [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is"                                                       action:@"Posted on the wall" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
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

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {

	[_engine sendUpdate: self.PlaceAbout];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	// [AppDelegate LLLog:[NSString stringWithFormat:@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
   
   // [self tapDetected:nil];
	// [AppDelegate LLLog:[NSString stringWithFormat:@"Authentication Canceled.");
}

#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
     [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is"                                                       action:@"Authorised Twitter" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = AMLocalizedString(@"Done", nil);
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
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
    if (buttonIndex == 1){
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Login" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        LorR = @"Login";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    if (buttonIndex == 2){
         [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Is going"                                                       action:@"Register" label:[NSString stringWithFormat:@"%@ %@",currentCity,self.PlaceNameEn] value:nil] build]];
        LorR = @"Login";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (IBAction)openMail:(id)sender{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:AMLocalizedString(@"Email Subject", nil)];
        NSString *emailBody = AMLocalizedString(@"Email Text", nil);
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:^{}];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            // [AppDelegate LLLog:[NSString stringWithFormat:@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:^{    [self aftercall:nil];}];//dismissModalViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    infoViewIsOpen = !infoViewIsOpen;
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        RegistrationViewController *destination = [segue destinationViewController];
        destination.LorR = LorR;
    }
}
-(IBAction)hide_hint:(id)sender{
    self.hint.hidden = YES;
    self.hide_button.hidden = YES;
}

- (IBAction)InfoTouch:(UIButton *)sender {
    [UIView transitionWithView:self.PlaceView duration:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.PlaceView setFrame:PlaceCardRectOpen];
    } completion:^(BOOL finished){
        infoViewIsOpen =!infoViewIsOpen;
    }];
    
}



@end

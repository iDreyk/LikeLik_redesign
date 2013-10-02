//
//  ViewController.h
//  PageView
//
//  Created by Vladimir Malov on 05.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import <MessageUI/MessageUI.h>
#import "UIViewController+KNSemiModal.h"
#import "Vkontakte.h"
#import "SA_OAuthTwitterController.h"
@class CheckViewController;




@interface PlaceViewController : UIViewController<RMMapViewDelegate, UIActionSheetDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,VkontakteDelegate,SA_OAuthTwitterControllerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate> {
    CheckViewController *VC;
    UIPageControl *pageControl;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain) NSString *fromNotification;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@property (nonatomic,retain) CLLocation *PlaceLocation;
@property (nonatomic,retain) NSArray *Photos;
@property (nonatomic, retain) UIColor *Color;
@property (weak, nonatomic) IBOutlet UIImageView *hint;
@property (weak, nonatomic) IBOutlet UIButton *hide_button;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic,retain)IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *info_button;

@property (nonatomic, retain)IBOutlet UILabel *favText;
@property (nonatomic, retain)IBOutlet UIImageView *favImage;

-(IBAction)showLocation:(id)sender;
-(IBAction)openMail:(id)sender;
-(IBAction)hide_hint:(id)sender;





@property (nonatomic,retain) NSString *PlaceName;
@property (nonatomic,retain) NSString *PlaceNameEn;
@property (nonatomic,retain) NSString *PlaceCityName;
@property (nonatomic,retain) NSString *PlaceCategory;
@property (nonatomic,retain) NSString *PlaceAbout;
@property (nonatomic,retain) NSString *PlaceAddress;
@property (nonatomic,retain) NSString *PlaceWeb;
@property (nonatomic,retain) NSString *PlaceTelephone;

-(IBAction)ShowMap:(id)sender;
-(IBAction)PlaceCardMove:(id)sender;

@property(nonatomic,retain)UISwipeGestureRecognizer *SwipeUp;
@property(nonatomic,retain)UISwipeGestureRecognizer *SwipeDown;

@property (weak, nonatomic) IBOutlet UIView *PlaceCard;
@property (weak, nonatomic) IBOutlet UIScrollView *PlaceCardScroll;
@property (weak, nonatomic) IBOutlet UIButton *Favourite;
@property (weak, nonatomic) IBOutlet UIButton *Use;
@property (weak, nonatomic) IBOutlet UIButton *Share;

@property (weak, nonatomic) IBOutlet UILabel *Red_Line;
@property (weak, nonatomic) IBOutlet UITextView *PlaceText;


@property (weak, nonatomic) IBOutlet UIButton *Address;
- (IBAction)OpenMap:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Telephone;
- (IBAction)Call:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *http;
- (IBAction)Surf:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *PlaceonMap;
@property (retain, nonatomic) IBOutlet RMMapView *MapPlace;


@end

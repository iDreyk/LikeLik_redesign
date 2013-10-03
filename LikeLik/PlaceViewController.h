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
    IBOutlet UIButton *_loginB;
    Vkontakte *_vkontakte;
    SA_OAuthTwitterEngine				*_engine;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain) UIImageView *Use;
//@property (nonatomic,retain) NSString *fromNotification;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

//@property (weak, nonatomic) IBOutlet UILabel *LabelOnScroll;
//@property (retain, nonatomic) IBOutlet UILabel *labelonPhoto;
//@property (nonatomic,retain) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *Favorites;
@property (weak, nonatomic) IBOutlet UIButton *GOUSE;
@property (weak, nonatomic) IBOutlet UIButton *Share;
//@property (weak, nonatomic) IBOutlet UIView *InfoPlaceTable;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScroll;

@property (weak, nonatomic) IBOutlet UIImageView *PlacePinimage;
@property (weak, nonatomic) IBOutlet UIImageView *TelPinimage;
@property (weak, nonatomic) IBOutlet UIImageView *WebPinimage;
@property (weak, nonatomic) IBOutlet UILabel *Placeadress;
@property (weak, nonatomic) IBOutlet UILabel *Teltext;
@property (weak, nonatomic) IBOutlet UILabel *webtext;
@property (weak, nonatomic) IBOutlet UIImageView *Separator;
@property (weak, nonatomic) IBOutlet UIImageView *Separator1;
@property (weak, nonatomic) IBOutlet UIImageView *Separator3;
@property (weak, nonatomic) IBOutlet UITextView *TextPlace;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PlaceonMap;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet RMMapView *MapPlace;
@property (weak, nonatomic) IBOutlet UIView *PlaceView;

@property (nonatomic,retain) NSString *PlaceName;
@property (nonatomic,retain) NSString *PlaceNameEn;
@property (nonatomic,retain) NSString *PlaceCityName;
@property (nonatomic,retain) NSString *PlaceCategory;
@property (nonatomic,retain) NSString *PlaceAbout;
@property (nonatomic,retain) NSString *PlaceAddress;
@property (nonatomic,retain) NSString *PlaceWeb;
@property (nonatomic,retain) NSString *PlaceTelephone;
@property (nonatomic,retain) CLLocation *PlaceLocation;
@property (nonatomic,retain) NSArray *Photos;
@property (nonatomic, retain) UIColor *Color;


@property (weak, nonatomic) IBOutlet UIImageView *hint;
@property (weak, nonatomic) IBOutlet UIButton *hide_button;


@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic,retain)IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *info_button;

@property (nonatomic, retain)IBOutlet UILabel *favText;
@property (nonatomic, retain)IBOutlet UIImageView *favImage;

//@property (weak, nonatomic) IBOutlet UIButton *locationButton;

-(IBAction)showLocation:(id)sender;
-(IBAction)openMail:(id)sender;
-(IBAction)ShowMap:(id)sender;
-(IBAction)hide_hint:(id)sender;



- (IBAction)InfoTouch:(UIButton *)sender;
- (IBAction)MovePlaceCard:(UISwipeGestureRecognizer *)sender;
- (IBAction)ScrollTap:(UITapGestureRecognizer *)sender;

@end

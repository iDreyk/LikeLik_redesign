//
//  SplashViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 11.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "LocalizationSystem.h"
@interface SplashViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>{
    CLLocationManager *locationManagerRegion;
    CLLocationManager *locationManager;
    UILocalNotification *localNotification;
    IBOutlet    UILabel *alertLabel;
    CLRegion *Dostoevskiy;
    CLLocation *Me;
}
@property (nonatomic,retain) IBOutlet UILocalNotification *localNotification;
@property(nonatomic, retain) IBOutlet UILabel  *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *LeftButton;
@property (weak, nonatomic) IBOutlet UIButton *RightButton;
@property (weak, nonatomic) IBOutlet UIImageView *Shade;
@property (weak, nonatomic) IBOutlet UIButton *fist;
@property (weak, nonatomic) IBOutlet UIImageView *maintitle;
@property (weak, nonatomic) IBOutlet UILabel *Firsttitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property(nonatomic, retain) CLLocationManager *locationManagerRegion;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,retain)IBOutlet UIAlertView *message;
@property (nonatomic,retain)MBProgressHUD *HUDfade;

@end

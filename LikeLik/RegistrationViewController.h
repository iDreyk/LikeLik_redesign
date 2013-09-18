//
//  ViewController.h
//  Registration
//
//  Created by Vladimir Malov on 08.07.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Vkontakte.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <CoreLocation/CoreLocation.h>
@interface RegistrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,VkontakteDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>{
    NSArray *array;
    NSString *day;
    NSString *month;
    NSString *year;
    IBOutlet UIButton *_loginB;
    Vkontakte *_vkontakte;
    CLLocationManager *locationManager;
    
}
@property (nonatomic,retain)NSString *LorR;
@property (nonatomic,retain)NSString *lang;
@property (retain,nonatomic) UITextField *Login;
@property (retain,nonatomic) UITextField *Password;
@property (retain,nonatomic) UITextField *Email;
@property (retain, nonatomic) UITextField *Confirm;
@property (weak, nonatomic) IBOutlet UITableView *RegistrationTable;
@property (weak, nonatomic) IBOutlet UILabel *SurpriseText;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UIDatePicker *BirthDayPicker;
@property (nonatomic,retain)NSString *Parent;
@property (nonatomic,retain)MBProgressHUD *HUDemailcheck;
@property (nonatomic,retain)MBProgressHUD *HUDpassword;
@property (nonatomic,retain)MBProgressHUD *HUDdone;
@property (nonatomic,retain)MBProgressHUD *HUDfade;
@property (nonatomic,retain)MBProgressHUD *HUDerror;
@property (nonatomic,retain)MBProgressHUD *HUDgoeswrong;
@property (nonatomic, retain)NSString *twitterName;
@property (nonatomic,retain)NSString *twitterid;
@property (nonatomic,retain)id FacebookUserInfo;
@property (nonatomic, retain) NSDictionary *VkontakteUserInfo;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;
-(IBAction)switchtoPicker:(id)sender;


-(NSString *)HUDStringLocalized:(id)JSON;
-(NSDictionary * )POSTRequestRegistration:(NSString *)Way;
-(void)SendRegistration:(NSString *)RegistrationWay;
//-(void)SendLogin:(NSString *)RegistrationWay;
//-(NSDictionary * )POSTRequestLogin:(NSString *)Way;

@end


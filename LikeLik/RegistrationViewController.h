//
//  RegistrationViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Vkontakte.h"
#import "SA_OAuthTwitterController.h"
@interface RegistrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,SA_OAuthTwitterControllerDelegate,VkontakteDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>{
    NSArray *array;
    NSString *day;
    NSString *month;
    NSString *year;
        IBOutlet UIButton *_loginB;
    Vkontakte *_vkontakte;
    SA_OAuthTwitterEngine				*_engine;
}
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
@property (nonatomic, retain)NSString *twitterName;
@property (nonatomic,retain)id FacebookUserInfo;
@property (nonatomic, retain) NSDictionary *VkontakteUserInfo;
-(IBAction)switchtoPicker:(id)sender;


-(NSString *)HUDStringLocalized:(id)JSON;
-(NSDictionary * )POSTRequest:(NSString *)Way;
-(void)Send:(NSString *)RegistrationWay;
@end

//
//  LoginViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 15.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vkontakte.h"
#import "SA_OAuthTwitterController.h"
@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,VkontakteDelegate,SA_OAuthTwitterControllerDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>{
    NSArray *array;
    IBOutlet UIButton *_loginB;
    Vkontakte *_vkontakte;
    SA_OAuthTwitterEngine				*_engine;
    
}

@property (weak, nonatomic) IBOutlet UITableView *LoginTable;
@property (retain,nonatomic) UITextField *Password;
@property (retain,nonatomic) UITextField *Email;
@property (weak, nonatomic) IBOutlet UILabel *SNetworkLabel;
@property (weak, nonatomic) IBOutlet UIButton *FaceBook;
@property (weak, nonatomic) IBOutlet UIButton *Vkontakte;
@property (weak, nonatomic) IBOutlet UIButton *Twitter;
@property (nonatomic,retain)IBOutlet NSString *Parent;
-(IBAction)SocialClicked:(UIButton *)sender;
- (IBAction)loginPressed:(id)sender;
- (void)refreshButtonState;
-(void)getUserInfo;
@end

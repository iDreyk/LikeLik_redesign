//
//  SupportViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "SupportViewController.h"
#import "AppDelegate.h"

@interface SupportViewController ()

@end

@implementation SupportViewController
@synthesize HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Support Screen"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    self.lang = [[NSString alloc] init];
    log([[NSUserDefaults standardUserDefaults] objectForKey:@"Language"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Русский"])
        self.lang = @"ru";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"English"])
        self.lang = @"en";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Deutsch"])
        self.lang = @"de";

    
    self.navigationItem.titleView=[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Support", nil)  AndColor:[InterfaceFunctions corporateIdentity]];
    self.Email.returnKeyType = UIReturnKeyNext;
    self.FeedBack.returnKeyType = UIReturnKeyDone;
    self.Email.delegate = self;
    
    self.Contactinformation.font = [AppDelegate OpenSansSemiBold:32];
    self.Email.font = [AppDelegate OpenSansRegular:28];
    self.FeedBack.font = [AppDelegate OpenSansRegular:28];
    
    UIButton *btn = [InterfaceFunctions done_button];
    [btn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.FeedBack.text = AMLocalizedString(@"Leave a feedback for us", nil);
    self.Contactinformation.text = AMLocalizedString(@"Contact information", nil);
    self.Email.placeholder = AMLocalizedString(@"Email or phone", nil);
    
    
    self.Email.backgroundColor = [UIColor clearColor];
    self.FeedBack.backgroundColor = [UIColor clearColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}


-(void)Done{
  //  NSDictionary *params;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    CLLocation *Me = [locationManager location];
  //  log([NSString stringWithFormat:@"Me = %@", Me);
    NSString *lat = [NSString stringWithFormat:@"%f",Me.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",Me.coordinate.longitude];
  //  log([NSString stringWithFormat:@"%@ %@",lat,lon);
    
    
    
    if (([self.Email.text length] > 0 || [self.FeedBack.text length] > 0) && (![self.FeedBack.text isEqualToString:AMLocalizedString(@"Leave a feedback for us", nil)] || [self.Email.text length]>0)) {
        NSDictionary *JsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: self.Email.text,@"name",self.FeedBack.text,@"note",lat,@"lat",lon,@"lon",nil];
    //    log([NSString stringWithFormat:@"%@",JsonDictionary);
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.likelik.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
     [httpClient defaultValueForHeader:@"Accept"];
    
    
        NSString *params = [NSString stringWithFormat:@"/api/v1/support/LeaveComment?lang=%@",_lang];
     //   log([NSString stringWithFormat:@"%@",params);
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:params parameters:JsonDictionary];
        
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation,
       id responseObject) {
      //   NSString *response = [operation responseString];
        // log([NSString stringWithFormat:@"response: [%@]",response);

         HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
         [self.navigationController.view addSubview:HUD];
         HUD.userInteractionEnabled = NO;
         HUD.mode = MBProgressHUDModeCustomView;
         HUD.removeFromSuperViewOnHide = YES;
         HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Your feedback is very important to us!", nil)];
         HUD.delegate = self;
         [HUD show:YES];
         [HUD hide:YES afterDelay:2];

         [self.navigationController popViewControllerAnimated:YES];
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       //  log([NSString stringWithFormat:@"error: %@", [operation error]);
         
         MBProgressHUD *HUDerror = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
         [self.navigationController.view addSubview:HUDerror];
         
         HUDerror.mode = MBProgressHUDModeCustomView;
         HUDerror.removeFromSuperViewOnHide = YES;
         HUDerror.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Something goes wrong", nil)];
         HUDerror.delegate = self;
         [HUDerror show:YES];
         [HUDerror hide:YES afterDelay:2];

         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     }];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

         [operation start];
    
    }

    
}


-(void)textviewBeginEditing:(NSNotification *)notification{
    // log([NSString stringWithFormat:@"123");

    if ([self.FeedBack.text isEqualToString:AMLocalizedString(@"Leave a feedback for us", nil)]) {
        self.FeedBack.text = @"";
    }
}


-(void)textviewEndEditing:(NSNotification *)notification{
    if ([self.FeedBack.text isEqualToString:@""]) {
        self.FeedBack.text = AMLocalizedString(@"Leave a feedback for us", nil);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.FeedBack]) {
        self.FeedBack.text = @"";
        
    }
    // log([NSString stringWithFormat:@"%@",textField);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.FeedBack] && [self.FeedBack.text length]==0) {
        self.FeedBack.text = AMLocalizedString(@"Leave a feedback for us", nil);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.Email]){
        [self.Email resignFirstResponder];
        [self.FeedBack becomeFirstResponder];
    }
    
    if ([textField isEqual:self.FeedBack])
        [self.FeedBack resignFirstResponder];
    return YES;
}

@end

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
    self.navigationItem.titleView=[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Support", nil)  AndColor:[InterfaceFunctions mainTextColor:6]];
    self.Email.returnKeyType = UIReturnKeyNext;
    self.FeedBack.returnKeyType = UIReturnKeyDone;
    self.Email.delegate = self;
    
    self.Contactinformation.font = [AppDelegate OpenSansSemiBold:30];
    self.Email.font = [AppDelegate OpenSansRegular:26];
    self.FeedBack.font = [AppDelegate OpenSansRegular:26];
    
    UIButton *btn = [AppDelegate done_button];
    [btn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.FeedBack.text = AMLocalizedString(@"Leave a feedback for us", nil);
    self.Contactinformation.text = AMLocalizedString(@"Contact information", nil);
    self.Email.placeholder = AMLocalizedString(@"Email or phone", nil);
    
    
    self.Email.backgroundColor = [UIColor clearColor];
    self.FeedBack.backgroundColor = [UIColor clearColor];
    //self.view = [InterfaceFunctions BackgroundColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}


-(void)Done{
    
    
    
    if (([self.Email.text length] > 0 || [self.FeedBack.text length] > 0) && (![self.FeedBack.text isEqualToString:AMLocalizedString(@"Leave a feedback for us", nil)] || [self.Email.text length]>0)) {
        NSDictionary *JsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: self.Email.text,@"name",self.FeedBack.text,@"note",nil];
        NSLog(@"%@",JsonDictionary);
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.likelik.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/api/v1/support/LeaveComment" parameters:JsonDictionary];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation,
       id responseObject) {
         NSString *response = [operation responseString];
         NSLog(@"response: [%@]",response);

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
         NSLog(@"error: %@", [operation error]);
         
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
    // NSLog(@"123");

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
    // NSLog(@"%@",textField);
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
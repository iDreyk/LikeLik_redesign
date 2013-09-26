//
//  PracticalInfoViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "ScrollinfoViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#import "CategoryViewController.h"
//@class SubText;

@interface UITextView ()
- (id)styleString; // make compiler happy
@end


@implementation SubText1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 1.5em"];
}
@end

@interface ScrollinfoViewController ()

@end

@implementation ScrollinfoViewController
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
    [self.view setBackgroundColor:[UIColor clearColor]];
#warning слетают фоны
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    if ([self.Parent  isEqualToString:@"About"]){
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"About Screen"];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
        self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"About", nil) AndColor:[InterfaceFunctions corporateIdentity]];
        NSString *url = @"http://www.likelik.com";
        NSURL *nsurl = [NSURL URLWithString:url];
        NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
        
        [self.Likelikcom loadRequest:nsrequest];
        [self.Likelikcom setScalesPageToFit:YES];
        [self.Likelikcom setUserInteractionEnabled:YES];
        [self.view addSubview:self.Likelikcom];
        self.Likelikcom.hidden = NO;
        
    }
    if ([self.Parent isEqualToString:@"Practical"]){
        self.Text.text = [NSString stringWithFormat:@"%@",[ExternalFunctions getPracticalInfoForCity:self.CityName]];
        self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Practical Info", nil) AndColor:[InterfaceFunctions corporateIdentity]];
        self.Text.hidden = NO;
        self.Text.font = [AppDelegate OpenSansRegular:28];
        self.Text.textColor = [UIColor whiteColor];
        self.Text.backgroundColor =  [UIColor clearColor];
        self.Text.editable = NO;


    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

@end

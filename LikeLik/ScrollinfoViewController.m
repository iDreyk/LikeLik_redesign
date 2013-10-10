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

    }
    return self;
}



-(void)viewWillDisappear:(BOOL)animated{
    //self.view.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    //self.view.hidden = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    self.view.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    if ([self.Parent  isEqualToString:@"About"]){

        self.webHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.webHUD];
        _webHUD.mode = MBProgressHUDAnimationFade;
        self.webHUD.removeFromSuperViewOnHide = YES;
        self.webHUD.delegate = self;
        
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
        self.ShadowView.backgroundColor = [UIColor blackColor];
        self.ShadowView.alpha = 0.4;
        self.Text.text = [NSString stringWithFormat:@"%@",[ExternalFunctions getPracticalInfoForCity:self.CityName]];
        self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Practical Info", nil) AndColor:[InterfaceFunctions corporateIdentity]];
        self.Text.hidden = NO;
        self.Text.font = [AppDelegate OpenSansRegular:28];
        self.Text.textColor = [UIColor whiteColor];
        self.Text.backgroundColor =  [UIColor clearColor];
        self.Text.editable = NO;

        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
        UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 568)];
        
        bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_blur",[[ExternalFunctions cityCatalogueForCity:self.CityName] objectForKey:@"city_EN"]]];
        bg2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_paralax",[[[ExternalFunctions cityCatalogueForCity:self.CityName] objectForKey:@"city_EN"] lowercaseString]]];
        
        [self.view addSubview:bg2];
        [self.view addSubview:bg];
        [self.view bringSubviewToFront:self.ShadowView];
        [self.view bringSubviewToFront:self.Text];

    }

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.webHUD show:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.webHUD hide:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webHUD hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

@end

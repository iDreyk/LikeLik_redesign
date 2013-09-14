//
//  AboutViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#import "SubText.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"About Screen"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
  //  self.view = [InterfaceFunctions backgroundView];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"About", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    _infoScroll.showsHorizontalScrollIndicator = YES;

    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    label.text =[NSString stringWithFormat:@"\n %@", [ExternalFunctions getAboutText]];
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor blackColor];
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
  //  CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 5000.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(7.0,0.0, 306.0,502.0);
    }
    else{
        label.frame = CGRectMake(7.0,0.0, 306.0, 412.0);
    }

 //   NSLog(@"%f",textViewSize.height);
    self.Title.font = [AppDelegate OpenSansSemiBold:32];
    self.Title.text = AMLocalizedString(@"About", nil);
    
    //self.text.font = [AppDelegate OpenSansSemiBold:32];
    //self.text.text = [NSString stringWithFormat:@"\n %@", [ExternalFunctions getAboutText]];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"640_1136 background-568h@2x"]];
    imageview.frame = CGRectMake(0.0, 0.0, 320.0, 548.0);
 //   NSLog(@"%@ %@",self.view,imageview);
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imageview];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

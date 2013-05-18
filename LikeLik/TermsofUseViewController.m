//
//  TermsofUseViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "TermsofUseViewController.h"
#import "AppDelegate.h"

#import "SubText.h"

@interface TermsofUseViewController ()

@end

@implementation TermsofUseViewController

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
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    //self.view = [InterfaceFunctions backgroundView];
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Terms of use", nil) AndColor:[InterfaceFunctions mainTextColor:6]];
     
    
    
    
    cataloguesPath = [[NSBundle mainBundle]pathForResource:@"appData" ofType:@"plist"];
    catalogues = [[NSMutableDictionary alloc]initWithContentsOfFile:cataloguesPath];
    
    self.Title.text = @"Terms Of Use";
    _InfoScroll.showsHorizontalScrollIndicator = NO;
    UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 512.0)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/2 green:0.5 blue:0.5 alpha:1];
//    UITextView *first =  [[UITextView alloc] initWithFrame:CGRectZero]; //;
//	first.backgroundColor = [UIColor clearColor];
//	first.font = [UIFont systemFontOfSize:12];
//	first.frame = CGRectMake(0,0,320,512.0);
//	first.textColor = [UIColor blackColor];
//    first.scrollEnabled = NO;
//    first.editable = NO;
    
    
    
    self.Title.font = [AppDelegate OpenSansSemiBold:32];
    self.Title.text = AMLocalizedString(@"Terms of use", nil);
    
    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    label.text = [NSString stringWithFormat:@"\n%@", [ExternalFunctions getAboutText]];
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor blackColor];
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 5000.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(7.0, 0.0, 306.0,502.0);
    }
    else{
        label.frame = CGRectMake(7.0, 0.0, 306.0, 412.0);
    }
    label.contentSize = CGSizeMake(320.0, textViewSize.height);
    self.Title.font = [AppDelegate OpenSansSemiBold:32];
    [self.view addSubview:label];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"640_1136 background-568h@2x"]];
    imageview.frame = CGRectMake(0.0, 0.0, 320.0, 548.0);
   // NSLog(@"%@ %@",self.view,imageview);
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imageview];
    [self.view addSubview:label];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

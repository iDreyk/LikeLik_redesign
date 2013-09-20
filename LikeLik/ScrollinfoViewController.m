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
@synthesize label;
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
#warning слетают фоны
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    self.CityLabel.text = [[NSString alloc] initWithFormat:@"\n%@",self.CityName];
    self.CityLabel.font = [AppDelegate OpenSansSemiBold:32];
    cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    catalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];

    _InfoScroll.showsHorizontalScrollIndicator = NO;
    UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 512.0)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/2 green:0.5 blue:0.5 alpha:1];
    
    label = [[SubText1 alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    
    if ([self.Parent  isEqualToString:@"About"]){
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"About Screen"];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
        self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"About", nil) AndColor:[InterfaceFunctions corporateIdentity]];
        label.text = [NSString stringWithFormat:@"\n %@", [ExternalFunctions getAboutText]];
    }
    if ([self.Parent isEqualToString:@"Terms"]){
        label.text = [NSString stringWithFormat:@"\n %@", [ExternalFunctions getAboutText]];
        [TestFlight passCheckpoint:@"TermsOfUse"];
        [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Terms of use Screen"];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];        
         self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Terms of use", nil) AndColor:[InterfaceFunctions corporateIdentity]];

    }
    if ([self.Parent isEqualToString:@"Practical"]){
        label.text = [NSString stringWithFormat:@"\n%@",[ExternalFunctions getPracticalInfoForCity:self.CityName]];
        self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Practical Info", nil) AndColor:[InterfaceFunctions corporateIdentity]];

    }
    
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 5000.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(14.0,0.0, 320.0,502.0);
    }
    else{
        label.frame = CGRectMake(14.0,0.0, 320.0, 412.0);
    }
    label.contentSize = CGSizeMake(320.0, textViewSize.height);
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"640_1136 background-568h@2x"]];
    imageview.frame = CGRectMake(0.0, 10.0, 320.0, 548.0);
//    NSLog(@"%@ %@",self.view,imageview);
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    //[self.view addSubview:imageview];
    [self.view addSubview:label];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, -44, 320, 568)];
    bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:bg];
    [self.view bringSubviewToFront:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

@end

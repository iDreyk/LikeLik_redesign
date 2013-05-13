//
//  AboutViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

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
    
    self.view = [InterfaceFunctions backgroundView];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    

    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"About", nil) AndColor:[InterfaceFunctions mainTextColor:6]];
     
    _infoScroll.showsHorizontalScrollIndicator = NO;

    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    label.text =[NSString stringWithFormat:@"\n %@", [ExternalFunctions getAboutText]];
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor blackColor];
    label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 5000.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(7.0,0.0, 306.0,502.0);
    }
    else{
        label.frame = CGRectMake(7.0,0.0, 306.0, 412.0);
    }
    label.contentSize = CGSizeMake(320.0, textViewSize.height);
    self.Title.font = [AppDelegate OpenSansSemiBold:32];
    self.Title.text = AMLocalizedString(@"About", nil);
     [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

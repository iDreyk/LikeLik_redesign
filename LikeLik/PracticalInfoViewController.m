//
//  PracticalInfoViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "PracticalInfoViewController.h"
#import "AppDelegate.h"

#import "SubText.h"

@interface PracticalInfoViewController ()

@end

@implementation PracticalInfoViewController

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
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Practical Info", nil) AndColor:[InterfaceFunctions mainTextColor:6]];

    self.CityLabel.text = [[NSString alloc] initWithFormat:@"\n%@",self.CityName];
    self.CityLabel.font = [AppDelegate OpenSansSemiBold:30];
    cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogues1.plist"];
    catalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];

    _InfoScroll.showsHorizontalScrollIndicator = NO;
    UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 512.0)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/2 green:0.5 blue:0.5 alpha:1];

    
    
    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    label.text = [[NSString alloc] initWithFormat:@"\n%@",[ExternalFunctions getPracticalInfoForCity:self.CityName]];
    label.font = [AppDelegate OpenSansRegular:26];
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
    
    [self.view addSubview:label];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

@end

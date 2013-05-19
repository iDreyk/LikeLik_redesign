//
//  StartTabBarViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 09.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "StartTabBarViewController.h"
#import "AppDelegate.h"

#import "AboutTableViewController.h"
#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
#define changetab             @"l27haasas7RU2dzVaQsadaQeSFfPoQQQQ"
#define setselectedindex             @"l27h7RU2dzVfP12aoQssda"
@interface StartTabBarViewController ()

@end

@implementation StartTabBarViewController

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

    [self setSelectedIndex:1];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Guides", nil) AndColor:[InterfaceFunctions NavBarColor]];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    [[self.viewControllers objectAtIndex:0] setTitle:AMLocalizedString(@"Featured", nil)];
    
    [[self.viewControllers objectAtIndex:1] setTitle:AMLocalizedString(@"Downloaded", nil)];
    
    [[self.viewControllers objectAtIndex:2] setTitle:AMLocalizedString(@"All Guides", nil)];
    
    [[self.viewControllers objectAtIndex:3] setTitle:AMLocalizedString(@"Special Series", nil)];
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    UIButton *btn = [InterfaceFunctions Pref_button];
    [btn addTarget:self action:@selector(Pref) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIButton *btn_left = [InterfaceFunctions Info_button];
    [btn_left addTarget:self action:@selector(Info) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
}

-(void)pref_dismiss{
    [self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"Tabbar Appear");
    [[self.viewControllers objectAtIndex:0] setTitle:AMLocalizedString(@"Featured", nil)];
    
    [[self.viewControllers objectAtIndex:1] setTitle:AMLocalizedString(@"Downloaded", nil)];
    
    [[self.viewControllers objectAtIndex:2] setTitle:AMLocalizedString(@"All Guides", nil)];
    
    [[self.viewControllers objectAtIndex:3] setTitle:AMLocalizedString(@"Special Series", nil)];
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Guides", nil) AndColor:[InterfaceFunctions NavBarColor]];
    
}

-(void)Pref{
    [self performSegueWithIdentifier:@"PrefSegue" sender:self];
}


-(void)Info{
    [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)search:(id)sender{
    
}

-(void)viewWillDisappear:(BOOL)animated{
   
    if([self isMovingFromParentViewController]){
   
        //    // NSLog(@"123");
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //specific stuff for being popped off stack
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{//performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"InfoSegue"]) {
    }
}

- (void)viewDidUnload {
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end

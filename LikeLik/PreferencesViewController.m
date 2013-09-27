//
//  PreferencesViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "PreferencesViewController.h"
#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
#import "ScrollinfoViewController.h"
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
static NSString *LorR=nil;
@interface PreferencesViewController ()

@end
//чтобы запущить
@implementation PreferencesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[NSString stringWithFormat:@"Settings Screen"]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    // [testflight passCheckpoint:@"Открыл stng"];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Settings", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    
    RegisterAndLogin = @[AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil)];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
        RegisterAndLogin = @[];
    Language = @[@"English",@"Русский",@"Deutsch",@"Japanese"];
    Measures = @[@"Miles",@"Kilometers"];
    Information = @[AMLocalizedString(@"About", nil),AMLocalizedString(@"Support", nil),AMLocalizedString(@"More LikeLik Apps", nil)];
    
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];//[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *back = [InterfaceFunctions done_button];
    [back  addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];

}

-(void)Back{
    [[NSNotificationCenter defaultCenter] postNotificationName:dismiss
                                                        object:self];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
     if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
        RegisterAndLogin = @[];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if([self isMovingFromParentViewController]){
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = [RegisterAndLogin count];
            break;
        case 1:
            number = [Language count];
            break;
        case 2:
            number = [Measures count];
            break;
        case 3:
            number = [Information count];
        default:
            break;
        }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch ([indexPath section]) {
        case 0:
        [cell addSubview:[InterfaceFunctions TableLabelwithText:[RegisterAndLogin objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions corporateIdentity_actb]];
            break;
        case 1:
        [cell addSubview:[InterfaceFunctions TableLabelwithText:[Language objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            break;
        case 2:
        [cell addSubview:[InterfaceFunctions TableLabelwithText: [NSString stringWithFormat:@"Display %@",[Measures objectAtIndex:[indexPath row]]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            break;
        case 3:
        [cell addSubview:[InterfaceFunctions TableLabelwithText:[Information objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions corporateIdentity_actb]];
            break;
        default:
            break;
    }
    
    
    
    if ([indexPath section] == 0 && [indexPath row] == 0)
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    if ([indexPath section] == 0 && [indexPath row] == 1)
        cell.accessoryType = UITableViewCellAccessoryNone;
    if ([indexPath section] == 1)
        if ([[defaults objectForKey:@"Language"] isEqualToString:[Language objectAtIndex:[indexPath row]]])
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    if ([indexPath section] == 2)

        if ([[defaults objectForKey:@"Measure"] isEqualToString:[Measures objectAtIndex:[indexPath row]]])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    cell.backgroundView = myBackgroundView;
    
    
    cell.selectedBackgroundView = [InterfaceFunctions CellBG];

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
	customView.alpha = 0.8;

	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.font = [AppDelegate OpenSansBoldwithSize:28];
	headerLabel.frame = CGRectMake(10,0,310,30);
	headerLabel.textColor = [UIColor whiteColor];
    customView.backgroundColor = [InterfaceFunctions corporateIdentity];
	if(section == 0) {
        headerLabel.text =  AMLocalizedString(@"Register and login", nil);
	}
	if(section ==1) {
		headerLabel.text =  AMLocalizedString(@"Language", nil);
	}
    if (section == 2) {
        headerLabel.text =  @"Measures";
    }
    if (section == 3) {
        headerLabel.text =  AMLocalizedString(@"About", nil);
    }
	[customView addSubview:headerLabel];
    
	return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
    if (section == 0)
        if ([RegisterAndLogin count]==0)
            return 0;

    
	return 30;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [AppDelegate LLLog:[NSString stringWithFormat:@"%d %d",[indexPath section],[indexPath row]);
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        LorR = @"Registration";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    if ([indexPath section] == 0 && [indexPath row] == 1) {
        LorR = @"Login";
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
//    if ([indexPath section] == 3 && [indexPath row] == 0) {
//        [self performSegueWithIdentifier:@"TermsofUse" sender:self];
//    }
    if ([indexPath section] == 3 && [indexPath row] == 0) {
        [self performSegueWithIdentifier:@"About" sender:self];
    }
    if ([indexPath section] == 3 && [indexPath row] == 1) {
        [self performSegueWithIdentifier:@"Support" sender:self];
    }
    if ([indexPath section] == 3 && [indexPath row] == 2) {
        [self performSegueWithIdentifier:@"MoreLikeLik" sender:self];
    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([indexPath section] == 1){
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"langChanged"];
            [AppDelegate LLLog:[NSString stringWithFormat:@"lngChanged - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"langChanged"]]];
            for (int i=0; i<[Language count]; i++)
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]].accessoryType = UITableViewCellAccessoryNone;
            [defaults setObject:[Language objectAtIndex:[indexPath row]] forKey:@"Language"];
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Русский"])
                LocalizationSetLanguage(@"ru");
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"English"])
                LocalizationSetLanguage(@"en");
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Deutsch"])
                LocalizationSetLanguage(@"de");
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Japanese"])
                LocalizationSetLanguage(@"ja");

        }
        
        if ([indexPath section] == 2){
            for (int i=0; i<[Measures count]; i++)
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:2]].accessoryType = UITableViewCellAccessoryNone;
            [defaults setObject:[Measures objectAtIndex:[indexPath row]] forKey:@"Measure"];
            
        }
    
    if ([indexPath section] == 1 || [indexPath section] == 2)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [defaults synchronize];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Settings", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    
    UIButton *back = [InterfaceFunctions done_button];
    [back  addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];

    
    RegisterAndLogin = @[AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil)];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
        RegisterAndLogin = @[];

    
    Language = @[@"English",@"Русский",@"Deutsch",@"Japanese"];
    Measures = @[@"Miles",@"Kilometers"];
    Information = @[AMLocalizedString(@"About", nil),AMLocalizedString(@"Support", nil),AMLocalizedString(@"More LikeLik Apps", nil)];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        RegistrationViewController *destination = [segue destinationViewController];
        destination.LorR = LorR;
    }
    if ([[segue identifier] isEqualToString:@"About"]) {
        ScrollinfoViewController *destination = [segue destinationViewController];
        destination.Parent = @"About";
    }
//    if ([[segue identifier] isEqualToString:@"TermsofUse"]) {
//        ScrollinfoViewController *destination = [segue destinationViewController];
//        destination.Parent = @"Terms";
//    }
//    
    //TermsofUse
}
@end

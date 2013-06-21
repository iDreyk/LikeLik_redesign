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

#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

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
    //[TestFlight passCheckpoint:@"Открыл stng"];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
     
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Settings", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    

    RegisterAndLogin = @[AMLocalizedString(@"Registration", nil),AMLocalizedString(@"Login", nil)];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
        RegisterAndLogin = @[];
    Language = @[@"English",@"Русский",@"Deutsch",@"Japanese"];
    Measures = @[@"Miles",@"Kilometers"];
//    [self.navigationController.navigationBar setBounds:CGRectMake(0.0, 0.0, 320.0, 70.0)];
//    [self.navigationController.navigationBar setFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)];
    
    
    
    
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];//[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *back = [InterfaceFunctions done_button];
    [back  addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];

}

-(void)Back{
    // NSLog(@"123");
    [[NSNotificationCenter defaultCenter] postNotificationName:dismiss
                                                        object:self];
    [self dismissViewControllerAnimated:YES completion:^{}];//dismissModalViewControllerAnimated:YES];
//    NSLog(@"%d",[self dismissViewControllerAnimated:YES completion:^{}]);
    //[self dismissViewControllerAnimated:YES completion:^{}];
    //[self dismissViewControllerAnimated:YES completion:^{}];
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
    // NSLog(@"123");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Registered"] isEqualToString:@"YES"])
        RegisterAndLogin = @[];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if([self isMovingFromParentViewController]){
//#warning для splash раскомментировать
        // [self.navigationController setNavigationBarHidden:YES animated:YES];
        //specific stuff for being popped off stack
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
      //      NSLog(@"123");
        [cell addSubview:[InterfaceFunctions TableLabelwithText:[RegisterAndLogin objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            break;
        case 1:
        [cell addSubview:[InterfaceFunctions TableLabelwithText:[Language objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            break;
        case 2:
        [cell addSubview:[InterfaceFunctions TableLabelwithText: [NSString stringWithFormat:@"Display %@",[Measures objectAtIndex:[indexPath row]]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
            break;
        default:
            break;
    }
    
    
    
    if ([indexPath section] == 0 && [indexPath row] == 0)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    if ([indexPath section] == 0 && [indexPath row] == 1)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
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
    //    nslog(@"%d %d",[indexPath section],[indexPath row]);
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
    }
    if ([indexPath section] == 0 && [indexPath row] == 1) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    

    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        if ([indexPath section] == 1){
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"langChanged"];
            
            for (int i=0; i<[Language count]; i++)
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]].accessoryType = UITableViewCellAccessoryNone;
            [defaults setObject:[Language objectAtIndex:[indexPath row]] forKey:@"Language"];
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Русский"]){
                LocalizationSetLanguage(@"ru");
                //[TestFlight passCheckpoint:@"SetRU"];
            }
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"English"]){
                LocalizationSetLanguage(@"en");
                //[TestFlight passCheckpoint:@"SetEn"];
            }
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Deutsch"]){
                LocalizationSetLanguage(@"de");
            }
            if ([[Language objectAtIndex:[indexPath row]] isEqualToString:@"Japanese"]){
                LocalizationSetLanguage(@"ja");
            }

        }
        
        if ([indexPath section] == 2){
            for (int i=0; i<[Measures count]; i++)
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]].accessoryType = UITableViewCellAccessoryNone;
            [defaults setObject:[Measures objectAtIndex:[indexPath row]] forKey:@"Measure"];
            
        }
        
    }
    else{
        
        if ([indexPath section] == 1){
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"langChanged"];
            NSLog(@"lngChanged - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"langChanged"]);
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
        
    }
    
    
    if ([indexPath section] == 1 || [indexPath section] == 2) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

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
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    if ([[segue identifier] isEqualToString:@"RegisterSegue"]) {
        PlaceViewController *destination =[segue destinationViewController];
        NSIndexPath *indexPath = [self.TablePlaces indexPathForSelectedRow];
        
        destination.PlaceCityName = self.CityNameText;
        switch ([indexPath section]) {
            case 0:
                destination.PlaceName  = [Rest objectAtIndex:[indexPath row]];
                destination.PlaceCategory =  @"Restaurant";
                break;
            case 1:
                destination.PlaceName = [Shopping objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Shopping";
                break;
            case 2:
                destination.PlaceName = [Entertainment objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Entertainment";
                break;
            case 3:
                destination.PlaceName = [Sport objectAtIndex:[indexPath row]];
                destination.PlaceCategory = @"Sport";
            default:
                break;
        }
    }
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        //    nslog(@"[[segue identifier] isEqualToString: SearchSegue");
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.CityNameText;
    }
     */
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
@end

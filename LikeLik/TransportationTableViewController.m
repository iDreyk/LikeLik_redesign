//
//  TransportationTableViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 23.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "TransportationTableViewController.h"
#import "TaxiViewController.h"
#import "TransportationViewController.h"
#import "AppDelegate.h"


@interface TransportationTableViewController ()

@end

@implementation TransportationTableViewController

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
    self.navigationItem.titleView =[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Transportation", nil) AndColor:[InterfaceFunctions mainTextColor:6]];
    self.navigationItem.backBarButtonItem = [AppDelegate back_button];

    taxi = [ExternalFunctions getTaxiInformationInCity:self.CityName];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = [InterfaceFunctions  backgroundView];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [taxi count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 1;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = [taxi count];
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;//@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
     UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(293,11, 22, 24)];
    switch (section) {
        case 0:
            [cell addSubview:[InterfaceFunctions TableLabelwithText:AMLocalizedString(@"Transportation", nil) AndColor:[InterfaceFunctions mainTextColor:1] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions actbwithColor:1]];
            break;
        case 1:
            [cell addSubview:[InterfaceFunctions TableLabelwithText:[[taxi objectAtIndex:row] objectForKey:@"name"] AndColor:[InterfaceFunctions taxiColor] AndFrame:CGRectMake(14.0, 0.0, 290, cell.center.y*2)]];
            [cell addSubview:[InterfaceFunctions actbTaxi]];
            break;
        default:
            break;
    }
    [cell addSubview:_actb];

    cell.textLabel.font = [AppDelegate OpenSansRegular:26];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    cell.backgroundView = myBackgroundView;
    
    cell.selectedBackgroundView = [AppDelegate SelectedCellBG];
   // cell.textLabel.highlightedTextColor = [AppDelegate color1withFlag:0];//SelectedCellColor:3];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    
    
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
	customView.alpha = 0.8;
	customView.backgroundColor = [UIColor grayColor];
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.frame = CGRectMake(10,0,310,30);
	headerLabel.textColor = [UIColor whiteColor];
	[customView addSubview:headerLabel];
	return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            [self performSegueWithIdentifier:@"ScrollSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"TaxiSegue" sender:self];
            break;
        default:
            break;
    }
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"TaxiSegue"]) {
        TaxiViewController *destination =[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destination.CityName = self.CityName;
        destination.TaxiName = [[taxi objectAtIndex:[indexPath row]] objectForKey:@"name"];
        destination.TaxiAbout = [[taxi objectAtIndex:[indexPath row]] objectForKey:@"name"];
        destination.Telephone = [[taxi objectAtIndex:[indexPath row]] objectForKey:@"telephone"];
        destination.Web = [[taxi objectAtIndex:[indexPath row]] objectForKey:@"web"];
        destination.color = [InterfaceFunctions taxiColor];
        destination.Photo = [[taxi objectAtIndex:[indexPath row]] objectForKey:@"photo"];
    }
    if ([[segue identifier] isEqualToString:@"ScrollSegue"]) {
        //    nslog(@"Check this");
        TransportationViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.CityName;
    }
}

@end

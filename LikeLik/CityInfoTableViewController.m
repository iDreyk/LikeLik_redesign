//
//  CityInfoTableViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "CityInfoTableViewController.h"
#import "VisualTourViewController.h"
#import "TransportationTableViewController.h"
#import "PracticalInfoViewController.h"
#import "AppDelegate.h"

@interface CityInfoTableViewController ()

@end

@implementation CityInfoTableViewController

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
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    nslog(@"CityInfoTableViewController City Name = %@",_cityName);

    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"City info", nil) AndColor:[InterfaceFunctions mainTextColor:6]];

    
    
    self.VisualCell.textLabel.text = AMLocalizedString(@"Visual Tour", nil);
    self.VisualCell.textLabel.font = [AppDelegate OpenSansRegular:28];
    self.VisualCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.VisualCell.textLabel.textColor = [InterfaceFunctions mainTextColor:1];
    self.VisualCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    
    
    
    self.TransportationCell.textLabel.text = AMLocalizedString(@"Transportation", nil);
    self.TransportationCell.textLabel.font = [AppDelegate OpenSansRegular:28];
    self.TransportationCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.TransportationCell.textLabel.textColor =[InterfaceFunctions mainTextColor:2];
    self.TransportationCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    

    
    
    
    self.PracticalCell.textLabel.text = AMLocalizedString(@"Practical Info", nil);
    self.PracticalCell.textLabel.font = [AppDelegate OpenSansRegular:28];
    self.PracticalCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.PracticalCell.textLabel.textColor = [InterfaceFunctions mainTextColor:3];
    self.PracticalCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark - Table view delegate

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    self.VisualCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.VisualCell.textLabel.highlightedTextColor = [InterfaceFunctions mainTextColor:1];
    self.VisualCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.VisualCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    
    
    self.TransportationCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.TransportationCell.textLabel.highlightedTextColor = [InterfaceFunctions mainTextColor:2];
    self.TransportationCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.TransportationCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    self.PracticalCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.PracticalCell.textLabel.highlightedTextColor = [InterfaceFunctions mainTextColor:3];
    self.PracticalCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.PracticalCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    
    
    
    NSIndexPath *tmp = [self.tableView indexPathForSelectedRow];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:tmp];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowVisualTour"]) {
        VisualTourViewController *destination =
        [segue destinationViewController];
        destination.CityName = self.cityName;
    }
    
    if ([[segue identifier] isEqualToString:@"ShowTransportation"]) {
        TransportationTableViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.cityName;
    }
    
    if ([[segue identifier] isEqualToString:@"ShowPracticalinfo"]) {
        PracticalInfoViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.cityName;
    }
}
- (void)viewDidUnload {
    [self setVisualCell:nil];
    [self setTransportationCell:nil];
    [self setPracticalCell:nil];
    [super viewDidUnload];
}
@end

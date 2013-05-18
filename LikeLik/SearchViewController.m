//
//  SearchViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "SearchViewController.h"
#import "PlaceViewController.h"
#import "AppDelegate.h"


#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSArray *Array;
static NSDictionary *Place;
@interface SearchViewController ()

@end

@implementation SearchViewController

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
    //1
    //23
    [super viewDidLoad];
    //    nslog(@"Hello!");
    //    nslog(@"CityName = %@",self.CityName);
    //[TestFlight passCheckpoint:@"Fav open"];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.SearchBar setShowsCancelButton:NO];
//#warning надо переделать под новый каталог
    self.PlacesArray = [ExternalFunctions getAllPlacesInCity:self.CityName];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Search", nil)  AndColor:[InterfaceFunctions mainTextColor:6]];
    
    
    self.SearchTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.SearchTable.backgroundView = [InterfaceFunctions backgroundView];//[[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"bg.png"]];
    Array = [NSArray arrayWithArray:self.PlacesArray];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.SearchTable deselectRowAtIndexPath:[self.SearchTable indexPathForSelectedRow] animated:YES];
}


-(void)viewDidDisappear:(BOOL)animated{
    [self searchBarCancelButtonClicked:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.PlacesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   [cell addSubview: [InterfaceFunctions TableLabelwithText:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
    
    cell.backgroundView = [InterfaceFunctions CellBG];
    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];

    [cell addSubview:[InterfaceFunctions goLabelCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Сategory"]]];
    [cell addSubview:[InterfaceFunctions actbwithCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Сategory"]]];

    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CellSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.navigationController.navigationBar.hidden)
        if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        [self.SearchTable setFrame:CGRectMake(self.SearchTable.frame.origin.x, self.SearchTable.frame.origin.y+44.0, 320.0, self.SearchTable.frame.size.height-44.0)];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
   
    NSIndexPath *indexPath = [self.SearchTable indexPathForSelectedRow];
    NSInteger row = [indexPath row];
    if ([[segue identifier] isEqualToString:@"CellSegue"]) {
        PlaceViewController *destinaton  = [segue destinationViewController];
        Place = [self.PlacesArray objectAtIndex:row];
        destinaton.PlaceName = [Place objectForKey:@"Name"];
        destinaton.PlaceCityName = self.CityName;
        destinaton.PlaceCategory =  [Place objectForKey:@"Сategory"];
        destinaton.Color = [InterfaceFunctions colorTextPlaceBackground:[[self.PlacesArray objectAtIndex:row] objectForKey:@"Сategory"]];
        destinaton.PlaceAbout = [Place objectForKey:@"About"];
        destinaton.PlaceAddress = [Place objectForKey:@"Address"];
        destinaton.PlaceWeb = [Place objectForKey:@"Web"];
        destinaton.PlaceTelephone = [Place objectForKey:@"Telephone"];
        destinaton.PlaceLocation = [Place objectForKey:@"Location"];
        destinaton.Photos = [Place objectForKey:@"Photo"];
        
    }
}



- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setSearchTable:nil];
    [super viewDidUnload];
}


#pragma mark search

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        [self.SearchTable setFrame:CGRectMake(self.SearchTable.frame.origin.x, self.SearchTable.frame.origin.y-44.0, 320.0, self.SearchTable.frame.size.height+44.0)];
    [self.SearchBar setShowsCancelButton:YES];
    searchBar.text = nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSArray *tmp;
    if (searchBar.text.length>0){//.text.length>0) {
        NSString *strSearchText =searchBar.text;
            NSLog(@"strSearchText = %@",strSearchText);
//#warning надо переделать под новый каталог
         tmp = [ExternalFunctions getAllPlacesInCity:self.CityName];
//#warning backspace неправильно работает
        NSMutableArray *ar = [NSMutableArray array];
        for (int i=0;i<[tmp count];i++) {
            NSString *strData = [[tmp objectAtIndex:i] objectForKey:@"Name"];
      //          NSLog(@"strData = %@ strSearchText = %@",strData, strSearchText);
             if ([[strData lowercaseString] rangeOfString:[strSearchText lowercaseString]].length>0) 
                [ar addObject:[tmp objectAtIndex:i]];
        }
        self.PlacesArray = ar;
        [self.SearchTable reloadData];
    }
    else{
        NSLog(@"Hello");
//#warning надо переделать под новый каталог
        self.PlacesArray = [ExternalFunctions getAllPlacesInCity:self.CityName];
        NSLog(@"tmp = %@", tmp);
        [self.SearchTable reloadData];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        [self.SearchTable setFrame:CGRectMake(self.SearchTable.frame.origin.x, self.SearchTable.frame.origin.y+44.0, 320.0, self.SearchTable.frame.size.height-44.0)];
    
    self.PlacesArray = Array;
    [self.SearchTable reloadData];
    [self.SearchBar setShowsCancelButton:NO];
    [self.SearchBar resignFirstResponder];
 
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //    nslog(@"SearchClicked");
    [self.SearchBar setShowsCancelButton:NO];
    [self.SearchBar resignFirstResponder];
    
}
@end

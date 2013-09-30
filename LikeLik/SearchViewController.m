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
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSArray *Array;
static NSArray *tmp;
static NSDictionary *Place;
CGRect oldRect;

#define tableLabelWithTextTag 87001
#define goLAbelTag 87002
#define arrowTag 87003
#define backgroundViewTag 87004
#define cellColorTag 87005
#define distanceTag 87006
#define announceTag 87007
#define labelColorTag 87008
#define buttonlabel1Tag 87009
#define checkTag 87010

#define backgroundTag 2442441
#define backgroundTag2 2442442

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
    
    //    log([NSString stringWithFormat:@"Hello!");
    //    log([NSString stringWithFormat:@"CityName = %@",self.CityName);
    // [testflight passCheckpoint:@"Search view"];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.SearchBar setShowsCancelButton:NO];
    //#warning надо переделать под новый каталог
    self.PlacesArray = [NSArray arrayWithArray:self.readyArray];//[ExternalFunctions getAllPlacesInCity:self.CityName];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Search", nil)  AndColor:[InterfaceFunctions corporateIdentity]];
    
    [self.SearchBar setTranslucent:YES];
    self.SearchTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //self.SearchTable.backgroundView = [InterfaceFunctions backgroundView];
    self.SearchTable.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];

    Array = [NSArray arrayWithArray:self.PlacesArray];
    
    tmp = [NSArray arrayWithArray:self.readyArray];//[ExternalFunctions getAllPlacesInCity:self.CityName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -66, 320, 568)];
    bg.tag = backgroundTag;
    UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -66, 320, 568)];
    bg2.tag = backgroundTag2;
    
    bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_blur",[[ExternalFunctions cityCatalogueForCity:self.CityName] objectForKey:@"city_EN"]]];
    bg2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_paralax",[[[ExternalFunctions cityCatalogueForCity:self.CityName] objectForKey:@"city_EN"] lowercaseString]]];
    
    [self.view addSubview:bg2];
    [self.view addSubview:bg];
    [self.view bringSubviewToFront:self.SearchBar];
    [self.view bringSubviewToFront:self.SearchTable];
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

#pragma mark - Keyboard events


-(void)keyboardHidden:(NSNotification *)note{
    self.SearchTable.frame = oldRect;
}

-(void)keyboardShown:(NSNotification *)note{
    oldRect = self.SearchTable.frame;
        CGRect keyboardFrame;
        [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
        CGRect ViewFrame = self.SearchTable.frame;
        ViewFrame.size.height -= keyboardFrame.size.height;
        self.SearchTable.frame = ViewFrame;
    
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
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    [cell addSubview: [InterfaceFunctions TableLabelwithText:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Name"] AndColor:[InterfaceFunctions colorTextCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Category"]] AndFrame:CGRectMake(14.0, 0.0, 260, cell.center.y*2)]];
//    
//    cell.backgroundView = [InterfaceFunctions CellBG];
//    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
//    
//    [cell addSubview:[InterfaceFunctions goLabelCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Category"]]];
//    [cell addSubview:[InterfaceFunctions actbwithCategory:[[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Category"]]];
//    
//    return cell;
//}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *category = [[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Category"];
    
    if (cell == nil) { // init the cell
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //202,148,78
        
        // плитка, на которую всё накладываем
        CGFloat x_dist = 3;
        CGFloat y_dist = 3;
        CGFloat cellWidth = 314;
        CGFloat cellHeight = 42;
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(x_dist, y_dist, cellWidth, cellHeight)];
        CALayer * back_layer = back.layer;
        back_layer.cornerRadius = 5;
        back.clipsToBounds = YES;
        back.tag = cellColorTag;
        back.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:back]; // добавили на cell
        
        
        cell.contentView.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer * imgLayer = back.layer;
        [imgLayer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imgLayer setBorderWidth:0.5f];
        [imgLayer setShadowColor: [[UIColor blackColor] CGColor]];
        [imgLayer setShadowOpacity:0.9f];
        [imgLayer setShadowOffset: CGSizeMake(0, 1)];
        [imgLayer setShadowRadius:3.0];
        // [imgLayer setCornerRadius:4];
        imgLayer.shouldRasterize = YES;
        
        // This tell QuartzCore where to draw the shadow so it doesn't have to work it out each time
        [imgLayer setShadowPath:[UIBezierPath bezierPathWithRect:imgLayer.bounds].CGPath];
        
        // This tells QuartzCore to render it as a bitmap
        [imgLayer setRasterizationScale:[UIScreen mainScreen].scale];
                
        // заголовок
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , cellWidth, 42)];
        CALayer *layer2 = nameLabel.layer;
        layer2.cornerRadius = 5;
        nameLabel.clipsToBounds = YES;
        nameLabel.tag = labelColorTag;
        [back addSubview:nameLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0,280, cell.center.y*2)];
        
        label.tag = tableLabelWithTextTag;
        label.font = [AppDelegate OpenSansSemiBold:35];
        label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, -0.1);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.highlightedTextColor = label.textColor;
        label.shadowColor = [InterfaceFunctions ShadowColor];
        label.shadowOffset = [InterfaceFunctions ShadowSize];
        [back addSubview:label];
    }
    UILabel * buttonlabel = (UILabel *)[cell viewWithTag:cellColorTag];
    buttonlabel.backgroundColor =[InterfaceFunctions colorTextCategory:category];
    
    UILabel *tableLabelWithText  = (UILabel *)[cell viewWithTag:tableLabelWithTextTag];
    tableLabelWithText.text = [[self.PlacesArray objectAtIndex:[indexPath row]] objectForKey:@"Name"];
 
    UILabel *label = (UILabel *)[cell viewWithTag:labelColorTag];
    label.backgroundColor = [InterfaceFunctions colorTextCategory:category];
        
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
        destinaton.PlaceCategory =  [Place objectForKey:@"Category"];
        destinaton.Color = [InterfaceFunctions colorTextPlaceBackground:[[self.PlacesArray objectAtIndex:row] objectForKey:@"Category"]];
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
    //    NSArray *tmp;
    if (searchBar.text.length>0){//.text.length>0) {
        NSString *strSearchText =searchBar.text;
    //    log([NSString stringWithFormat:@"strSearchText = %@",strSearchText);
        //#warning надо переделать под новый каталог
        //       tmp = [ExternalFunctions getAllPlacesInCity:self.CityName];
        //#warning backspace неправильно работает
        NSMutableArray *ar = [NSMutableArray array];
        for (int i=0;i<[tmp count];i++) {
            NSString *strData = [[tmp objectAtIndex:i] objectForKey:@"Name"];
            //          log([NSString stringWithFormat:@"strData = %@ strSearchText = %@",strData, strSearchText);
            if ([[strData lowercaseString] rangeOfString:[strSearchText lowercaseString]].length>0)
                [ar addObject:[tmp objectAtIndex:i]];
        }
        self.PlacesArray = ar;
        [self.SearchTable reloadData];
    }
    else{
        //    log([NSString stringWithFormat:@"Hello");
        //#warning надо переделать под новый каталог
        //self.PlacesArray = [ExternalFunctions getAllPlacesInCity:self.CityName];
        //log([NSString stringWithFormat:@"tmp = %@", tmp);
        self.PlacesArray = tmp;
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
    //    log([NSString stringWithFormat:@"SearchClicked");
    [self.SearchBar setShowsCancelButton:NO];
    [self.SearchBar resignFirstResponder];
    
}
@end

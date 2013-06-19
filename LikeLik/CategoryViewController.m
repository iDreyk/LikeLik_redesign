//
//  CategoryViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 30.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "AroundMeViewController.h"
#import "CityInfoTableViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "FavViewController.h"
#import "AboutTableViewController.h"
#import "PlacesByCategoryViewController.h"
#import "VisualTourViewController.h"
#import "TransportationTableViewController.h"
#import "PracticalInfoViewController.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    CLLocation *Me = [_locationManager location];
    
    self.Table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:[[NSString alloc] initWithFormat:@"Go&Use %@",self.Label] AndColor:[InterfaceFunctions corporateIdentity]];

    self.CityName.text = self.Label;
    self.CityName.font = [AppDelegate OpenSansSemiBold:60];
    self.CityName.textColor = [UIColor whiteColor];
    self.CityImage.image =  [UIImage imageWithContentsOfFile:self.Image];
    
    self.CellArray = @[@"Around Me", @"Restaurants",@"Night life",@"Shopping",@"Culture",@"Leisure", @"Beauty", @"Hotels",@"Favorites", @"Visual Tour", @"Transportation",@"Practical Info"];
    
    self.SegueArray = @[@"AroundmeSegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"CategorySegue",@"FavoritesSegue",@"VisualtourSegue",@"TransportationSegue",@"PracticalinfoSegue"];

    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    self.Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btn = [InterfaceFunctions search_button];
    [btn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *city = [[ExternalFunctions cityCatalogueForCity:self.CityName.text] objectForKey:@"city_EN"];
    if ([ExternalFunctions isDownloaded:city]) {
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
        
        CLLocation *oldLocation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"Изменение расстояния: %f",[Me distanceFromLocation:oldLocation]);
        
        if ([Me distanceFromLocation:oldLocation] > 100 || [[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"around %@",city]] == NULL) {
            NSLog(@"in if");
            [_locationManager stopUpdatingLocation];
            [[NSUserDefaults standardUserDefaults] setObject:Me forKey:@"location"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^ {
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[ExternalFunctions getPlacesAroundMyLocationInCity:self.CityName.text]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                [defaults setObject:data forKey:[[NSString alloc] initWithFormat:@"around %@",city]];
                
                NSLog(@"Finished work in background");
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    NSLog(@"Back on main thread");
                });
            });
        }
    }
    
    
}

-(void)search:(id)sender{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
}

-(void)viewDidAppear:(BOOL)animated{
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.Table deselectRowAtIndexPath:[self.Table indexPathForSelectedRow] animated:YES];
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
    return [self.CellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundView = [InterfaceFunctions CellBG];
    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    NSString *text = AMLocalizedString([self.CellArray objectAtIndex:[indexPath row]], nil);
    if ([indexPath row]<8 && [indexPath row]!=0) {
        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions mainTextColor:[indexPath row]+1]]];
        [cell addSubview:[InterfaceFunctions actbwithColor:[indexPath row]]];//actbwithColor:[indexPath row]+1]];
    }
    else{
        [cell addSubview:[InterfaceFunctions mainTextLabelwithText:text AndColor:[InterfaceFunctions corporateIdentity]]];
        [cell addSubview:[InterfaceFunctions corporateIdentity_actb]];
    }
    return cell;
}
#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:[self.SegueArray objectAtIndex:[indexPath row]] sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.Table indexPathForSelectedRow];
     NSInteger row = [indexPath row];
    
    if ([[segue identifier] isEqualToString:@"AroundmeSegue"]) {
        AroundMeViewController *destination =
        [segue destinationViewController];
        destination.CityNameText = self.Label;
        destination.Image = self.Image; 
    }
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        PlacesByCategoryViewController *destination =[segue destinationViewController];
        destination.CityName = self.Label;
        destination.Category = [self.CellArray objectAtIndex:row];
        destination.Image = self.Image;
    }

    if ([[segue identifier] isEqualToString:@"FavoritesSegue"]) {
        FavViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"VisualtourSegue"]) {
        VisualTourViewController *destination =
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"TransportationSegue"]) {
        TransportationTableViewController *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    if ([[segue identifier] isEqualToString:@"PracticalinfoSegue"]) {
        PracticalInfoViewController  *destination = [segue destinationViewController];
        [segue destinationViewController];
        destination.CityName = self.Label;
    }
    
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]){
        SearchViewController *destinaton  = [segue destinationViewController];
        destinaton.CityName = self.Label;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)updateOffsets {
    
    CGFloat yOffset   = self.Table.contentOffset.y;
    CGFloat threshold = self.Table.frame.size.height - self.Table.frame.size.height;
    
    if (yOffset > -threshold && yOffset < 0) {
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,-yOffset,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
    }
    else if (yOffset < 0) {
        self.CityImage.frame = CGRectMake(0,-44.0,320.0,152.0-yOffset + floorf(threshold / 2.0));
        
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0-(yOffset),self.CityName.frame.size.width,self.CityName.frame.size.height);
        
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,-yOffset,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
    }
    else {
        self.CityName.frame = CGRectMake(self.CityName.frame.origin.x,4.0,self.CityName.frame.size.width,self.CityName.frame.size.height);
        self.GradientUnderLabel.frame = CGRectMake(self.GradientUnderLabel.frame.origin.x,0.0,self.GradientUnderLabel.frame.size.width,self.GradientUnderLabel.frame.size.height);
        
    }
    self.CityImage.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateOffsets];
}

@end

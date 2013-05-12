//
//  StartViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "StartViewController.h"
#import "StartTableCell.h"

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


#import "CategoryViewController.h"
#define dismiss             @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface StartViewController ()

@end

@implementation StartViewController

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
    

    [self.navigationController setNavigationBarHidden:NO animated:NO];
   

    _CityLabels = [ExternalFunctions getDownloadedCities:1];
    _backCityImages = [ExternalFunctions getDownloadedCities:0];
    
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
    
}

-(void)pref_dismiss{

    [self viewDidAppear:YES];
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"123");
    NSInteger tabindex = self.tabBarController.selectedIndex;
//    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    
    if (tabindex == 0) { //выбраны featured
 
        _CityLabels = [ExternalFunctions getFeaturedCities:1];
        _backCityImages = [ExternalFunctions getFeaturedCities:0];
    }
    
    
    if (tabindex == 1) { //выбраны downloaded
        NSLog(@"Hello");
        _CityLabels = [ExternalFunctions getDownloadedCities:1];
        _backCityImages = [ExternalFunctions getDownloadedCities:0];

    }
    
    if (tabindex == 2) { //выбраны все гайды
        
        _CityLabels = [ExternalFunctions getAllCities:1];
        _backCityImages = [ExternalFunctions getAllCities:0];
    }
    
    if (tabindex == 3) {//Специальная серия
    
        _CityLabels = [ExternalFunctions getSpecialCities:1];
        _backCityImages = [ExternalFunctions getSpecialCities:0];
    }
    NSLog(@"StartView Appear");

    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_CityLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    static NSString *CellIdentifier = @"StartTableCell";
    StartTableCell *cell;
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    cell.CityLabel.font = [AppDelegate OpenSansSemiBold:60];
    cell.CityLabel.text  = _CityLabels[row];
    cell.CityLabel.textColor = [UIColor whiteColor];
    cell.BackCityImage.image = [UIImage imageNamed:_backCityImages[row]];
    [cell addSubview:[InterfaceFunctions standartAccessorView]];
    
//    if ([indexPath row]+1 == [_CityLabels count] ) {
//        [cell.layer setShadowOpacity:24.4];
//        [cell.layer setShadowRadius:5];
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tabIndex = self.tabBarController.selectedIndex;
    if(tabIndex != 1)
        [self ShowAlertView];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger row = [indexPath row];
    
    
    //    nslog(@"%d",self.tabBarController.selectedIndex);
    CategoryViewController *destination =
    [segue destinationViewController];
    
    destination.Label = _CityLabels[row];
    destination.Image = _backCityImages[row];
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"Select %@",_CityLabels[row]]];
}

-(void)ShowAlertView{
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Покупка"
//                                                          message:@"Вы собираетесь приобрести каталог LikeLik стоимость 299р."
//                                                         delegate:self
//                                                cancelButtonTitle:@"Спасибо, не хочу"
//                                                otherButtonTitles:@"Ok",nil];
      //  [message show];
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
        //[TestFlight passCheckpoint:@"buying"];
    }
    else{
            NSLog(@"Purchased");
        NSLog(@"Отказался от покупки");
    }
}

@end

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
#define likelikurl @"http://likelik.net/docs/"
#define catalogue @"Catalogues"


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


-(void)viewDidAppear:(BOOL)animated{
  //  NSLog(@"123");
    NSInteger tabindex = self.tabBarController.selectedIndex;
//    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    
    if (tabindex == 0) { //выбраны featured
 
        _CityLabels = [ExternalFunctions getFeaturedCities:1];
        _backCityImages = [ExternalFunctions getFeaturedCities:0];
    }
    
    
    if (tabindex == 1) { //выбраны downloaded
       // NSLog(@"Hello");
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
  //  NSLog(@"StartView Appear");

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
    cell.BackCityImage.image = [UIImage imageWithContentsOfFile:_backCityImages[row]];
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
  //  NSLog(@"перешёл на экран");
    CategoryViewController *destination =
    [segue destinationViewController];
    
    destination.Label = _CityLabels[row];
    destination.Image = _backCityImages[row];
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"Select %@",_CityLabels[row]]];
    
    if (![ExternalFunctions isDownloaded:_CityLabels[row]]) {
      
        if ([_CityLabels[row] isEqualToString:@"Moscow"] ||
            [_CityLabels[row] isEqualToString:@"Moskau"] ||
            [_CityLabels[row] isEqualToString:@"Москва"]) {
            [self AFdownload:@"Moscow"];
        }
        else if ([_CityLabels[row] isEqualToString:@"Вена"] ||
                 [_CityLabels[row] isEqualToString:@"Vienna"] ||
                 [_CityLabels[row] isEqualToString:@"Wien"]) {
            [self AFdownload:@"Vienna"];
        }
    }

    
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








////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) AFdownload : (NSString *) filename{
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.HUDfade.mode = MBProgressHUDAnimationFade;
    self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
        [self.HUDfade show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@.zip",likelikurl,filename];
    NSString *zipFile = [[NSString alloc] initWithFormat:@"%@.zip",filename];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:zipFile];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{}];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        [self DownloadSucceeded:filename];
        NSLog(@"всё сделано");
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark@2x.png"]];
        [self.HUDfade hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        NSLog(@"Error occured");
        [self DownloadError:error.description];
        [self.HUDfade hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [operation start];
    
    //Setup Upload block to return progress of file upload
    [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToRead) { float progress = totalBytesWritten / (float)totalBytesExpectedToRead;
        NSLog(@"Download Percentage: %f %%", progress*100);
        int result = (int)floorf(progress*100);
        
        self.HUDfade.labelText = [NSString stringWithFormat:@"%d %%",result];
    }];
    
}

- (void) DownloadSucceeded:(NSString *)fileName {
    NSString *zipFile = [[NSString alloc] initWithFormat:@"%@.zip",fileName];
    NSString *newCataloguePath = [[NSString alloc]initWithFormat:@"%@/%@/catalogue.plist",[ExternalFunctions docDir],fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:zipFile];
    [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    [ExternalFunctions unzipFileAt:path ToDestination:[paths objectAtIndex:0]];
    NSString *crapPath = [[ExternalFunctions docDir]stringByAppendingPathComponent:@"__MACOSX"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:crapPath error:nil];
    
    NSString *cataloguesPath = [[ExternalFunctions docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    
    NSMutableArray *catalogueArray = [[NSMutableArray alloc] initWithContentsOfFile:cataloguesPath];
    NSArray *newCatalogues = [[NSArray alloc] initWithContentsOfFile:newCataloguePath];
    NSDictionary *temp;
    
    for (int i = 0; i < [newCatalogues count]; i++) {
        if ([[[newCatalogues objectAtIndex:i] objectForKey:@"city_EN"] isEqualToString:fileName]) {
            temp = [newCatalogues objectAtIndex:i];
        }
    }
    for (int i = 0; i < [catalogueArray count]; i++) {
        if ([[[catalogueArray objectAtIndex:i] objectForKey:@"city_EN"] isEqualToString:fileName]) {
            [catalogueArray removeObjectAtIndex:i];
        }
    }
    
    [catalogueArray addObject:temp];
    
    [[NSFileManager defaultManager] removeItemAtPath:cataloguesPath error:nil];
    
    [catalogueArray writeToFile:cataloguesPath atomically:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:catalogueArray forKey:catalogue];
    
    [ExternalFunctions addCityToDownloaded:fileName];
}

- (NSString *) DownloadError:(NSString *)error{
    NSLog(@"error = %@",error);
    return error;
}

@end

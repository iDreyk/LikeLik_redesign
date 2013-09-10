//
//  StartViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "StartViewController.h"
#import "StartTableCell.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AFNetworking.h"
#import "Reachability.h"
#import "AFDownloadRequestOperation.h"
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#import "CategoryViewController.h"
#import "AFJSONRequestOperation.h"

#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define dismiss                 @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
#define likelikurlwifi_4        @"http://likelik.net/ios/docs/4/" //docs
#define likelikurlwifi_5        @"http://likelik.net/ios/docs/5/" //docs
#define likelikurlcell_4        @"http://likelik.net/ios/cell/4/"
#define likelikurlcell_5        @"http://likelik.net/ios/cell/5/"
#define catalogue @"Catalogues"
#define FADE_TAG 66484
#define LABELTAG 44324
#define THUNDER_TAG 123123

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define backgroundTag 2442441
NSInteger PREV_ROW = 0;
static bool REVERSE_ANIM = false;
static BOOL JUST_APPEAR = YES;

@interface StartViewController ()

@end

@implementation StartViewController
@synthesize label,special_series;
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
    JUST_APPEAR = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    _CityLabels = [ExternalFunctions getAllCities:1];
    _backCityImages = [ExternalFunctions getAllCities:0];
    
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/4, 0.0, 0.0)];
    special_series = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128.0, 128.0)];
//    [label setText:AMLocalizedString(@"Special Annotation", nil)];
//    label.numberOfLines = 0;
//    [label sizeToFit];
//    [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
//    label.tag = LABELTAG;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[AppDelegate OpenSansRegular:32]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.hidden = YES;
    [label setText:AMLocalizedString(@"Special Annotation", nil)];
    label.numberOfLines = 0;
    [label sizeToFit];
    [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
    
    
    
    special_series.tag = THUNDER_TAG;
    [special_series setImage:[UIImage imageNamed:@"512x512 special Series"]];
    [special_series setAlpha:0.7];
    special_series.hidden = YES;
    [self.view addSubview:special_series];
    [self.view addSubview:label];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
    
}



-(void)pref_dismiss{

    [self viewDidAppear:YES];

}


-(void)viewDidAppear:(BOOL)animated{
    //  NSLog(@"loglog");
    [label setText:AMLocalizedString(@"Special Annotation", nil)];
    
    CGPoint temp = self.view.center;
    temp.y -= 80;
    [special_series setCenter:temp];
    
    NSInteger tabindex = self.tabBarController.selectedIndex;
    //    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    
    if (tabindex == 0) { //выбраны featured
        
        //        _CityLabels = [ExternalFunctions getFeaturedCities:1];
        //        _backCityImages = [ExternalFunctions getFeaturedCities:0];
        _CityLabels = [ExternalFunctions getAllCities:1];
        _backCityImages = [ExternalFunctions getAllCities:0];
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
    JUST_APPEAR = YES;

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
    if ( [self.CityLabels count] == 0) {
        label.hidden= NO;
        special_series.hidden=NO;
    }
    else{
        label.hidden = YES;
        special_series.hidden = YES;
    }
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
    cell.BackCityImage.image = _backCityImages[row];//[UIImage imageWithContentsOfFile:_backCityImages[row]];
    [cell.contentView addSubview:[InterfaceFunctions standartAccessorView]];
    
    //    if ([indexPath row]+1 == [_CityLabels count] ) {
    //        [cell.layer setShadowOpacity:24.4];
    //        [cell.layer setShadowRadius:5];
    //    }
    
    
    //cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    if(PREV_ROW > row)
        REVERSE_ANIM = true;
    else
        REVERSE_ANIM = false;
    
    PREV_ROW = row;
    if(!JUST_APPEAR){
    UIView *myView = [[cell subviews] objectAtIndex:0];
    CALayer *layer = myView.layer;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/3, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/3, 1, 0, 0);
    }
    
    layer.transform = rotationAndPerspectiveTransform;
    
    
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.55];
    //[cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    if(!REVERSE_ANIM){
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/3, 1, 0, 0);
    }
    else{
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/3, 1, 0, 0);
    }
    layer.transform = rotationAndPerspectiveTransform;
    [UIView commitAnimations];
}

    return cell;
}

#pragma mark - Table view delegate

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] > 1) {
        return nil;
    }
    
    return indexPath;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(JUST_APPEAR)
        JUST_APPEAR = NO;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(!JUST_APPEAR)
//        JUST_APPEAR = NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"TOUCHED!");
    NSInteger tabIndex = self.tabBarController.selectedIndex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(tabIndex != 1 && ![ExternalFunctions isDownloaded:_CityLabels[[indexPath row]]]){
        [defaults setValue:[NSNumber numberWithInt:[indexPath row]] forKey:@"row"];
        [self ShowAlertView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}

- (UIImage*) blur:(UIImage*)theImage withFloat:(float)blurSize
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurSize] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(blurSize, 0, [inputImage extent].size.width - 2*blurSize, [inputImage extent].size.height)];
    
    //return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    return [[self class] scaleIfNeeded:cgImage];
}

+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
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
    
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    UIImageView *imback = (UIImageView *)[myDelegate.window viewWithTag:backgroundTag];
    imback.backgroundColor = [UIColor blackColor];
    imback.image = [self blur:[UIImage imageWithContentsOfFile:[ExternalFunctions larkePictureOfCity:destination.Label]] withFloat:15.0f];
//    NSLog(@"%@",imback);
    

    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"Select %@",_CityLabels[row]]];
}

-(NSString *)getContentLenght:(NSURLResponse *)response {
    int a;
    NSString *json = [response description];
    NSString *search = @"Length\" = ";
    NSString *sub = [json substringFromIndex:NSMaxRange([json rangeOfString:search])];
    for (int i = 0; [sub characterAtIndex:i] != ';'; i++) {
        a = i+1;
    }
    
    NSString *finish = [sub substringToIndex:a];
    unsigned long long ullvalue = strtoull([finish UTF8String], NULL, 0)/1024/1024;
    NSString *returnString = [NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:ullvalue]];
    return returnString;
}

- (NSString *)retrieveFileSizeFromServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger row = [[defaults objectForKey:@"row"] integerValue];
    Reachability *reach = [Reachability reachabilityWithHostname:@"likelik.net"];
    NSURL *aURL;
    
    if ([reach isReachable]) {
        if ([reach isReachableViaWiFi]) {
            // On WiFi
            if ([_CityLabels[row] isEqualToString:@"Moscow"] ||
                [_CityLabels[row] isEqualToString:@"Moskau"] ||
                [_CityLabels[row] isEqualToString:@"Москва"]) {
                
                if(IS_IPHONE_5 == 1) {
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlwifi_5,@"Moscow.zip"]];
                }
                else {
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlwifi_4,@"Moscow.zip"]];
                }
            }
            else if ([_CityLabels[row] isEqualToString:@"Вена"] ||
                     [_CityLabels[row] isEqualToString:@"Vienna"] ||
                     [_CityLabels[row] isEqualToString:@"Wien"]) {
                
                if(IS_IPHONE_5 == 1) {
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlwifi_5,@"Vienna.zip"]];
                }
                else {
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlwifi_4,@"Vienna.zip"]];
                }
            }
            
        //    NSLog(@"Downloading via Wi-Fi");
        }
        else {
            // On Cell
            
            if ([_CityLabels[row] isEqualToString:@"Moscow"] ||
                [_CityLabels[row] isEqualToString:@"Moskau"] ||
                [_CityLabels[row] isEqualToString:@"Москва"]) {
                
                if(IS_IPHONE_5 == 1)
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlcell_5,@"Moscow.zip"]];
                else
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlcell_4,@"Moscow.zip"]];
            }
            else if ([_CityLabels[row] isEqualToString:@"Вена"] ||
                     [_CityLabels[row] isEqualToString:@"Vienna"] ||
                     [_CityLabels[row] isEqualToString:@"Wien"]) {
                
                if(IS_IPHONE_5 == 1)
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlcell_5,@"Vienna.zip"]];
                else
                    aURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",likelikurlcell_4,@"Vienna.zip"]];
            }
            
           // NSLog(@"Downloading via cell network");
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL];
        [request setHTTPMethod:@"HEAD"];
        
        NSURLResponse *response = nil;
      //  NSError *err = nil;
        
        //NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        return [self getContentLenght:response];
    }
    return @"done";
}

-(void)ShowAlertView{
    //NSString *str = [NSString stringWithFormat:@"%@ %@ Mb",AMLocalizedString(@"You are up to download LikeLik Catalogue", nil),[self retrieveFileSizeFromServer]];
    NSString *str = AMLocalizedString(@"You are up to download LikeLik Catalogue", nil);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Download", nil)
                                                      message:str
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"Next time", nil)
                                            otherButtonTitles:@"Ok",nil];
    [message show];
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
        for (UIView *subViews in self.navigationController.view.subviews){
            if(subViews.tag == FADE_TAG)
                [subViews removeFromSuperview];
        }
        //[TestFlight passCheckpoint:@"buying"];
    }
    else{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger row = [[defaults objectForKey:@"row"] integerValue];
        Reachability *reach = [Reachability reachabilityWithHostname:@"likelik.net"];
        
        if ([reach isReachable]) {
            if ([reach isReachableViaWiFi]) {
                // On WiFi
                if ([_CityLabels[row] isEqualToString:@"Moscow"] ||
                    [_CityLabels[row] isEqualToString:@"Moskau"] ||
                    [_CityLabels[row] isEqualToString:@"Москва"]) {
                    
                    if(IS_IPHONE_5 == 1)
                        [self AFdownload:@"Moscow" fromURL:likelikurlwifi_5];
                    else
                        [self AFdownload:@"Moscow" fromURL:likelikurlwifi_4];
                }
                else if ([_CityLabels[row] isEqualToString:@"Вена"] ||
                         [_CityLabels[row] isEqualToString:@"Vienna"] ||
                         [_CityLabels[row] isEqualToString:@"Wien"]) {
                    
                    if(IS_IPHONE_5 == 1)
                        [self AFdownload:@"Vienna" fromURL:likelikurlwifi_5];
                    else
                        [self AFdownload:@"Vienna" fromURL:likelikurlwifi_4];
                }
                
       //         NSLog(@"Downloading via Wi-Fi");
            }
            else if (![ExternalFunctions isDownloaded:_CityLabels[row]]) {
                // On Cell
                
                if ([_CityLabels[row] isEqualToString:@"Moscow"] ||
                    [_CityLabels[row] isEqualToString:@"Moskau"] ||
                    [_CityLabels[row] isEqualToString:@"Москва"]) {
                    
                    if(IS_IPHONE_5 == 1)
                        [self AFdownload:@"Moscow" fromURL:likelikurlcell_5];
                    else
                        [self AFdownload:@"Moscow" fromURL:likelikurlcell_4];
                }
                else if ([_CityLabels[row] isEqualToString:@"Вена"] ||
                         [_CityLabels[row] isEqualToString:@"Vienna"] ||
                         [_CityLabels[row] isEqualToString:@"Wien"]) {
                    
                    if(IS_IPHONE_5 == 1)
                        [self AFdownload:@"Vienna" fromURL:likelikurlcell_5];
                    else
                        [self AFdownload:@"Vienna" fromURL:likelikurlcell_4];
                }
                
          //      NSLog(@"Downloading via cell network");
            }
            
        } else {
            // Isn't reachable
    //        NSLog(@"Isn't reachable");
            self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:self.HUDfade];
          //  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
            self.HUDfade.mode = MBProgressHUDModeCustomView;
            self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
            [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds) onTarget:self withObject:nil animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
//            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tabBarController.selectedIndex == 1)
        return YES;
    else
        return NO;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [ExternalFunctions deleteCityCatalogue:[_CityLabels objectAtIndex:[indexPath row]]];
    _CityLabels = [ExternalFunctions getDownloadedCities:1];
    _backCityImages = [ExternalFunctions getDownloadedCities:0];
    [tableView reloadData];
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) AFdownload : (NSString *) filename fromURL : (NSString *) likelikUrl{
    
    
    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.HUDfade.mode = MBProgressHUDAnimationFade;
    self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Download"] isEqualToString:@"1"])
        [self.HUDfade show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@.zip",likelikUrl,filename];
    NSString *zipFile = [[NSString alloc] initWithFormat:@"%@.zip",filename];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:zipFile];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self DownloadSucceeded:filename];
        
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark@2x"]];
        self.HUDfade.mode = MBProgressHUDModeCustomView;
        self.HUDfade.labelText = AMLocalizedString(@"Operation succeeded", nil);
        [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                                onTarget:self withObject:nil animated:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.HUDfade.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross2@2x"]];
        self.HUDfade.mode = MBProgressHUDModeCustomView;
        self.HUDfade.labelText = AMLocalizedString(@"Download error", nil);
        [self.HUDfade showWhileExecuting:@selector(waitForTwoSeconds)
                                onTarget:self withObject:nil animated:YES];
        
        [self DownloadError:error];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [operation start];
    double CurrentTime1 = CACurrentMediaTime();
    
    //Setup Upload block to return progress of file upload
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        BOOL i = YES;
        double currentTime = 0.0;
        if (i) {
            currentTime = CurrentTime1;
            i = NO;
        }
        
        double currentTime2 = CACurrentMediaTime();
        
        float progress = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile * 100;
        //
        //        int result = (int)floorf(progress*100);
        double speed = (totalBytesRead / (currentTime2 - currentTime));
        double bytes_left = totalBytesExpected - totalBytesRead;
        double time_left = bytes_left / speed;
        
        int secs = time_left;
        //int h = secs / 3600;
        int m = secs / 60 % 60;
        int s = secs % 60;
        
     //   NSString *text = [NSString stringWithFormat:@"%02d:%02d", m, s];
        if (m == 0 && s==0) {
            
            self.HUDfade.labelText = AMLocalizedString(@"Data processing", nil);
        }
        else
            self.HUDfade.labelText = [NSString stringWithFormat:@"%.1f %%",progress];
        //self.HUDfade.labelText = [NSString stringWithFormat:@"%@ \t %@",AMLocalizedString(@"Time left", nil),text];
     //   NSLog(@"Time left: %@ \n Speed: %f",text,speed);
        currentTime = currentTime2;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAllCatalogues" object:nil];
}

- (NSError *) DownloadError:(NSError *) error{
 //   NSLog(@"error = %d",error.code);
 //   NSLog(@"error description = %@",error.description);
    return error;
}

- (void)waitForTwoSeconds {
    sleep(3);
}
@end

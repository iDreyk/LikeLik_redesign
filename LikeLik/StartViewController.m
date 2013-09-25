//
//  StartViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "StartViewController.h"
//#import "StartTableCell.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "LocalizationSystem.h"
#import "MBProgressHUD.h"
#import "CategoryViewController.h"

#define dismiss                 @"l27h7RU2dzVaQsadaQeSFfPoQQQQ"
#define catalogue @"Catalogues"
#define FADE_TAG 66484
#define LABELTAG 44324
#define THUNDER_TAG 123123

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define backgroundTag 2442441
#define backgroundTag2 2442442

NSInteger PREV_ROW = 0;
static bool REVERSE_ANIM = false;
static BOOL JUST_APPEAR = YES;

@interface StartViewController ()

@end


@implementation StartTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@implementation StartViewController
@synthesize label,special_series;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Start Screen"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    JUST_APPEAR = YES;
    
    [self.navigationItem setTitleView:[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Guides", Nil) AndColor:[InterfaceFunctions corporateIdentity]]];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.CityTable.backgroundView = [InterfaceFunctions backgroundView];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button_house];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/4, 0.0, 0.0)];
    special_series = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128.0, 128.0)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[AppDelegate OpenSansRegular:32]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.hidden = YES;
   special_series.tag = THUNDER_TAG;

    [special_series setAlpha:0.7];
    special_series.hidden = YES;
    
//    if (self.tabBarController.selectedIndex == 3){
//        [label setText:AMLocalizedString(@"Special Annotation", nil)];
//        [special_series setImage:[UIImage imageNamed:@"512x512 special Series"]];
//    }
    label.numberOfLines = 0;
    [label sizeToFit];
    [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
    
    
    [self.view addSubview:special_series];
    [self.view addSubview:label];
    
    
    [self.Featured setTitle:AMLocalizedString(@"Featured", nil)];
    
    [self.Downloaded setTitle:AMLocalizedString(@"Downloaded", nil)];
    
    [self.All setTitle:AMLocalizedString(@"All Guides", nil)];
    
    [self.Special setTitle:AMLocalizedString(@"Special Series", nil)];
    [self.TabBar setSelectedItem:self.Downloaded];
    
    if ([self.TabBar.selectedItem isEqual:self.Downloaded]){
        [label setText:AMLocalizedString(@"Download Annotation", nil)];
        [special_series setImage:[UIImage imageNamed:@"512x512 download"]];
    }
    _CityLabels = [ExternalFunctions getCities:self.Downloaded andTag:1];
    _backCityImages = [ExternalFunctions getCities:self.Downloaded andTag:0];
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    UIButton *btn = [InterfaceFunctions Pref_button];
    [btn addTarget:self action:@selector(Pref) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pref_dismiss)
                                                 name: dismiss
                                               object: nil];
    
}

-(void)Pref{
    [self performSegueWithIdentifier:@"PrefSegue" sender:self];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    _CityLabels = [ExternalFunctions getCities:item andTag:1];
    _backCityImages = [ExternalFunctions getCities:item andTag:0];
    JUST_APPEAR = YES;
    [self.CityTable reloadData];
    
    if ([self.TabBar.selectedItem isEqual:self.Downloaded]){
        [label setText:AMLocalizedString(@"Download Annotation", nil)];
        [special_series setImage:[UIImage imageNamed:@"617x617 Download"]];
    }
    if ([self.TabBar.selectedItem isEqual:self.Special]){
        [label setText:AMLocalizedString(@"Special Annotation", nil)];
        [special_series setImage:[UIImage imageNamed:@"512x512 special Series"]];
    }
    
    
}


-(void)pref_dismiss{

    [self.Featured setTitle:AMLocalizedString(@"Featured", nil)];
    [self.Downloaded setTitle:AMLocalizedString(@"Downloaded", nil)];
    [self.All setTitle:AMLocalizedString(@"All Guides", nil)];
    [self.Special setTitle:AMLocalizedString(@"Special Series", nil)];
 
    [self.navigationItem setTitleView:[InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Guides", Nil) AndColor:[InterfaceFunctions corporateIdentity]]];
    
    
    _CityLabels = [ExternalFunctions getCities:self.TabBar.selectedItem andTag:1];
    _backCityImages = [ExternalFunctions getCities:self.TabBar.selectedItem andTag:0];
    [self.CityTable reloadData];
    
    
    label.numberOfLines = 0;
    [label sizeToFit];
#warning начинает "скукоживаться" при смене языков много раз
    [label setFrame:CGRectMake((320.0-label.frame.size.width)/2, self.view.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
    
    CGPoint temp = self.view.center;
    temp.y -= 80;
    [special_series setCenter:temp];
    
}


-(void)viewDidAppear:(BOOL)animated{
    //self.CityTable.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Memory warning" action:@"Catch warning"                                                                                          label:@"Start view" value:nil] build]];
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
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.CityLabel.font = [AppDelegate OpenSansSemiBold:60];
    cell.CityLabel.text  = _CityLabels[row];
    cell.CityLabel.textColor = [UIColor whiteColor];
    cell.BackCityImage.image = _backCityImages[row];
    [cell.contentView addSubview:[InterfaceFunctions standartAccessorView]];
    //http://stackoverflow.com/questions/13148091/uitableview-scrolling-slowly-with-uiimage
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // log([NSString stringWithFormat:@"TOUCHED!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![self.TabBar.selectedItem isEqual:self.Downloaded] && ![ExternalFunctions isDownloaded:_CityLabels[[indexPath row]]]){
        [defaults setValue:[NSNumber numberWithInt:[indexPath row]] forKey:@"row"];
        //[self ShowAlertView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 151;
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

    if (![[segue identifier] isEqualToString:@"PrefSegue"]) {
        //self.CityTable.hidden = YES;
        NSIndexPath *indexPath = [self.CityTable indexPathForSelectedRow];
        CategoryViewController *destination = [segue destinationViewController];
        StartTableCell *cell = (StartTableCell *)[self.CityTable cellForRowAtIndexPath:indexPath];
        destination.Label = cell.CityLabel.text;
        
//        AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
//        UIImageView *imback = (UIImageView *)[myDelegate.window viewWithTag:backgroundTag];
//    
//        imback.image = [UIImage imageNamed:[ExternalFunctions larkePictureOfCity:destination.Label]];
//        UIImageView *imback2 = (UIImageView *)[myDelegate.window viewWithTag:backgroundTag2];
//        imback2.image = [UIImage imageNamed:[ExternalFunctions larkePictureOfCity:destination.Label]];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.TabBar.selectedItem isEqual:self.Downloaded])
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

@end

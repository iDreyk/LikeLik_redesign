//
//  TransportationViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "TransportationViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LocalizationSystem.h"

#define MAXIMUM_SCALE 4
#define MINIMUM_SCALE 2
@interface TransportationViewController ()

@end

@implementation TransportationViewController

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

    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Metro", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    //    nslog(@"TransportationViewController City Name = %@",self.CityName);
    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    NSArray *photos = [ExternalFunctions getMetroMapInCity:self.CityName];
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor blackColor];
   // NSInteger numberOfViews = [photos count];
    for (int i = 0; i < 1; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        _awesomeview = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _awesomeview.backgroundColor = [UIColor whiteColor];
        _awesomeview.image = [UIImage imageWithContentsOfFile:[photos objectAtIndex:i]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height == 640.0) {
            _awesomeview.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[photos objectAtIndex:i]]].size.height/4);
            
        }
    }
    _awesomeview.contentMode = UIViewContentModeScaleAspectFit;
    _scroll.contentMode = UIViewContentModeScaleAspectFill;
    _scroll.contentSize = _awesomeview.image.size;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 3;
    _scroll.delegate = self;
    _scroll.pagingEnabled = NO;
    [_scroll setScrollEnabled:YES];
    [_scroll addSubview:_awesomeview];
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width, 400.0);
	// Do any additional setup after loading the view.

}


-(void)viewWillAppear:(BOOL)animated{
    
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _awesomeview;
}

-(NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

- (NSArray *) cityTransportation : (NSString *)cityName{
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    catalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    
    NSString *cityLanguage;
    if ([language isEqualToString:@"ru"]) {
        cityLanguage = @"city_RU";
    }
    else if ([language isEqualToString:@"de"]){
        cityLanguage = @"city_DE";
    }
    else
        cityLanguage = @"city_EN";
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i] objectForKey:cityLanguage] isEqualToString:cityName]) {
            photos = [[catalogues objectAtIndex:i]objectForKey:@"transport"];
        }
    }
    
    return photos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

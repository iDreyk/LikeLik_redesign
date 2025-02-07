//
//  AroundMeViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import "MBProgressHUD.h"
#import "LocalizationSystem.h"

@class UIButtonWithAditionalNum;
@interface UIButtonWithAditionalNum : UIButton
@property(nonatomic)NSInteger tagForCheck;
@end


@class CheckViewController;


@interface PlaceslistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,RMMapViewDelegate,MBProgressHUDDelegate>{
    
    NSArray *AroundArray;
    CLLocation *Me;
    CLLocationManager *locationManager;
    CheckViewController *VC;    
}

@property (weak, nonatomic) IBOutlet UITableView *PlacesTable;

@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (weak, nonatomic) IBOutlet NSString *Image;
@property (weak, nonatomic) IBOutlet UIImageView *gradient_under_cityname;
@property (nonatomic, strong) NSMutableDictionary *imageCache;


@property (weak, nonatomic) IBOutlet UILabel *CityName;
@property (weak, nonatomic) IBOutlet NSString *CityNameText;
@property (nonatomic, retain) IBOutlet NSArray *readyArray;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (retain, nonatomic) IBOutlet RMMapView *Map;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedMapandTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (nonatomic,retain)        MBProgressHUD  *HUD;
@property (nonatomic,retain) UIButtonWithAditionalNum *knuck;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic,retain) NSString *CityNameString;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
-(IBAction) segmentedControlIndexChanged;
-(IBAction)showLocation:(id)sender;

@end

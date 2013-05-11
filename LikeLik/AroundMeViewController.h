//
//  AroundMeViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
@interface AroundMeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,RMMapViewDelegate,MBProgressHUDDelegate>{
    
    NSArray *Rest;
    NSArray *Shopping;
    NSArray *Entertainment;
    NSArray *Sport;
    NSDictionary *Places;
    CLLocation *Me;
    
    NSString *cataloguesPath;
    NSArray *catalogues;
    NSString *Place;
    CLLocationManager *locationManager;
    
}

@property (weak, nonatomic) IBOutlet UITableView *PlacesTable;
@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (weak, nonatomic) IBOutlet UILabel *CityName;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (retain, nonatomic) IBOutlet RMMapView *Map;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedMapandTable;
@property (weak, nonatomic) IBOutlet UITableView *TablePlaces;
@property (weak, nonatomic) IBOutlet NSString *Image;
@property (weak, nonatomic) IBOutlet NSString *CityNameText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (weak, nonatomic) IBOutlet UIView *ViewforMap;
@property (weak, nonatomic) IBOutlet UIImageView *gradient_under_cityname;
@property (nonatomic,retain)        MBProgressHUD  *HUD;
-(IBAction) segmentedControlIndexChanged;
-(IBAction)showLocation:(id)sender;

@end

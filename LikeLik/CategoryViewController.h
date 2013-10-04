//
//  CategoryViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 30.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import "MBProgressHUD.h"

@interface CategoryViewController : UIViewController <RMMapViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>{
    NSArray *AroundArray;
    CLLocationManager *locationManager2;
    CLLocation *Me;
}
@property(nonatomic, retain) CLLocationManager *locationManager2;
@property(nonatomic, retain) CLLocationManager *locationManagerRegion;
@property (nonatomic,retain) IBOutlet UILocalNotification *localNotification;

@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (nonatomic,retain)IBOutlet UIImageView *GradientUnderLabel;
@property (weak, nonatomic) IBOutlet NSString *Image;
@property (weak, nonatomic) IBOutlet NSString *Label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (nonatomic,retain)IBOutlet NSArray *CellArray;
@property (nonatomic,retain)IBOutlet NSArray *frameArray;
@property (nonatomic,retain)IBOutlet NSArray *SegueArray;
@property (nonatomic, retain) CLLocationManager *locationManager1;
@property (nonatomic,retain)MBProgressHUD *HUDfade;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryView;
@property (nonatomic,retain)IBOutlet UIImageView *blur;

@property (retain, nonatomic) IBOutlet RMMapView *MapPlace;
@property (nonatomic,retain) IBOutlet NSURL *MapURL;
@property (strong, nonatomic) IBOutlet UIView *frame1;
-(void)search:(id)sender;
- (void)updateOffsets;
-(IBAction)ShowMap:(id)sender;
@end

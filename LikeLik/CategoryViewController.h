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

@interface CategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,RMMapViewDelegate,UIScrollViewDelegate>{
        NSArray *AroundArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (nonatomic,retain)IBOutlet UILabel *CityName;
@property (nonatomic,retain)IBOutlet UIImageView *GradientUnderLabel;
@property (weak, nonatomic) IBOutlet NSString *Image;
@property (weak, nonatomic) IBOutlet NSString *Label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (nonatomic,retain)IBOutlet NSArray *CellArray;
@property (nonatomic,retain)IBOutlet NSArray *frameArray;
@property (nonatomic,retain)IBOutlet NSArray *SegueArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,retain)MBProgressHUD *HUDfade;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryView;


@property (retain, nonatomic) IBOutlet RMMapView *MapPlace;
@property (weak, nonatomic) IBOutlet UIView *PlaceView;
@property (strong, nonatomic) IBOutlet UIView *frame1;
@property (nonatomic,retain) IBOutlet UIView *placeViewMap;
-(void)search:(id)sender;
- (void)updateOffsets;
-(IBAction)ShowMap:(id)sender;
@end

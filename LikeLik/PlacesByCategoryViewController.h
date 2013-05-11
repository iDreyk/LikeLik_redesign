//
//  PlacesByCategoryViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 10.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
@interface PlacesByCategoryViewController : UIViewController <RMMapViewDelegate>{
    NSArray *Places;
}
@property (nonatomic, retain) NSArray *dataHeader;
@property (nonatomic, retain) NSArray *dataPlaces;
@property (nonatomic, retain) NSArray *Places;
@property (weak, nonatomic) IBOutlet UILabel *DistrictLabel;
@property (weak, nonatomic) IBOutlet UITableView *PlacesTable;
@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (nonatomic, retain) NSString *CityName;
@property (nonatomic,retain) NSString *District;
@property (nonatomic,retain) NSString *Image;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedMapandTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchBarButton;
@property (retain, nonatomic) IBOutlet RMMapView *Map;
@property (weak, nonatomic) IBOutlet UIView *ViewForMap;
@property (weak, nonatomic) IBOutlet UIImageView *GradientnderLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
-(IBAction)showLocation:(id)sender;

-(IBAction) segmentedControlIndexChanged;

@end

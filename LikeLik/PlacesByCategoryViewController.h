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
    NSArray *CategoryPlaces;
}
@property (nonatomic, retain) NSString *CityName;

@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
@property (nonatomic,retain) NSString *Category;

@property (weak, nonatomic) IBOutlet UITableView *PlacesTable;

@property (nonatomic,retain) NSString *Image;
@property (retain, nonatomic) IBOutlet UIImageView *CityImage;

@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedMapandTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchBarButton;
@property (retain, nonatomic) IBOutlet RMMapView *Map;
@property (weak, nonatomic) IBOutlet UIView *ViewForMap;
@property (weak, nonatomic) IBOutlet UIImageView *GradientnderLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
-(IBAction)showLocation:(id)sender;
-(IBAction) segmentedControlIndexChanged;

@end

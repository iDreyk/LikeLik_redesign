//
//  FavViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 15.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
@interface FavViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RMMapViewDelegate>{
    NSArray *FavouritePlaces;
}


@property (weak, nonatomic) IBOutlet UITableView *FavTable;

@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@property (nonatomic, retain) NSString *CityName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedMapandTable;
@property (weak, nonatomic) IBOutlet UIView *ViewforMap;
@property (retain, nonatomic) IBOutlet RMMapView *Map;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet NSArray *readyArray;

-(IBAction)showLocation:(id)sender;
-(IBAction) segmentedControlIndexChanged;
@end

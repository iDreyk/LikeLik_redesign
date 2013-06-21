//
//  CategoryViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 30.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIImageView *CityImage;
@property (nonatomic,retain)IBOutlet UILabel *CityName;
@property (nonatomic,retain)IBOutlet UIImageView *GradientUnderLabel;
@property (weak, nonatomic) IBOutlet NSString *Image;
@property (weak, nonatomic) IBOutlet NSString *Label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (nonatomic,retain)IBOutlet NSArray *CellArray;
@property (nonatomic,retain)IBOutlet NSArray *SegueArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
-(void)search:(id)sender;
- (void)updateOffsets;

@end

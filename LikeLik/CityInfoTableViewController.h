//
//  CityInfoTableViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityInfoTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *VisualCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *TransportationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *PracticalCell;
@property (nonatomic,retain)NSString *cityName;
@end

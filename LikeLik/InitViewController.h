//
//  InitViewController.h
//  LikeLik
//
//  Created by Vladimir Malov on 20.09.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>

@property(nonatomic,retain)IBOutlet UITabBar *TabBar;
@property(nonatomic,retain)IBOutlet UITabBarItem *Featured;
@property(nonatomic,retain)IBOutlet UITabBarItem *Downloaded;
@property(nonatomic,retain)IBOutlet UITabBarItem *All;
@property(nonatomic,retain)IBOutlet UITabBarItem *Special;



@property(nonatomic,retain)IBOutlet UITableView *CityTable;
@end

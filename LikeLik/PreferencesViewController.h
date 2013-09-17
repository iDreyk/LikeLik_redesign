//
//  PreferencesViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesViewController : UITableViewController{
    NSArray *RegisterAndLogin;
    NSArray *Language;
    NSArray *Measures;
    NSArray *Information;
}
@property (strong, nonatomic) IBOutlet UITableView *PreferencesTable;

@end

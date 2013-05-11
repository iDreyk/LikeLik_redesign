//
//  AboutTableViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *SupportCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *TermsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *AboutCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *MoreLikeLikApps;
@property (nonatomic,retain) NSString *Parent;



@end

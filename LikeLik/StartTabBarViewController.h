//
//  StartTabBarViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 09.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTabBarViewController : UITabBarController
@property (weak, nonatomic) IBOutlet UINavigationItem *NavBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchBarButton;
-(IBAction)search:(id)sender;
@end

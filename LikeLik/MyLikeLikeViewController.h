//
//  MyLikeLikeViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 13.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLikeLikeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *LikeLikImage;
    NSArray *LikeLikString;
    NSArray *urls;
}
@property (weak, nonatomic) IBOutlet UITableView *TableView;

@end

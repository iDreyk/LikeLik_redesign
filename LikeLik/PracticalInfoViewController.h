//
//  PracticalInfoViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticalInfoViewController : UIViewController {
    NSString *cataloguesPath;
    NSMutableArray *catalogues;
}
@property (nonatomic,retain) NSString *CityName;
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *InfoScroll;
@end

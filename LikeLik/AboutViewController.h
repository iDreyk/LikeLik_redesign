//
//  AboutViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    NSString *cataloguesPath;
    NSMutableDictionary *catalogues;
}
@property (weak, nonatomic) IBOutlet UIScrollView *infoScroll;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (nonatomic,retain)IBOutlet UITextView *text;
@end

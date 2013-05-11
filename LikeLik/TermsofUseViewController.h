//
//  TermsofUseViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsofUseViewController : UIViewController {
    NSString *cataloguesPath;
    NSMutableDictionary *catalogues;
}
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIScrollView *InfoScroll;

@end

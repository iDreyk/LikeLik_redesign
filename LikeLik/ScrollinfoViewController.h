//
//  PracticalInfoViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SubText1 : UITextView

@end

@interface ScrollinfoViewController : UIViewController {
    
}
@property (nonatomic,retain) NSString *Parent;
@property (nonatomic,retain) NSString *CityName;
@property (nonatomic,retain) IBOutlet UIWebView *Likelikcom;
@property (nonatomic,retain) IBOutlet SubText1 *Text;
@property (weak, nonatomic) IBOutlet UIView *ShadowView;
@end

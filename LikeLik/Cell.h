//
//  Cell.h
//  LikeLik
//
//  Created by Vladimir Malov on 20.09.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView *cityImage;
@property(nonatomic,retain)IBOutlet UILabel *label;
@end

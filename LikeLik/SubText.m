//
//  SubText.m
//  TabBar
//
//  Created by Vladimir Malov on 19.03.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "SubText.h"

@interface UITextView ()
- (id)styleString; // make compiler happy
@end


@implementation SubText

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 1.5em"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

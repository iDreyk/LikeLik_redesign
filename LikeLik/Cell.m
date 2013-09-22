//
//  Cell.m
//  LikeLik
//
//  Created by Vladimir Malov on 20.09.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize cityImage = _cityImage;
@synthesize label = _label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

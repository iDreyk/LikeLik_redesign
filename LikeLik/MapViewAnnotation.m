//
//  MapViewAnnotation.m
//  LikeLikMSCW
//
//  Created by Vladimir Malov on 02.07.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate,userinfo,subtitle,tag;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andUserinfo:(NSDictionary *)uinfo andSubtitle:(NSString *)subt AndTag:(NSString *)t{
	title = ttl;
	coordinate = c2d;
    userinfo = uinfo;
    subtitle = subt;
    tag = t;
	return self;
}

-(NSString *)title{
    return title;
}

- (void)dealloc {
}

@end
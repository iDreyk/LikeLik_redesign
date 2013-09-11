//
//  MapViewAnnotation.h
//  LikeLikMSCW
//
//  Created by Vladimir Malov on 02.07.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface MapViewAnnotation : NSObject <MKAnnotation>{
    NSString *title;
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSDictionary *userinfo;
    NSString *tag;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSDictionary *userinfo;
@property (nonatomic,retain) NSString *tag;
- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andUserinfo:(NSDictionary *)uinfo andSubtitle:(NSString *)subt AndTag:(NSString*)t;
- (NSString *)title;
@end

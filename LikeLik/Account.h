//
//  Account.h
//  Registration
//
//  Created by Vladimir Malov on 09.07.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject{
    Account *One;
}
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *Email;
@property(nonatomic,retain)NSString *Password;
@property(nonatomic,retain)NSString *BDate;
@property(nonatomic,retain)NSString *UID;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
//Registration
-(NSDictionary *)makeAccount;
-(Account *)initwithEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password day:(NSString *)bday month:(NSString *)bmonth Year:(NSString *)byear Lat:(NSString *)lat Lon:(NSString *)lon;
-(NSDictionary *)makeTWAccount;
-(NSDictionary *)makeFBAccount;
-(NSDictionary *)makeVKAccount;
-(Account *)initwithUID:(NSString *)UID Name:(NSString *)name Password:(NSString *)password day:(NSString *)bday month:(NSString *)bmonth Year:(NSString *)byear Lat:(NSString *)lat Lon:(NSString *)lon;

//Login
-(NSDictionary *)LoginmakeAccount;
-(Account *)LogininitwithEmail:(NSString *)email Password:(NSString *)password Lat:(NSString *)lat Lon:(NSString *)lon;

-(NSDictionary *)LoginmakeTWAccount;
-(NSDictionary *)LoginmakeFBAccount;
-(NSDictionary *)LoginmakeVKAccount;
-(Account *)LogininitwithUID:(NSString *)UID Password:(NSString *)password Lat:(NSString *)lat Lon:(NSString *)lon;



@end

//
//  Account.m
//  Registration
//
//  Created by Vladimir Malov on 09.07.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "Account.h"

@implementation Account

/*
 BUGS
 lon lat передаю, но не появляются в базе
 
 */
-(NSString *)makePassword{
    return [NSString stringWithFormat:@"%@password",self.Password];
}

-(NSArray *)makeAccountKeyArray{
    return @[@"name",@"Email",@"Password",@"Birth_date",@"lat",@"lon"];
}
-(NSArray *)makeVKAccountKeyArray{

    return @[@"name",@"vkontakte_id",@"Password",@"Birth_date",@"lat",@"lon"];
}
-(NSArray *)makeFBAccountKeyArray{
    return @[@"name",@"facebook_id",@"Password",@"Birth_date",@"lat",@"lon"];
}

-(NSArray *)makeTWAccountKeyArray{
    return @[@"name",@"twitter_id",@"Password",@"Birth_date",@"lat",@"lon"];
}


-(NSDictionary *)makeAccount{
    NSLog(@"%@",[NSDictionary dictionaryWithObjects:@[self.Name,self.Email,self.Password,self.BDate,self.latitude,self.longitude] forKeys:[self makeAccountKeyArray]]);
    return [NSDictionary dictionaryWithObjects:@[self.Name,self.Email,self.Password,self.BDate,self.latitude,self.longitude] forKeys:[self makeAccountKeyArray]];
}

-(Account *)initwithEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password day:(NSString *)bday month:(NSString *)bmonth Year:(NSString *)byear Lat:(NSString *)lat Lon:(NSString *)lon{
    One = [[Account alloc] init];
    One.Name = name;
    One.Email = email;
    One.Password = password;
    One.BDate = [NSString stringWithFormat:@"%@.%@.%@",bday,bmonth,byear];
    One.latitude = lat;
    One.longitude = lon;
    NSLog(@"%@ %@",One.latitude,One.longitude);
    return One;
}

-(NSDictionary *)makeVKAccount{
    return [NSDictionary dictionaryWithObjects:@[self.Name,self.UID,[self makePassword],self.BDate,@"0",@"0"] forKeys:[self makeVKAccountKeyArray]];
}

-(NSDictionary *)makeFBAccount{
    return [NSDictionary dictionaryWithObjects:@[self.Name,self.UID,[self makePassword],self.BDate,@"0",@"0"] forKeys:[self makeFBAccountKeyArray]];
}

-(NSDictionary *)makeTWAccount{
    return [NSDictionary dictionaryWithObjects:@[self.Name,self.UID,[self makePassword],self.BDate,@"0",@"0"] forKeys:[self makeTWAccountKeyArray]];
}


-(Account *)initwithUID:(NSString *)UID Name:(NSString *)name Password:(NSString *)password day:(NSString *)bday month:(NSString *)bmonth Year:(NSString *)byear Lat:(NSString *)lat Lon:(NSString *)lon{
    One = [[Account alloc] init];
    One.Name = name;
    One.UID = UID;
    One.Password = password;
    One.BDate = [NSString stringWithFormat:@"%@.%@.%@",bday,bmonth,byear];
    One.longitude = lon;
    One.latitude = lat;
    return One;
}



-(NSArray *)LoginmakeAccountKeyArray{
    return @[@"Email",@"Password",@"lat",@"lon"];
}

-(NSArray *)LoginmakeVKAccountKeyArray{
    return @[@"vkontakte_id",@"Password",@"lat",@"lon"];
}
-(NSArray *)LoginmakeFBAccountKeyArray{
    return @[@"facebook_id",@"Password",@"lat",@"lon"];
}

-(NSArray *)LoginmakeTWAccountKeyArray{
    return @[@"twitter_id",@"Password",@"lat",@"lon"];
}


-(NSDictionary *)LoginmakeAccount{
    return [NSDictionary dictionaryWithObjects:@[self.Email,self.Password,self.latitude,self.longitude] forKeys:[self LoginmakeAccountKeyArray]];
}

-(Account *)LogininitwithEmail:(NSString *)email Password:(NSString *)password Lat:(NSString *)lat Lon:(NSString *)lon{
    One = [[Account alloc] init];
    One.Email = email;
    One.Password = password;
    One.latitude = lat;
    One.longitude = lon;
    return One;
}

-(NSDictionary *)LoginmakeVKAccount{
    NSLog(@"%@",[NSDictionary dictionaryWithObjects:@[self.UID,[self makePassword],self.latitude,self.longitude] forKeys:[self LoginmakeVKAccountKeyArray]]);
    return [NSDictionary dictionaryWithObjects:@[self.UID,[self makePassword],self.latitude,self.longitude] forKeys:[self LoginmakeVKAccountKeyArray]];
}

-(NSDictionary *)LoginmakeFBAccount{
    return [NSDictionary dictionaryWithObjects:@[self.UID,[self makePassword],self.latitude,self.longitude] forKeys:[self LoginmakeFBAccountKeyArray]];
}

-(NSDictionary *)LoginmakeTWAccount{
    return [NSDictionary dictionaryWithObjects:@[self.UID,[self makePassword],self.latitude,self.longitude] forKeys:[self LoginmakeTWAccountKeyArray]];
}

-(Account *)LogininitwithUID:(NSString *)UID Password:(NSString *)password Lat:(NSString *)lat Lon:(NSString *)lon{
    One = [[Account alloc] init];
    One.UID = UID;
    One.Password = password;
    One.longitude = lon;
    One.latitude = lat;
    return One;
}

@end

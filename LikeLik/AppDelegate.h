//
//  AppDelegate.h
//  LikeLik
//
//  Created by Vladimir Malov on 08.05.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//


//extern NSString *localReceived;
#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UILabel  *alertLabel;
@property (nonatomic, assign) UIViewController *currentController;

+(UIFont *)OpenSansRegular:(CGFloat)size;
+(UIFont *)OpenSansSemiBold:(CGFloat)size;
+(UIFont *)OpenSansBoldwithSize:(CGFloat)size;
+(UIFont *)OpenSansLight:(CGFloat)size;
+(UIColor *)SelectedCellColor:(NSInteger)flag;
+(UIColor *)color1withFlag:(NSInteger)flag;
+(NSArray *)ColorsForGradient;

+(UIView *)CellBG;
+(UIView *)SelectedCellBG;

+(UILabel *)AboutLabelwithString:(NSString *)string andheight:(CGFloat)height andNumberLines:(NSInteger)Lines;
+(UIImageView *)DistrictImage:(NSString *)image;
+(UIScrollView *)photScrollwithArray:(NSArray *)photos;
+(UIImageView *)BGForLabels;
+(CALayer *)gradient:(UIView *)view;
+(UIBarButtonItem *)back_button;
+(UIButton *)search_button;

+(UILabel *)LabelonPhoto:(NSString *)string andHeightofParentView:(CGFloat)height;
+(UIButton *)segmentbar_map_list:(NSInteger)flag;
+(void)segmentControlMapList;
+(BOOL)isiPhone5;
//+(UIImage *)ribbon:(UIColor *)color;
+(UIImage *)check_background:(UIColor *)color;
+(void)lang;
+(UIImageView *)accessorView;

+(UIButton *)done_button;

@end
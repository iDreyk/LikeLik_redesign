//
//  InterfaceFunctions.h
//  TabBar
//
//  Created by Vladimir Malov on 23.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface InterfaceFunctions : NSObject

#pragma mark UIButton
+(UIButton *)Pref_button;
+(UIButton *)Info_button;
+(UIButton *)map_button:(NSInteger)flag;
+(UIButton *)home_button;
+(UIButton *)search_button;
+(UIButton *)segmentbar_map_list:(NSInteger)flag;
+(UIButton *)done_button;

#pragma mark UIColor
+(UIColor *)mainTextColor:(NSInteger)flag;
+(UIColor *)colorTextCategory:(NSString *)Category;
+(UIColor *)colorTextPlaceBackground:(NSString *)Category;
+(UIColor *)taxiColor;
+(UIColor *)ShadowColor;
+(UIColor *)BackgroundColor;

#pragma mark UILabel
+(UILabel *)NavLabelwithTitle:(NSString *)string AndColor:(UIColor *)Color;
+(UILabel *)goLabelCategory:(NSString *)Category;
+(UILabel *)LabelHUDwithString:(NSString *)String;
+(UILabel *)mainTextLabelwithText:(NSString *)String AndColor:(UIColor *)Color;
+(UILabel *)TableLabelwithText:(NSString *)String AndColor:(UIColor *)Color AndFrame:(CGRect)Frame;

#pragma mark UIImageView
+(UIImageView *)actbwithCategory:(NSString *)Category;
+(UIImageView *)actbwithColor:(NSInteger)value;
+(UIImageView *)actbTaxi;
+(UIImageView *)MapPin:(NSString *)Category;
+(UIImageView *)TabitemwithCategory:(NSString *)Category andtag:(NSString *)tag;
+(UIImageView *)Ribbon:(NSString *)Category;
+(UIImageView *)usecheckbutton:(NSString *)Category andTag:(NSString *)tag;
+(UIImageView *)favourite_star_empty;
+(UIImageView *)MapPinVisualTour;
+(UIImageView *)Info_buttonwithCategory:(NSString *)Category;
+(UIImageView *)UserLocationButton:(NSString *)flag;
+(UIImageView *)backgroundView;
+(UIImageView *)standartAccessorView;
+(UIImageView *)favouritestarPlaceView;
#pragma mark UIView
+(UIView *)headerwithCategory:(NSString *)Category;
+(UIView *)HeaderwithDistrict:(NSString *)String;
+(UIView *)SelectedCellBG;
+(UIView *)CellBG;

#pragma mark UIBarButtonItem
+(UIBarButtonItem *)back_button_house;
+(UIBarButtonItem *)back_button_house_withbackground;
+(UIBarButtonItem *)back_button;

#pragma mark CGSize
+(CGSize)ShadowSize;

#pragma mark UIImage
+(UIImage *)check_background;

@end

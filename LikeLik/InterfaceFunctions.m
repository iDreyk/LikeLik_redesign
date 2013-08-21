//
//  InterfaceFunctions.m
//  TabBar
//
//  Created by Vladimir Malov on 23.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "InterfaceFunctions.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
@implementation InterfaceFunctions

#pragma mark UIButton
+(UIButton *)Pref_button{
    UIImage *buttonImage = [UIImage imageNamed:@"60_61 settings"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel  setFont:[AppDelegate OpenSansRegular:24]];
    aButton.frame = CGRectMake(0.0, 0.0, aButton.imageView.frame.size.width, aButton.imageView.frame.size.height);
    [aButton sizeToFit];
    return aButton;
    
}
+(UIButton *)Info_button{
    UIImage *buttonImage = [UIImage imageNamed:@"60_61 nav_info"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel  setFont:[AppDelegate OpenSansRegular:24]];
    aButton.frame = CGRectMake(0.0, 0.0, aButton.imageView.frame.size.width, aButton.imageView.frame.size.height);
    [aButton sizeToFit];
    return aButton;
}
+(UIButton *)map_button:(NSInteger)flag{
    UIButton *aButton;
    if (flag == 0) {
        UIImage *buttonImage = [UIImage imageNamed:@"info.png"];
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
            return aButton;
    }
    if (flag == 1) {
        UIImage *buttonImage = [UIImage imageNamed:@"60_61 map"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [aButton.titleLabel  setFont:[AppDelegate OpenSansRegular:24]];
        [aButton setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
        aButton.frame = CGRectMake(0.0, 0.0, aButton.imageView.frame.size.width, aButton.imageView.frame.size.height);
        [aButton sizeToFit];
            return aButton;
    }
    
    return 0;
    
}
+(UIButton *)home_button{
    UIImage *buttonImage = [UIImage imageNamed:@"60_61 button_home"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    
    return aButton;
}
+(UIButton *)search_button{
    UIImage *buttonImage = [UIImage imageNamed:@"search_butt.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    aButton.imageEdgeInsets = UIEdgeInsetsMake(-0, 0, 0, 0);
    
    // Set the Target and Action for aButton
    
    
    return aButton;
}
+(UIButton *)segmentbar_map_list:(NSInteger)flag{
    UIButton *aButton;
    if (flag == 0) {
        UIImage *buttonImage = [UIImage imageNamed:@"segmentbar_map_tapped.png"];
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    }
    if (flag == 1) {
        UIImage *buttonImage = [UIImage imageNamed:@"segmentbar_list_tapped.png"];
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    }
    return aButton;
}
+(UIButton *)done_button{
    UIImage *buttonImage = [UIImage imageNamed:@"done_button"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel  setFont:[AppDelegate OpenSansRegular:24]];
    [aButton setTitle:AMLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    
    [aButton sizeToFit];
    CGRect newFrame = aButton.frame;
    newFrame.origin.x = 2;
    newFrame.size.width += 10;
    aButton.frame = newFrame;
    return aButton;
}


#pragma mark UIColor
+(UIColor *)corporateIdentity{
  return [UIColor colorWithRed:169.0/255.0 green:79.0/255.0 blue:190.0/255.0 alpha:1];
}

+(UIColor *)mainTextColor:(NSInteger)flag{
    UIColor *color;
    

    switch (flag) {
        case 1:
            color = [self corporateIdentity];
            break;
        case 2:
            color = [UIColor colorWithRed:184.0/255.0 green:6.0/255.0 blue:6.0/255.0 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:207.0/255.0 green:16.0/255.0 blue:207.0/255.0 alpha:1];
            break;
        case 5:
            color = [UIColor colorWithRed:30.0/255.0 green:187.0/255.0 blue:22.0/255.0 alpha:1];
            break;
        case 6:
            color = [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:0/255.0 alpha:1];
            break;
        case 7:
            color = [UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:153.0/255.0 alpha:1];
            break;
        case 8:
            color = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:217.0/255.0 alpha:1];
            break;
        case 9:
            color = [self corporateIdentity];
            break;
        case 10:
            color = [self corporateIdentity];
        default:
            break;
    }

    
    return color;
}
+(UIColor *)colorTextCategory:(NSString *)Category{
    UIColor *color;
    NSLog(@"Category: %@", Category);
    if ([Category isEqualToString:@"Restaurants"]) {
        color = [self mainTextColor:2];
    }
    if ([Category isEqualToString:@"Night life"]) {
        color = [self mainTextColor:3];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        color = [self mainTextColor:4];
    }
    if ([Category isEqualToString:@"Culture"]) {
        color = [self mainTextColor:5];
    }
    if ([Category isEqualToString:@"Leisure"]) {
        color = [self mainTextColor:6];
    }
    if ([Category isEqualToString:@"Beauty"]) {
        color = [self mainTextColor:7];
    }
    if ([Category isEqualToString:@"Hotels"]) {
        color = [self mainTextColor:8];
    }
    return color;
}
+(UIColor *)colorTextPlaceBackground:(NSString *)Category{
    return [self colorTextCategory:Category];
}
+(UIColor *)taxiColor{
    return  [UIColor colorWithRed:253.0/255.0 green:179.0/255.0 blue:66.0/255.0 alpha:1.000];
}
+(UIColor *)ShadowColor{
   return  [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
}
+(UIColor*)BackgroundColor{


    UIImage *img = [InterfaceFunctions backgroundView].image;
    return [UIColor colorWithPatternImage:img];
}

#pragma mark UILabel
+(UILabel *)NavLabelwithTitle:(NSString *)string AndColor:(UIColor *)Color{
    UIFont* font = [AppDelegate OpenSansSemiBold:32];
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    CGRect frame = CGRectMake(0, 0, expectedLabelSize.width, expectedLabelSize.height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = Color;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = string;
    label.shadowColor = [InterfaceFunctions ShadowColor];
    label.shadowOffset = [InterfaceFunctions ShadowSize];
    return label;
    
}
+(UILabel *)goLabelCategory:(NSString *)Category{

    UILabel *_go = [[UILabel alloc] initWithFrame:CGRectMake(275, 15, 30, 14)];
    _go.font = [AppDelegate OpenSansRegular:28];
    _go.textColor = [self colorTextPlaceBackground:Category];
    _go.text = @"Go!";
    _go.backgroundColor = [UIColor clearColor];
    _go.shadowColor = [InterfaceFunctions ShadowColor];
    _go.shadowOffset = [InterfaceFunctions ShadowSize];
    
    return _go;
}
+(UILabel *)LabelHUDwithString:(NSString *)String{
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 320.0, 50.0)];
    label.backgroundColor = [UIColor clearColor];
    label.text = String;
    label.textColor = [UIColor whiteColor];
    label.font = [AppDelegate OpenSansBoldwithSize:28];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowColor = [InterfaceFunctions ShadowColor];
    label.shadowOffset = [InterfaceFunctions ShadowSize];
    [label setNumberOfLines:3];
    return label;
}
+(UILabel *)mainTextLabelwithText:(NSString *)String AndColor:(UIColor *)Color{
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 12.0, 280.0,21.0)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [AppDelegate OpenSansRegular:28];
    text.text = String;
    text.textColor = Color;
    text.shadowColor = [InterfaceFunctions ShadowColor];
    text.shadowOffset = [InterfaceFunctions ShadowSize];
   return text;
}
+(UILabel *)TableLabelwithText:(NSString *)String AndColor:(UIColor *)Color AndFrame:(CGRect)Frame{
    
    UILabel *label = [[UILabel alloc] initWithFrame:Frame];
    
    if (Frame.size.width == 0.0)
        [label setFrame:CGRectMake(14.0, 0.0, 260, 15.0)];

    
    label.font = [AppDelegate OpenSansRegular:28];
    label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0.0, -0.1);
    label.backgroundColor = [UIColor clearColor];
    label.text = String;
    label.textColor = Color;
    label.highlightedTextColor = label.textColor;
    label.shadowColor = [InterfaceFunctions ShadowColor];
    label.shadowOffset = [InterfaceFunctions ShadowSize];
    return label;
}

#pragma mark UIImageView
+(UIImageView *)actbwithCategory:(NSString *)Category{
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(293,11, 22, 23)];
    _actb.image=[UIImage imageNamed:@"44_48 actb_1@2x"];
    
    if ([Category isEqualToString:@"Restaurants"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_2"];
    }
    if ([Category isEqualToString:@"Night life"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_3"];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_4"];
    }
    if ([Category isEqualToString:@"Culture"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_5"];
    }
    if ([Category isEqualToString:@"Leisure"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_6"];
    }
    if ([Category isEqualToString:@"Beauty"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_7"];
    }
    if ([Category isEqualToString:@"Hotels"]) {
        _actb.image=[UIImage imageNamed:@"44_48 actb_8"];
    }
    return _actb;
}
+(UIImageView *)actbwithColor:(NSInteger)value{
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(293,11, 22, 23)];
    NSString *string = [NSString stringWithFormat:@"44_48 actb_%d@2x",value+1];
    _actb.image=[UIImage imageNamed:string];//[NSString]]//[UIImage imageNamed:[NSString stringwithFormat:@"44_48 actb_%d@2x"]];
    return _actb;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+(UIImageView *)MapPin:(NSString *)Category{
    UIImageView *Pin=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapPin_12"]];
    

    if ([Category isEqualToString:AMLocalizedString(@"Restaurants", nil)]) {
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_2"];
//        Pin.image = [UIImage imageNamed:@"pin1"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Night life", nil)]) {
        Pin.image=[UIImage imageNamed:@"63_76 MapPin_3"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Shopping", nil)]) {
        Pin.image=[UIImage imageNamed:@"knuk_pin_4"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Culture", nil)]) {
        Pin.image=[UIImage imageNamed:@"63_76 MapPin_5"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Leisure", nil)]) {
        Pin.image=[UIImage imageNamed:@"63_76 MapPin_6"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Beauty", nil)]) {
        Pin.image=[UIImage imageNamed:@"63_76 MapPin_7"];
    }
    if ([Category isEqualToString:AMLocalizedString(@"Hotels", nil)]) {
        Pin.image=[UIImage imageNamed:@"63_76 MapPin_8"];
    }
    return Pin;

    
    
}
+(UIImageView *)TabitemwithCategory:(NSString *)Category andtag:(NSString *)tag{
    
    NSInteger Color = 12;
    if ([Category isEqualToString:@"Restaurants"]) {
        Color = 2;
    }
    if ([Category isEqualToString:@"Night life"]) {
        Color = 3;
    }
    if ([Category isEqualToString:@"Shopping"]) {
        Color = 4;
    }
    if ([Category isEqualToString:@"Culture"]) {
        Color = 5;
    }
    if ([Category isEqualToString:@"Leisure"]) {
        Color = 6;
    }
    if ([Category isEqualToString:@"Beauty"]) {
        Color = 7;
    }
    if ([Category isEqualToString:@"Hotels"]) {
        Color = 8;
    }
    NSString *name;
    if ([tag isEqualToString:@"1fav_normal"] ||[tag isEqualToString:@"3share_normal"] || [tag isEqualToString:@"1fav_selected"] ||[tag isEqualToString:@"3share_selected"]) {
        name = [NSString stringWithFormat:@"214_100 Tabitem_place_%d_%@",Color,tag];
       
    }
    else{
        name = [NSString stringWithFormat:@"212_100 Tabitem_place_%d_%@",Color,tag];
    }


    // NSLog(@"%@",name);
    return  [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
}
+(UIImageView *)Ribbon:(NSString *)Category{
    UIImageView *ribbon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"592_159 Ribbon_12"]];
    if ([Category isEqualToString:@"Restaurants"]) {
        ribbon.image = [UIImage imageNamed:@"592_159 Ribbon_2"];
    }
    if ([Category isEqualToString:@"Night life"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_3"];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_4"];
    }
    if ([Category isEqualToString:@"Culture"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_5"];
    }
    if ([Category isEqualToString:@"Leisure"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_6"];
    }
    if ([Category isEqualToString:@"Beauty"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_7"];
    }
    if ([Category isEqualToString:@"Hotels"]) {
        ribbon.image=[UIImage imageNamed:@"592_159 Ribbon_8"];
    }

    return ribbon;
}
+(UIImageView *)usecheckbutton:(NSString *)Category andTag:(NSString *)tag{
    NSInteger Color;
    
    if ([Category isEqualToString:@"Restaurants"]) {
        Color = 2;
    }
    if ([Category isEqualToString:@"Night life"]) {
        Color = 3;
    }
    if ([Category isEqualToString:@"Shopping"]) {
        Color = 4;
    }
    if ([Category isEqualToString:@"Culture"]) {
        Color = 5;
    }
    if ([Category isEqualToString:@"Leisure"]) {
        Color = 6;
    }
    if ([Category isEqualToString:@"Beauty"]) {
        Color = 7;
    }
    if ([Category isEqualToString:@"Hotels"]) {
        Color = 8;
    }

    NSString *name = [NSString stringWithFormat:@"526_90 button_use_check_%d%@",Color,tag];
    return  [[UIImageView alloc] initWithImage: [UIImage imageNamed:name]];
}
+(UIImageView *)actbTaxi{

    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(300,15, 9, 14)];
    _actb.image=[UIImage imageNamed:@"44_48 actbtaxi"];
    return _actb;
}

+(UIImageView *)corporateIdentity_actb{
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(293,11, 22, 23)];
    _actb.image=[UIImage imageNamed:@"44_48 actb_corporateIdentity@2x"];
    return _actb;
}
+(UIImageView *)favourite_star_empty{
    UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 133, 140.5)];
    [star setCenter:CGPointMake(160.0, 108.0)];
    [star setImage:[UIImage imageNamed:@"266_281 star_favourites_empty"]];
    [star setAlpha:0.2];

    return star;
}
+(UIImageView *)MapPinVisualTour{
    UIImageView *Pin=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapPin_12"]];
    Pin.image = [UIImage imageNamed:@"63_76 MapPin_corporateIdentity"];
    return Pin;
    
    
    
}
+(UIImageView *)Info_buttonwithCategory:(NSString *)Category{
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"58_82 info_flag_12"]];
    
    if ([Category isEqualToString:@"Restaurants"]) {
        imageview.image = [UIImage imageNamed:@"58_82 info_flag_2"];
    }
    if ([Category isEqualToString:@"Night life"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_3"];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_4"];
    }
    if ([Category isEqualToString:@"Culture"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_5"];
    }
    if ([Category isEqualToString:@"Leisure"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_6"];
    }
    if ([Category isEqualToString:@"Beauty"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_7"];
    }
    if ([Category isEqualToString:@"Hotels"]) {
        imageview.image=[UIImage imageNamed:@"58_82 info_flag_8"];
    }
    return imageview;
}
+(UIImageView *)UserLocationButton:(NSString *)flag{
    NSString *string = [NSString stringWithFormat:@"62_62 arrow%@",flag];
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:string]];
}
+(UIImageView *)backgroundView{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"640_1136 background-568h@2x"]];
    imageview.frame = CGRectMake(0.0, 0.0, 320.0, 548);
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    return  imageview;
    
}
+(UIImageView *)standartAccessorView{
    UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 0.0, 260.0, 60.0)];
    imageview.image = [UIImage imageNamed:@"actb_white.png"];
    imageview.frame = CGRectMake(293, 123, 9, 14);
    return imageview;
}

+(UIImageView *)favouritestarPlaceView{
    UIImageView *fav = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1fav.png"]];
    fav.frame = CGRectMake(45.0, 10.0, fav.frame.size.width, fav.frame.size.height);
    [fav setCenter:CGPointMake(53, fav.center.y)];
    return fav;
}

#pragma mark UIView
+(UIView *)headerwithCategory:(NSString *)Category{
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:customView.frame];
    
    if ([Category isEqualToString:@"Restaurants"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_12"]];
    if ([Category isEqualToString:@"Entertainment"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_13"]];
    if ([Category isEqualToString:@"Shopping"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_14"]];
    if ([Category isEqualToString:@"Beauty"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_15"]];
    
    imageview.contentMode = UIViewContentModeScaleToFill;
    customView = imageview;
	
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.font = [AppDelegate OpenSansBoldwithSize:28];
	headerLabel.frame = CGRectMake(10,0,310,30);
	headerLabel.textColor = [UIColor whiteColor];
    
    headerLabel.text = AMLocalizedString(Category, nil);
    
    [customView addSubview:headerLabel];
    return customView;
}
+(UIView *)HeaderwithDistrict:(NSString *)String{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
	customView.backgroundColor = [InterfaceFunctions mainTextColor:2];
	
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
	headerLabel.font = [AppDelegate OpenSansBoldwithSize:28];
	headerLabel.frame = CGRectMake(10,0,310,30);
	headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = String;
    [customView addSubview:headerLabel];
    return customView;
}
+(UIView *)SelectedCellBG{
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    return myBackgroundView;
    
}
+(UIView *)CellBG{
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0)];
    myBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    [myBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [myBackgroundView setContentMode:UIViewContentModeScaleToFill];
    return myBackgroundView;
    
    
}

#pragma mark UIBarButtonItem
+(UIBarButtonItem *)back_button_house{
    UIImage *image = [UIImage imageNamed:@"60_61 home"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // [backButton setImage:[UIImage imageNamed:@"80_67 icon_home_place@"]];
    return backButton;
}
+(UIBarButtonItem *)back_button_house_withbackground{
    UIImage *image = [UIImage imageNamed:@"60_61 home"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // [backButton setImage:[UIImage imageNamed:@"80_67 icon_home_place@"]];
    return backButton;
}
+(UIBarButtonItem *)back_button{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:AMLocalizedString(@"Back",nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [AppDelegate OpenSansSemiBold:24], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [backButton setBackgroundVerticalPositionAdjustment:-20.0f forBarMetrics:UIBarMetricsDefault];
    [backButton setBackButtonTitlePositionAdjustment:UIOffsetMake(3.0, 0.0) forBarMetrics:UIBarMetricsDefault];
    return backButton;
}

#pragma mark CGSize
+(CGSize)ShadowSize{
    return CGSizeMake(0.0, 0.0);
}

#pragma mark UIImage
+(UIImage *)check_background{
    NSInteger flag = 7;
    NSString *name = [NSString stringWithFormat:@"check_background_%d-568h.png",flag];
    return [UIImage imageNamed:name];
}

@end

//
//  InterfaceFunctions.m
//  TabBar
//
//  Created by Vladimir Malov on 23.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "InterfaceFunctions.h"
#import "AppDelegate.h"
@implementation InterfaceFunctions

#pragma mark кнопки
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



#pragma mark цвета
+(UIColor *)mainTextColor:(NSInteger)flag{
    UIColor *color;
    

    switch (flag) {
        case 1:
            color = [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:246.0/255.0 green:9.0/255.0 blue:98.0/255.0 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:217.0/255.0 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:221.0/255.0 green:10.0/255.0 blue:178.0/255.0 alpha:1];
            break;
        case 5:
            color = [UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:134.0/255.0 alpha:1];
            break;
        case 6:
            color = [UIColor colorWithRed:155.0/255.0 green:38.0/255.0 blue:182.0/255.0 alpha:1];
            break;
            
        default:
            break;
    }

    
    return color;
}
+(UIColor *)colorTextCategory:(NSString *)Category{
    UIColor *color;
    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        color = [UIColor colorWithRed:231.0/255.0 green:20.0/255.0 blue:58.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Entertainment"]) {
        color = [UIColor colorWithRed:5.0/255.0 green:227.0/255.0 blue:5.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        color = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Health & Beauty"]) {
        color = [UIColor colorWithRed:6.0/255.0 green:194.0/255.0 blue:244.0/255.0 alpha:1.0];
    }
    return color;
}
+(UIColor *)colorTextPlaceBackground:(NSString *)Category{
    UIColor *color;
    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        color = [UIColor colorWithRed:207.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Entertainment"]) {
        color = [UIColor colorWithRed:10.0/255.0 green:200.0/255.0 blue:10.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        color = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    if ([Category isEqualToString:@"Health & Beauty"]) {
        color = [UIColor colorWithRed:6.0/255.0 green:194.0/255.0 blue:244.0/255.0 alpha:1.0];
    }
    return color;
}

+(UIColor *)taxiColor{
    return  [UIColor colorWithRed:253.0/255.0 green:179.0/255.0 blue:66.0/255.0 alpha:1.000];
}



+(UIColor *)ShadowColor{
   return  [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
}

+(UIColor*)BackgroundColor{
    
    return [UIColor colorWithPatternImage:[InterfaceFunctions backgroundView].image];
}

#pragma mark лейблы
+(UILabel *)NavLabelwithTitle:(NSString *)string AndColor:(UIColor *)Color{
    
    
    UIFont* font = [AppDelegate OpenSansSemiBold:30];
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
    _go.font = [AppDelegate OpenSansRegular:26];
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
    label.font = [AppDelegate OpenSansBoldwithSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowColor = [InterfaceFunctions ShadowColor];
    label.shadowOffset = [InterfaceFunctions ShadowSize];
    [label setNumberOfLines:3];
    return label;
}


+(UILabel *)mainTextLabelwithText:(NSString *)String AndColor:(UIColor *)Color{
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 12.0, 280.0,21.0)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [AppDelegate OpenSansRegular:26];
    text.text = String;
    text.textColor = Color;
    text.shadowColor = [InterfaceFunctions ShadowColor];
    text.shadowOffset = [InterfaceFunctions ShadowSize];
   return text;
}
+(UILabel *)TableLabelwithText:(NSString *)String AndColor:(UIColor *)Color AndFrame:(CGRect)Frame{
    
    UILabel *label = [[UILabel alloc] initWithFrame:Frame];
    
    if (Frame.size.width == 0.0)
        [label setFrame:CGRectMake(14.0, 0.0, 290, 15.0)];

    
    label.font = [AppDelegate OpenSansRegular:26];
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


#pragma mark imageView
+(UIImageView *)actbwithCategory:(NSString *)Category{
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(293,11, 22, 23)];
    
    if ([Category isEqualToString:@"Restaurants & Cafes"])
        _actb.image=[UIImage imageNamed:@"44_48 actb_12"];
    if ([Category isEqualToString:@"Entertainment"])
        _actb.image=[UIImage imageNamed:@"44_48 actb_13"];
    if ([Category isEqualToString:@"Shopping"])
        _actb.image=[UIImage imageNamed:@"44_48 actb_14"];
    if ([Category isEqualToString:@"Health & Beauty"])
        _actb.image=[UIImage imageNamed:@"44_48 actb_15"];
        
        return _actb;
}
+(UIImageView *)actbwithColor:(NSInteger)value{
    UIImageView *_actb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"44_48 actb_12"]];
    NSString *imagename = [NSString stringWithFormat:@"44_48 actb_%d",value];
    [_actb setFrame:CGRectMake(293, 11, _actb.frame.size.width, _actb.frame.size.height)];
    [_actb setImage:[UIImage imageNamed:imagename]];
    return _actb;
}
+(UIImageView *)MapPin:(NSString *)Category{
    UIImageView *Pin=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapPin_12"]];
    

    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_12"];
    }
    if ([Category isEqualToString:@"Entertainment"]) {
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_13"];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_14"];
    }
   
    if ([Category isEqualToString:@"Health & Beauty"]) {
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_15"];
    }
    return Pin;

    
    
}
+(UIImageView *)TabitemwithCategory:(NSString *)Category andtag:(NSString *)tag{
    
    NSInteger Color = 12;
    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        Color =12;
    }
    
    if ([Category isEqualToString:@"Entertainment"]) {
        Color =13;
    }
    if ([Category isEqualToString:@"Shopping"]) {
        Color =14;
    }
    
    if ([Category isEqualToString:@"Health & Beauty"]) {
        Color =15;
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
    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        ribbon.image = [UIImage imageNamed:@"592_159 Ribbon_12"];
    }
    
    if ([Category isEqualToString:@"Entertainment"]) {
        ribbon.image = [UIImage imageNamed:@"592_159 Ribbon_13"];
    }
    if ([Category isEqualToString:@"Shopping"]) {
        ribbon.image = [UIImage imageNamed:@"592_159 Ribbon_14"];
    }
    
    if ([Category isEqualToString:@"Health & Beauty"]) {
        ribbon.image = [UIImage imageNamed:@"592_159 Ribbon_15"];
    }
    return ribbon;
}
+(UIImageView *)usecheckbutton:(NSString *)Category andTag:(NSString *)tag{
    NSInteger Color;
    
    if ([Category isEqualToString:@"Restaurants & Cafes"]) {
        Color =12;
    }
    
    if ([Category isEqualToString:@"Entertainment"]) {
        Color =13;
    }
    if ([Category isEqualToString:@"Shopping"]) {
        Color =14;
    }
    
    if ([Category isEqualToString:@"Health & Beauty"]) {
        Color =15;
    }
    NSString *name = [NSString stringWithFormat:@"526_90 button_use_check_%d%@",Color,tag];
    return  [[UIImageView alloc] initWithImage: [UIImage imageNamed:name]];
}

+(UIImageView *)actbTaxi{

    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(300,15, 9, 14)];
    _actb.image=[UIImage imageNamed:@"44_48 actbtaxi"];
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
        Pin.image = [UIImage imageNamed:@"63_76 MapPin_6"];
    return Pin;
    
    
    
}

+(UIImageView *)Info_buttonwithCategory:(NSString *)Category{
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"58_82 info_flag 12"]];
    
    if ([Category isEqualToString:@"Restaurants & Cafes"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"58_82 info_flag 12"]];
    if ([Category isEqualToString:@"Entertainment"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"58_82 info_flag 13"]];
    if ([Category isEqualToString:@"Shopping"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"58_82 info_flag 14"]];
    if ([Category isEqualToString:@"Health & Beauty"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"58_82 info_flag 15"]];
    
    return imageview;
}

+(UIImageView *)UserLocationButton:(NSString *)flag{
    NSString *string = [NSString stringWithFormat:@"62_62 arrow%@",flag];
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:string]];
}

+(UIImageView *)backgroundView{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:  [UIImage imageNamed:@"640_1136 background-568h@2x"]];
    
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    return  imageview;
    
}

#pragma mark View
+(UIView *)headerwithCategory:(NSString *)Category{
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:customView.frame];
    
    if ([Category isEqualToString:@"Restaurants & Cafes"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_12"]];
    if ([Category isEqualToString:@"Entertainment"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_13"]];
    if ([Category isEqualToString:@"Shopping"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_14"]];
    if ([Category isEqualToString:@"Health & Beauty"])
        imageview.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"1_44 header_15"]];
    
    imageview.contentMode = UIViewContentModeScaleToFill;
    customView = imageview;
	
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.font = [AppDelegate OpenSansBoldwithSize:26];
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
	headerLabel.font = [AppDelegate OpenSansBoldwithSize:26];
	headerLabel.frame = CGRectMake(10,0,310,30);
	headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = String;
    [customView addSubview:headerLabel];
    return customView;
}

#pragma mark MBHUD
//+(MBProgressHUD *)AddFovouriteswithName:(NSString *)PlaceName andCategory:(NSString *)Category andCity:(NSString *)City{
//   
//    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.margin = 10.f;
//    HUD.yOffset = -150.f;
//    HUD.removeFromSuperViewOnHide = YES;
//    
//    
//    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 320.0, 50.0)];
//    label.backgroundColor = [UIColor clearColor];
//    
//    
//    if ([ExternalFunctions addToFavouritesPlace:PlaceName InCategory:Category InCity:City]){
//        label.text = AMLocalizedString(@"Object added to favourites", nil);
//    }
//    else{
//#warning нормальный блять перевод
//        label.text = AMLocalizedString(@"Object added to favourites", nil);
//    }
//    label.textColor = [UIColor whiteColor];
//    label.font = [AppDelegate OpenSansBoldwithSize:26];
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    [label setNumberOfLines:2];
//    
//    HUD.customView = label;
//    HUD.mode = MBProgressHUDModeCustomView;
//    
//    return HUD;
//}
#pragma mark UIBarButton
+(UIBarButtonItem *)back_button_house{
    UIImage *image = [UIImage imageNamed:@"60_61 home"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   // [backButton setImage:[UIImage imageNamed:@"80_67 icon_home_place@"]];
    return backButton;
}
#pragma mark UIBarButton
+(UIBarButtonItem *)back_button_house_withbackground{
    UIImage *image = [UIImage imageNamed:@"60_61 home"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // [backButton setImage:[UIImage imageNamed:@"80_67 icon_home_place@"]];
    return backButton;
}

#pragma mark CGSize
+(CGSize)ShadowSize{
    return CGSizeMake(0.0, 0.1);
}

@end
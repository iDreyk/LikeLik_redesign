//
//  TaxiViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 23.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property(nonatomic,retain)        UIColor *color;
@property(nonatomic,retain)        NSString *TaxiName;
@property(nonatomic,retain) NSArray *Photo;
@property(nonatomic,retain)NSString *TaxiAbout;
@property(nonatomic,retain)NSString *Telephone;
@property (nonatomic,retain) NSString *CityName;
@property (nonatomic,retain) NSString *Web;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *TaxiInfo;
@property (weak, nonatomic) IBOutlet UILabel *LabelonScroll;
@property (weak, nonatomic) IBOutlet UILabel *Taxilabel;
@property (weak, nonatomic) IBOutlet UITextView *TaxiText;
@property (weak, nonatomic) IBOutlet UILabel *TelLabel;
@property (weak, nonatomic) IBOutlet UILabel *WebLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScroll;
@property (weak, nonatomic) IBOutlet UIView *TaxiCard;

@end

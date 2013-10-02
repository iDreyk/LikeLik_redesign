//
//  StartViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface StartTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BackCityImage;
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@end


@interface StartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>{

}

@property (nonatomic, strong) NSArray *backCityImages;
@property (nonatomic, strong) NSArray *CityLabels;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic,retain)MBProgressHUD *HUDfade;



@property(nonatomic,retain)IBOutlet UIButton *Prefs;
@property(nonatomic,retain)IBOutlet UITableView *CityTable;

@property(nonatomic,retain)IBOutlet UITabBar *TabBar;
@property(nonatomic,retain)IBOutlet UITabBarItem *Featured;
@property(nonatomic,retain)IBOutlet UITabBarItem *Downloaded;
@property(nonatomic,retain)IBOutlet UITabBarItem *All;
@property(nonatomic,retain)IBOutlet UITabBarItem *Special;

@property(nonatomic,retain)IBOutlet UIImageView *Image_Empty;
@property(nonatomic,retain)IBOutlet UILabel *Label_Empty;
@end

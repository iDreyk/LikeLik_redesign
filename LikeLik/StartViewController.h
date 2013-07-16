//
//  StartViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 08.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface StartViewController : UITableViewController<UIAlertViewDelegate,MBProgressHUDDelegate>{
  }

@property (nonatomic, strong) NSArray *backCityImages;
@property (nonatomic, strong) NSArray *CityLabels;
@property (nonatomic, strong) NSArray *accesors;
@property (nonatomic, retain) NSString *City;
@property (nonatomic,retain)MBProgressHUD *HUDfade;


@end

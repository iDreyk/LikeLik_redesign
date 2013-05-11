//
//  VisualTourViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 12.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>

@interface VisualTourViewController : UIViewController <RMMapViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    NSString *cataloguesPath;
    NSMutableArray *catalogues;
    
}
@property (nonatomic,retain)IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) NSString *CityName;
@property (nonatomic,retain) RMMapView *MapPhoto;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PlaceonMap;
@property (weak, nonatomic) IBOutlet UIView *PhotoCard;
@property (weak, nonatomic) IBOutlet UIButton *info_button;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScroll;
@property (nonatomic,retain)IBOutlet UIView *visualMap;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
-(IBAction)showLocation:(id)sender;
- (IBAction)tapDetected:(UIButton *)sender;
@end
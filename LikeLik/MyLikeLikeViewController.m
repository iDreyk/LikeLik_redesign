//
//  MyLikeLikeViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "MyLikeLikeViewController.h"
#import "AppDelegate.h"

#import "LocalizationSystem.h"
#import "MBProgressHUD.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface MyLikeLikeViewController ()

@end

@implementation MyLikeLikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"My LikeLik Screen"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    //// [testflight passCheckpoint:@"MyLikeLik Open"];
    LikeLikString = @[@"Moscow LikeLik",@"Vienna LikeLik"];
    LikeLikImage = @[@"icon_moscow_",@"icon_vienna_"];
    urls = @[@"https://itunes.apple.com/ru/app/likelik-moscow/id675597201?mt=8",@"https://itunes.apple.com/ru/app/vienna-likelik/id675607865?mt=8"];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.TableView.backgroundView = [InterfaceFunctions backgroundView];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"More LikeLik Apps", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
       
    
    return [LikeLikString count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    

    [cell addSubview:[InterfaceFunctions TableLabelwithText:[LikeLikString objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions corporateIdentity] AndFrame:CGRectMake((cell.frame.size.width)/3, (cell.frame.size.height)/2, 240.0, 35.0)]];
        
    
    
    //[cell addSubview:[InterfaceFunctions corporateIdentity_actb]];//actbwithColor:[indexPath row]+1]];
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
        cell.backgroundView = [InterfaceFunctions CellBG];
        cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    }
    
    //UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[LikeLikImage objectAtIndex:[indexPath row]]]];
    //[imageview setFrame:CGRectMake(15.0, 4.0, imageview.image.size.width, imageview.image.size.height)];
    //[imageview setImage:[UIImage imageNamed:@"knuckle_1"]];
    //CGPoint size =cell.center;
    //size.x = imageview.center.x;
    //imageview.center = size;
    UIImageView *preview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 78, 78)];
    UIImage * image = [UIImage imageNamed:[LikeLikImage objectAtIndex:[indexPath row]]];
    preview.image = image;
    CALayer *layer = preview.layer;
    layer.cornerRadius = 20;
    preview.clipsToBounds = YES;
    [cell addSubview:preview];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.TableView deselectRowAtIndexPath:[self.TableView indexPathForSelectedRow] animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urls objectAtIndex:[indexPath row]]]];

}


@end

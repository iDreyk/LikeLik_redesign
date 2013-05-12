//
//  MyLikeLikeViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "MyLikeLikeViewController.h"
#import "AppDelegate.h"


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
    //[TestFlight passCheckpoint:@"MyLikeLik Open"];
    LikeLikString = @[@"LikeLik Moscow",@"LikeLik Vienna",@"LikeLik Amsterdam",@"LikeLik Shanghai"];
    LikeLikImage = @[@"Fist_animated_1",@"Fist_animated_2",@"Fist_animated_3",@"Fist_animated_4"];
    
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.TableView.backgroundView = [InterfaceFunctions backgroundView];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"More LikeLik Apps", nil) AndColor:[InterfaceFunctions mainTextColor:6]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    

    [cell addSubview:[InterfaceFunctions TableLabelwithText:[LikeLikString objectAtIndex:[indexPath row]] AndColor:[InterfaceFunctions mainTextColor:row+1] AndFrame:CGRectMake((cell.frame.size.width-240.0)/2, (cell.frame.size.height-35.0)/2, 240.0, 35.0)]];
        
    
    
    [cell addSubview:[InterfaceFunctions actbwithColor:[indexPath row]+1]];
    
    cell.backgroundView = [InterfaceFunctions CellBG];
    cell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[LikeLikImage objectAtIndex:[indexPath row]]]];
    [imageview setFrame:CGRectMake(15.0, 4.0, imageview.image.size.width, imageview.image.size.height)];
    [imageview setImage:[UIImage imageNamed:@"knuckle_1"]];
    CGPoint size =cell.center;
    size.x = imageview.center.x;
    imageview.center = size;
    [cell addSubview:imageview];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.TableView deselectRowAtIndexPath:[self.TableView indexPathForSelectedRow] animated:YES];
    
}


@end

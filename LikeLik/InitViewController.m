//
//  InitViewController.m
//  LikeLik
//
//  Created by Vladimir Malov on 20.09.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "InitViewController.h"
#import "LocalizationSystem.h"
#import "Cell.h"
@interface InitViewController ()

@end

@implementation InitViewController

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
    [self.Featured setTitle:AMLocalizedString(@"Featured", nil)];
    [self.Downloaded setTitle:AMLocalizedString(@"Downloaded", nil)];
    [self.All setTitle:AMLocalizedString(@"All Guides", nil)];
    [self.Special setTitle:AMLocalizedString(@"Special Series", nil)];
    [self.TabBar setSelectedItem:self.Downloaded];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InitCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.cityImage.image = [UIImage imageNamed:@"Moscow.png"];
    cell.label.text = @"Text";
    cell.textLabel.text = @"123";
    NSLog(@"123");
//    cell.cityImage.text = @"Hello";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}

@end

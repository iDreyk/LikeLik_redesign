//
//  AboutTableViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 13.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "AboutTableViewController.h"
#import "AppDelegate.h"

#import "StartTabBarViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.SupportCell.textLabel.text = AMLocalizedString(@"Support", nil);
    self.SupportCell.textLabel.font = [AppDelegate OpenSansRegular:26];
    self.SupportCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.SupportCell.textLabel.textColor = [InterfaceFunctions mainTextColor:3];
    self.SupportCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
   
    
    self.SupportCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.SupportCell.textLabel.highlightedTextColor = self.SupportCell.textLabel.textColor;
    
    
    
    self.TermsCell.textLabel.text = AMLocalizedString(@"Terms of use", nil);
    self.TermsCell.textLabel.font = [AppDelegate OpenSansRegular:26];
    self.TermsCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.TermsCell.textLabel.textColor = [InterfaceFunctions mainTextColor:2];
    self.TermsCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    
    self.TermsCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.TermsCell.textLabel.highlightedTextColor = self.TermsCell.textLabel.textColor;
    
    
    self.AboutCell.textLabel.text = AMLocalizedString(@"About", nil);
    self.AboutCell.textLabel.font = [AppDelegate OpenSansRegular:26];
    self.AboutCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.AboutCell.textLabel.textColor = [InterfaceFunctions mainTextColor:1];//[UIColor colorWithRed:207.0/255.0       green:17.0/255.0 blue:17.0/255.0 alpha:1];
    self.AboutCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
   
    
    self.AboutCell.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.AboutCell.textLabel.highlightedTextColor = self.AboutCell.textLabel.textColor;
    
    
    
    self.MoreLikeLikApps.textLabel.text = AMLocalizedString(@"More LikeLik Apps", nil);
    self.MoreLikeLikApps.textLabel.font = [AppDelegate OpenSansRegular:26];
    self.MoreLikeLikApps.textLabel.backgroundColor   = [UIColor clearColor];
    self.MoreLikeLikApps.textLabel.textColor = [InterfaceFunctions mainTextColor:4];
    self.MoreLikeLikApps.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    
    self.MoreLikeLikApps.selectedBackgroundView = [InterfaceFunctions SelectedCellBG];
    self.MoreLikeLikApps.textLabel.highlightedTextColor = self.TermsCell.textLabel.textColor;
    
    
    //    nslog(@"%@",self.AboutCell.contentView.backgroundColor);
    
    
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:  AMLocalizedString(@"About", @"") AndColor:[InterfaceFunctions mainTextColor:6]];
    self.tableView.backgroundView = [InterfaceFunctions backgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    

    [self.parentViewController isModalInPopover];
    // NSLog(@"%d",[[self parentViewController] isKindOfClass:[CategoryTableViewController class]]);
    // NSLog(@"clase : %@",NSStringFromClass([[self parentViewController] class]) );
   
    if (![self.Parent isEqualToString:@"Category"]) {
    UIButton *back = [InterfaceFunctions done_button];
        [back  addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    }
}


-(void)Back{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if([self isMovingFromParentViewController]){
        if ([self.Parent isEqualToString:@"Splash"])
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        //specific stuff for being popped off stack
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    self.SupportCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    self.SupportCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.SupportCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    
    self.TermsCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    self.TermsCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.TermsCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];
    
    
    
    self.AboutCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    self.AboutCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.AboutCell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];

    self.MoreLikeLikApps.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    self.MoreLikeLikApps.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.MoreLikeLikApps.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.png"]];

    
    NSIndexPath *tmp = [self.tableView indexPathForSelectedRow];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:tmp];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
}
#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.isSelected == YES)
    {
        [cell setBackgroundView:[InterfaceFunctions SelectedCellBG]];
    }
    else
    {
        [cell setBackgroundView: [InterfaceFunctions CellBG]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    nslog(@"asas");
    NSIndexPath *tmp = [tableView indexPathForSelectedRow];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:tmp];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad_o_1.PNG"]];
}

- (void)viewDidUnload {
    [self setTermsCell:nil];
    [self setAboutCell:nil];
    [super viewDidUnload];
}
@end

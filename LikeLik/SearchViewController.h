//
//  SearchViewController.h
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate>
@property (nonatomic,retain)NSString *CityName;
@property (nonatomic, retain)NSArray *PlacesArray;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UITableView *SearchTable;
@property (weak, nonatomic) IBOutlet NSArray *readyArray;

@end

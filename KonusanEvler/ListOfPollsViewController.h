//
//  ListOfPollsViewController.h
//  Polls
//
//  Created by Hadi Hatunoglu on 31/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface ListOfPollsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (BOOL)connected ;

@end

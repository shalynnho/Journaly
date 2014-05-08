//
//  SHOEntryTableViewController.h
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOEntryDetailViewController.h"

@interface SHOEntryTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) SHOEntryDetailViewController* entryDetailController;
@property (nonatomic, strong) NSMutableArray *postArray;

@end

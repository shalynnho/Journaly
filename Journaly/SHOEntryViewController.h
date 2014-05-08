//
//  SHOFirstViewController.h
//  Journaly
//
//  created by Shalynn Ho <shalynkh@usc.edu> on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PhotoDetailViewController.h"
#import "MBProgressHUD.h"
#import "SHOEntryTableViewController.h"

@interface SHOEntryViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *refreshHUD;
    NSMutableArray *allImages;
    NSInteger segIndex;
    
    SHOEntryTableViewController* childController;
    UITableView* childTableView;
    
}

- (IBAction)logOutButtonTapAction:(id)sender;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@end

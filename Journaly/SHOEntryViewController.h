//
//  SHOFirstViewController.h
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PhotoDetailViewController.h"
#import "MBProgressHUD.h"

@interface SHOEntryViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *refreshHUD;
    NSMutableArray *allImages;
    NSInteger segIndex;
    
}

- (IBAction)logOutButtonTapAction:(id)sender;
- (IBAction)refreshPhotos:(id)sender;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@end

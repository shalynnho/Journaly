//
//  SHOSecondViewController.h
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHOEntryViewController.h"

@interface SHOCameraViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)logOutButtonTapAction:(id)sender;

@end

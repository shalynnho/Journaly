//
//  SHOFirstViewController.h
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SignupLoginViewController.h"

@interface SHOFirstViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

//@property (strong, nonatomic) PFSignUpViewController* signUpViewController;
//@property (strong, nonatomic) PFLogInViewController* loginViewController;

- (IBAction)logOutButtonTapAction:(id)sender;

@end

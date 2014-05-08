//
//  SHOThirdViewController.h
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOEntryViewController.h"

@interface SHOComposeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate> 


- (IBAction)logOutButtonTapAction:(id)sender;


@end

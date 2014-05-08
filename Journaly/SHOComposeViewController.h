//
//  SHOThirdViewController.h
//  Journaly
//
//  created by Shalynn Ho <shalynkh@usc.edu> on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOEntryViewController.h"

@interface SHOComposeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate> 


- (IBAction)logOutButtonTapAction:(id)sender;


@end

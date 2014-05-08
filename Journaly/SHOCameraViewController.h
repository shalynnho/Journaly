//
//  SHOSecondViewController.h
//  Journaly
//
//  created by Shalynn Ho <shalynkh@usc.edu> on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHOEntryViewController.h"
#import "MBProgressHUD.h"

@interface SHOCameraViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
}

- (void)uploadImage:(NSData *)imageData;
- (IBAction)logOutButtonTapAction:(id)sender;

@end

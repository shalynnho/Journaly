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
#import "MBProgressHUD.h"

@interface SHOCameraViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate> {
    
    
    NSMutableArray *allImages;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    
}

- (IBAction)refresh:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (IBAction)logOutButtonTapAction:(id)sender;
- (void)buttonTouched:(id)sender;

@end

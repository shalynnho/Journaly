//
//  SHOFirstViewController.m
//  Journaly
//
//  Created by Derp Derp on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import "SHOEntryViewController.h"

@interface SHOEntryViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIView *entryContainerView;

@end

@implementation SHOEntryViewController

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        //self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
    } else {
        //self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        [self showLoginPane];
    } else {
        
        if (segIndex == 1) {
            [self refreshPhotos:nil];
        } else {
            [self refreshPosts];
        }
    }
}

- (IBAction)refresh:(id)sender {
    if (segIndex == 0) {
        [childController.postArray removeAllObjects];
        [self refreshPosts];
    } else { // refresh photos
        [self refreshPhotos:nil];
    }
}

- (void)refreshPosts {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"JournalEntry"];
    [postQuery orderByAscending:@"createdAt"];
    
    // Follow relationship
    [postQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError *error) {
        if (!error) {
            childController.postArray = [NSMutableArray arrayWithArray:objects];           // Store results
            [childTableView reloadData];   // Reload table
        }
    }];
}

- (IBAction)refreshPhotos:(id)sender {
    NSLog(@"Showing Refresh HUD");
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (refreshHUD) {
                [refreshHUD hide:YES];
                
                refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:refreshHUD];
                
                // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                refreshHUD.mode = MBProgressHUDModeCustomView;
                
                refreshHUD.delegate = self;
            }
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs
            NSMutableArray *oldCompareObjectIDArray = [NSMutableArray array];
            for (UIView *view in [_photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *eachButton = (UIButton *)view;
                    [oldCompareObjectIDArray addObject:[eachButton titleForState:UIControlStateReserved]];
                }
            }
            
            NSMutableArray *oldCompareObjectIDArray2 = [NSMutableArray arrayWithArray:oldCompareObjectIDArray];
            
            // If there are photos, we start extracting the data
            // Save a list of object IDs while extracting this data
            
            NSMutableArray *newObjectIDArray = [NSMutableArray array];
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [newObjectIDArray addObject:[eachObject objectId]];
                }
            }
            
            // Compare the old and new object IDs
            NSMutableArray *newCompareObjectIDArray = [NSMutableArray arrayWithArray:newObjectIDArray];
            NSMutableArray *newCompareObjectIDArray2 = [NSMutableArray arrayWithArray:newObjectIDArray];
            if (oldCompareObjectIDArray.count > 0) {
                // New objects
                [newCompareObjectIDArray removeObjectsInArray:oldCompareObjectIDArray];
                // Remove old objects if you delete them using the web browser
                [oldCompareObjectIDArray removeObjectsInArray:newCompareObjectIDArray2];
                if (oldCompareObjectIDArray.count > 0) {
                    // Check the position in the objectIDArray and remove
                    NSMutableArray *listOfToRemove = [[NSMutableArray alloc] init];
                    for (NSString *objectID in oldCompareObjectIDArray){
                        int i = 0;
                        for (NSString *oldObjectID in oldCompareObjectIDArray2){
                            if ([objectID isEqualToString:oldObjectID]) {
                                // Make list of all that you want to remove and remove at the end
                                [listOfToRemove addObject:[NSNumber numberWithInt:i]];
                            }
                            i++;
                        }
                    }
                    
                    // Remove from the back
                    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                    [listOfToRemove sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                    
                    for (NSNumber *index in listOfToRemove){
                        [allImages removeObjectAtIndex:[index intValue]];
                    }
                }
            }
            
            // Add new objects
            for (NSString *objectID in newCompareObjectIDArray){
                for (PFObject *eachObject in objects){
                    if ([[eachObject objectId] isEqualToString:objectID]) {
                        NSMutableArray *selectedPhotoArray = [[NSMutableArray alloc] init];
                        [selectedPhotoArray addObject:eachObject];
                        
                        if (selectedPhotoArray.count > 0) {
                            [allImages addObjectsFromArray:selectedPhotoArray];
                        }
                    }
                }
            }
            
            // Remove and add from objects before this
            [self setUpImages:allImages];
            
        } else {
            [refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    allImages = [images mutableCopy];
    
    // This method sets up the downloaded images and places them nicely in a grid
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        // Iterate over all images and get the data from the PFFile
        for (int i = 0; i < images.count; i++) {
            PFObject *eachObject = [images objectAtIndex:i];
            PFFile *theImage = [eachObject objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageDataArray addObject:image];
        }
        
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove old grid
            for (UIView *view in [_photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            // Create the buttons necessary for each image in the grid
            for (int i = 0; i < [imageDataArray count]; i++) {
                PFObject *eachObject = [images objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [imageDataArray objectAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.frame = CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                          THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                          THUMBNAIL_WIDTH,
                                          THUMBNAIL_HEIGHT);
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [_photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / THUMBNAIL_COLS;
            if (((float)images.count / THUMBNAIL_COLS) - rows != 0) {
                rows++;
            }
            int height = THUMBNAIL_HEIGHT * rows + PADDING * rows + PADDING + PADDING_TOP;
            
            _photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            _photoScrollView.clipsToBounds = YES;
        });
    });
}

- (void)buttonTouched:(id)sender {
    // When picture is touched, open a viewcontroller with the image
    PFObject *theObject = (PFObject *)[allImages objectAtIndex:[sender tag]];
    PFFile *theImage = [theObject objectForKey:@"imageFile"];
    
    NSData *imageData;
    imageData = [theImage getData];
    UIImage *selectedPhoto = [UIImage imageWithData:imageData];
    PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
    
    pdvc.selectedImage = selectedPhoto;
    [self presentViewController:pdvc animated:YES completion:nil];
}

- (IBAction)toggleEntriesView:(id)sender {
    UISegmentedControl* sc = (UISegmentedControl*)sender;
    segIndex = sc.selectedSegmentIndex;
    if (segIndex == 0) { // Posts
        [self.photoScrollView setHidden:YES];
        [self.entryContainerView setHidden:NO];
    } else { // Photos
        [self.photoScrollView setHidden:NO];
        [self.entryContainerView setHidden:YES];
    }
}

- (void)showLoginPane {
    // Create the log in view controller
    PFLogInViewController* loginViewController = [[PFLogInViewController alloc] init];
    [loginViewController setDelegate:self]; // Set ourselves as the delegate
    [loginViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    
    // Create the sign up view controller
    PFSignUpViewController* signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [loginViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:loginViewController animated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![PFUser currentUser]) { // No user logged in
        [self showLoginPane];
    }
    
    allImages = [[NSMutableArray alloc] init];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", nil) message:NSLocalizedString(@"Incorrect username or password. Please check your login information and try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Signup Failed", nil) message:NSLocalizedString(@"Invalid username or password. Please check your information and try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - Logout

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self showLoginPane];
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"tableViewEmbedSegue"]) {
        childController = (SHOEntryTableViewController*) [segue destinationViewController];
        childTableView = (UITableView*) childController.view;
    }
}

@end

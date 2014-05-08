//
//  SHOThirdViewController.m
//  Journaly
//
//  created by Shalynn Ho <shalynkh@usc.edu> on 5/7/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import "SHOComposeViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface SHOComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addEntryTitle;
@property (weak, nonatomic) IBOutlet UITextView *addEntryText;

@end

@implementation SHOComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                
        _addEntryText.layoutManager.allowsNonContiguousLayout = NO;
        
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)saveButtonTapped:(id)sender {
    // Create Post
    PFObject *newEntry = [PFObject objectWithClassName:@"JournalEntry"];
    
    // Set text content
    [newEntry setObject:_addEntryText.text forKey:@"text"];
    
    // Set title
    [newEntry setObject:_addEntryTitle.text forKey:@"title"];
    
    // Create relationship
    [newEntry setObject:[PFUser currentUser] forKey:@"user"];
    
    // Set ACL permissions for added security
    newEntry.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    // Save new Post object in Parse
    [newEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon success
        }
    }];
}


- (IBAction)textFieldExit:(id)sender {
    [sender resignFirstResponder];
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

// this seems to satisfy all of the requirements listed above–if you are targeting iOS 7.1
- (void)textViewDidChange:(UITextView *)textView
{
//    if ([textView.text hasSuffix:@"\n"]) {
//        
//        [CATransaction setCompletionBlock:^{
//            [self scrollToCaretInTextView:textView animated:NO];
//        }];
//        
//    } else {
//        [self scrollToCaretInTextView:textView animated:NO];
//    }
    [self scrollTextViewToBottom:textView];
}

// helper method
- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
    
}

#pragma mark Keyboard methods

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = _addEntryText.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_addEntryText.superview setFrame:bkgndRect];
    [_addEntryText setContentOffset:CGPointMake(0.0, _addEntryText.frame.origin.y-kbSize.height) animated:YES];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_addEntryText.contentInset.top, 0.0, kbSize.height, 0.0);
    _addEntryText.contentInset = contentInsets;
    _addEntryText.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    NSLog(@"keyboardWasShown IS CALLED");
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    if (!CGRectContainsPoint(aRect, _addEntryText.frame.origin) ) {
        [_addEntryText scrollRectToVisible:_addEntryText.frame animated:YES];
    }
    
    [UIView commitAnimations];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillBeHidden IS CALLED");

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _addEntryText.contentInset = contentInsets;
    _addEntryText.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardIsUp:(NSNotification *)notification
{
    NSLog(@"keyboardIsUp IS CALLED");

    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = _addEntryText.contentInset;
    inset.bottom = keyboardRect.size.height;
    _addEntryText.contentInset = inset;
    _addEntryText.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:_addEntryText animated:YES];
}


- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self showLoginPane];
    //    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

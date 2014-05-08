//
//  SHOEntryDetailViewController.m
//  Journaly
//
//  created by Shalynn Ho <shalynkh@usc.edu> on 5/8/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import "SHOEntryDetailViewController.h"

@interface SHOEntryDetailViewController ()


@property (weak, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@end

@implementation SHOEntryDetailViewController

- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        // Custom initialization
        
        NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
        NSString *objectID = [fetchDefaults objectForKey:@"objectID"];
        PFObject* obj = [PFQuery getObjectOfClass:@"JournalEntry" objectId:objectID];
        _detailItem = obj;
        
        NSString* title = (NSString*) [obj objectForKey:@"title"];
        NSString* text = (NSString*) [obj objectForKey:@"text"];
        NSLog(@"ID: %@, title: %@, text:%@", objectID, title,text);
        _detailTitle.title = title;
        _detailText.text = text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (IBAction)editButtonTapped:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SHOEntryDetailViewController.m
//  Journaly
//
//  Created by Derp Derp on 5/8/14.
//  Copyright (c) 2014 SHO. All rights reserved.
//

#import "SHOEntryDetailViewController.h"

@interface SHOEntryDetailViewController ()


@property (weak, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@end

@implementation SHOEntryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFObject* object = (PFObject*) _detailItem;
    _detailTitle.title = [[object objectForKey:@"title"] stringByAppendingString:@""];
    _detailText.text = [[object objectForKey:@"text"] stringByAppendingString:@""];
}

- (IBAction)editButtonTapped:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

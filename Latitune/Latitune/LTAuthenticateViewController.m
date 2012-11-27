//
//  LTAuthenticateViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/26/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTAuthenticateViewController.h"

typedef enum {
  LoginIndex = 0,
  RegisterIndex = 1
} AuthenticateIndex;

@interface LTAuthenticateViewController ()

@end

@implementation LTAuthenticateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Functions

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  if (indexPath.row == LoginIndex) {
    cell.textLabel.text = @"Login";
    cell.accessibilityLabel = @"Login Button";
  } else if (indexPath.row == RegisterIndex) {
    cell.textLabel.text = @"Register";
    cell.accessibilityLabel = @"Register Button";
  }
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == LoginIndex) {
    [self performSegueWithIdentifier:@"showLoginSegue" sender:self];
  } else if (indexPath.row == RegisterIndex) {
    [self performSegueWithIdentifier:@"showRegisterSegue" sender:self];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

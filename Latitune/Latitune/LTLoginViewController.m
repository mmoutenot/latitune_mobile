//
//  LTLoginViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/12/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTLoginViewController.h"
#import "SVProgressHUD.h"
#import "LTRegisterViewController.h"
#import "LTBlipViewController.h"
#import "LTTextCell.h"

typedef enum {
  FormSection = 0,
  ButtonSection = 1
} RegisterSection;

typedef enum {
  UsernameField = 0,
  PasswordField = 1,
} FormField;

@interface LTLoginViewController ()

@end

@implementation LTLoginViewController
@synthesize textFields, fieldPrompts, accessibilityLabels;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  fieldPrompts = @[@"Username",@"Password"];
  accessibilityLabels = @[@"Username field",@"Password field"];
  textFields = [[NSMutableArray alloc] initWithObjects:[NSNull null],[NSNull null],nil];
  self.view.accessibilityLabel = @"Login View";

}

- (void)viewWillAppear:(BOOL)animated {
}

- (void) loginDidFailWithError:(NSNumber *)errorCode {
  if ([errorCode isEqualToNumber:@(InvalidAuthentication)]) {
    [SVProgressHUD showErrorWithStatus:@"Incorrect Password"];
  } else {
    [SVProgressHUD showErrorWithStatus:@"Username Does Not Exist"];
  }
}

- (void)loginDidSucceedWithUser:(NSDictionary *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
  [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Functions

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == FormSection) {
    return 2;
  } else if (section == ButtonSection) {
    return 1;
  }
  return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  static NSString *FormCellIdentifier = @"FormCell";
  UITableViewCell *cell;
  if (indexPath.section == FormSection){
    cell = [tableView dequeueReusableCellWithIdentifier:FormCellIdentifier];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  }
  if (cell == nil) {
    if (indexPath.section == FormSection) {
      cell = [[LTTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FormCellIdentifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }
  if (indexPath.section == FormSection) {
    cell.textLabel.text = fieldPrompts[indexPath.row];
    cell.accessibilityLabel = [NSString stringWithFormat:@"%@ cell",fieldPrompts[indexPath.row]];
    [(LTTextCell *)cell textField].accessibilityLabel = accessibilityLabels[indexPath.row];
    [(LTTextCell *)cell textField].delegate = self;
    [textFields replaceObjectAtIndex:indexPath.row withObject:[(LTTextCell *)cell textField]];
    if (indexPath.row == PasswordField) {
      [(LTTextCell *)cell textField].returnKeyType = UIReturnKeyDone;
      [(LTTextCell *)cell textField].secureTextEntry = TRUE;
    }
  } else {
    cell.textLabel.text = @"Submit";
    cell.accessibilityLabel = @"Login Submit Button";
  }
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == ButtonSection) {
    for (UITextField *field in textFields) {
      if ([field.text isEqualToString:@""]) {
        NSInteger textFieldIdx = [textFields indexOfObjectIdenticalTo:field];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ Field Is Blank",fieldPrompts[textFieldIdx]]];
        return;
      }
    }
    NSString *username = [(UITextField *)textFields[UsernameField] text];
    NSString *password = [(UITextField *)textFields[PasswordField] text];
    [SVProgressHUD showWithStatus:@"Logging In"];
    [[LTCommunication sharedInstance] loginWithUsername:username password:password withDelegate:self];
  }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  NSInteger textFieldIdx = [textFields indexOfObjectIdenticalTo:textField];
  if (textFieldIdx != PasswordField) {
    [textFields[textFieldIdx+1] becomeFirstResponder];
    return NO;
  } else {
    [textField resignFirstResponder];
    return YES;
  }
}


@end

//
//  LTRegisterViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/11/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTRegisterViewController.h"
#import "LTCommunication.h"
#import "SVProgressHUD.h"
#import "LTBlipViewController.h"
#import "LTTextCell.h"
#import "LTAppDelegate.h"

typedef enum {
  FormSection = 0,
  ButtonSection = 1
} RegisterSection;

typedef enum {
  UsernameField = 0,
  EmailField = 1,
  PasswordField = 2,
  PasswordAgainField = 3
} FormField;

@interface LTRegisterViewController ()

@end

@implementation LTRegisterViewController

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
  fieldPrompts = @[@"Username",@"Email",@"Password",@"Password Again"];
  accessibilityLabels = @[@"Username field",@"Email field",@"Password field",@"Password Again field"];
  textFields = [[NSMutableArray alloc] initWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
  self.view.accessibilityLabel = @"Register View";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
}

- (void) createUserDidFail {
  NSLog(@"register fail");
  [SVProgressHUD showErrorWithStatus:@"Registration Failed"];
}

- (void) createUserDidSucceedWithUser:(NSDictionary *)user {
  [SVProgressHUD showSuccessWithStatus:@"Registration Successful"];
  
  UINavigationController *mainNavC = (UINavigationController*)[self presentingViewController];
  UITabBarController *mainViewC = (UITabBarController*)mainNavC.topViewController;
  [self dismissViewControllerAnimated:YES completion:^{
    [mainViewC performSegueWithIdentifier:@"showInstructionsSegue" sender:self];
  }];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
  NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Table View Functions

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == FormSection) {
    return 4;
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
    //if (indexPath.row == UsernameField) {
    cell.textLabel.text = fieldPrompts[indexPath.row];
    cell.accessibilityLabel = [NSString stringWithFormat:@"%@ cell",fieldPrompts[indexPath.row]];
    [(LTTextCell *)cell textField].accessibilityLabel = accessibilityLabels[indexPath.row];
    [(LTTextCell *)cell textField].delegate = self;
    [textFields replaceObjectAtIndex:indexPath.row withObject:[(LTTextCell *)cell textField]];
    if (indexPath.row == PasswordAgainField) {
      [(LTTextCell *)cell textField].returnKeyType = UIReturnKeyDone;
    }
    if (indexPath.row == PasswordAgainField || indexPath.row == PasswordField) {
      [(LTTextCell *)cell textField].secureTextEntry = TRUE;
    }
  } else {
    cell.textLabel.text = @"Submit";
    cell.accessibilityLabel = @"Register Submit Button";
  }
  return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == ButtonSection) {
    for (UITextField *field in textFields) {
      if ([field.text isEqualToString:@""]) {
        NSInteger textFieldIdx = [textFields indexOfObjectIdenticalTo:field];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ field is empty",fieldPrompts[textFieldIdx]]];
        return;
      }
    }
    
    if (![self NSStringIsValidEmail:[(UITextField *)textFields[EmailField] text]]){
      [SVProgressHUD showErrorWithStatus:@"Invalid Email"];
      return;
    }
    
    if (![[(UITextField *)textFields[PasswordField] text] isEqualToString:[(UITextField *)textFields[PasswordAgainField] text]]) {
      [SVProgressHUD showErrorWithStatus:@"Passwords Don't Match"];
      return;
    }
    NSString *username = [(UITextField *)textFields[UsernameField] text];
    NSString *email = [(UITextField *)textFields[EmailField] text];
    NSString *password = [(UITextField *)textFields[PasswordField] text];
    [SVProgressHUD showWithStatus:@"Registering"];
    [[LTCommunication sharedInstance] createUserWithUsername:username email:email password:password withDelegate:self];
  }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  NSInteger textFieldIdx = [textFields indexOfObjectIdenticalTo:textField];
  if (textFieldIdx != PasswordAgainField) {
    [textFields[textFieldIdx+1] becomeFirstResponder];
    return NO;
  } else {
    [textField resignFirstResponder];
    return YES;
  }
}

@end

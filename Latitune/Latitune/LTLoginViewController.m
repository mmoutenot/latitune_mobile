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

@interface LoginObject : NSObject

@property (strong,nonatomic) NSString *username, *password;

@end

@implementation LoginObject

@synthesize username, password;

@end

@interface LTLoginViewController ()
{
  LoginObject *logObj;
}

@end

@implementation LTLoginViewController
@synthesize formModel;

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
  logObj = [[LoginObject alloc] init];
  logObj.username = @"";
  logObj.password = @"";
}

- (void)viewWillAppear:(BOOL)animated {
  self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
  [FKFormMapping mappingForClass:[LoginObject class] block:^(FKFormMapping *mapping) {
    [mapping sectionWithTitle:@"Login" identifier:@"login"];
    [mapping mapAttribute:@"username" title:@"Username" type:FKFormAttributeMappingTypeText];
    [mapping mapAttribute:@"password" title:@"Password" type:FKFormAttributeMappingTypePassword];
    [mapping buttonSave:@"Login" handler:^{
      if ([logObj.username length] && [logObj.password length]) {
        [[LTCommunication sharedInstance] loginWithUsername:logObj.username password:logObj.password withDelegate:self];
          [SVProgressHUD showWithStatus:@"Logging In"];
      } else {
        [SVProgressHUD showErrorWithStatus:@"Empty field"];
      }
    }];
    [mapping sectionWithTitle:@"" identifier:@"registerpadding"];
    [mapping button:@"Register" identifier:@"register" handler:^(id object) {
      [self performSegueWithIdentifier:@"registerSegue" sender:nil];
    } accesoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.formModel registerMapping:mapping];
  }];
  [self.formModel loadFieldsWithObject:logObj];
}

- (void) loginDidFail {
  [SVProgressHUD showErrorWithStatus:@"Login failed"];
}

- (void)loginDidSucceedWithUser:(NSDictionary *)user {
  LTBlipViewController *blipViewC = [(UITabBarController*)[self presentingViewController] viewControllers][1];
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"%@",[self presentingViewController]);
    [blipViewC showMediaPicker:nil];
  }];
  [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  LTRegisterViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/11/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTRegisterViewController.h"

@interface RegisterObject : NSObject

@property (strong,nonatomic) NSString *username, *email, *password, *passwordAgain;

@end

@implementation RegisterObject

@synthesize username, email, password, passwordAgain;

@end

@interface LTRegisterViewController ()

@end

@implementation LTRegisterViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
  self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
  [FKFormMapping mappingForClass:[RegisterObject class] block:^(FKFormMapping *mapping) {
    [mapping sectionWithTitle:@"Register" identifier:@"register"];
    [mapping mapAttribute:@"username" title:@"Username" type:FKFormAttributeMappingTypeText];
    [mapping mapAttribute:@"email" title:@"E-mail" type:FKFormAttributeMappingTypeText];
    [mapping mapAttribute:@"password" title:@"Password" type:FKFormAttributeMappingTypePassword];
    [mapping mapAttribute:@"passwordAgain" title:@"Password Again" type:FKFormAttributeMappingTypePassword];
    [mapping buttonSave:@"Register" handler:^{
    }];
    [self.formModel registerMapping:mapping];
  }];

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

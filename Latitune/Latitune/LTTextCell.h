//
//  LTTextCell.h
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CellTextFieldWidth 150.0
#define MarginBetweenControls 20.0

@interface LTTextCell : UITableViewCell {
  UITextField *textField;
}

@property (nonatomic, strong) UITextField *textField;

@end

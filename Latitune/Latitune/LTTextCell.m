//
//  LTTextCell.m
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTTextCell.h"

@implementation LTTextCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      textField = [[UITextField alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width - CellTextFieldWidth-25, 12.0,CellTextFieldWidth,25.0)];
      textField.clearsOnBeginEditing = NO;
      textField.textAlignment = NSTextAlignmentRight;
      textField.returnKeyType = UIReturnKeyNext;
      textField.backgroundColor = [UIColor clearColor];
      [self.textLabel setFrame:CGRectMake(0, 12, self.contentView.bounds.size.width-CellTextFieldWidth-MarginBetweenControls, 25.0)];
      [self.contentView addSubview:textField];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
 //   [super setSelected:selected animated:animated];
  [textField becomeFirstResponder];
    // Configure the view for the selected state
}

/*- (void) layoutSubviews {
  CGRect rect = CGRectMake(self.contentView.bounds.size.width - 15.0, 12.0,-CellTextFieldWidth,25.0);
  [textField setFrame:rect];
  CGRect rect2 = CGRectMake(MarginBetweenControls,12.0,self.contentView.bounds.size.width - CellTextFieldWidth - MarginBetweenControls,25.0);
  NSLog(@"%@",NSStringFromCGRect(rect2));
  UILabel *theTextLabel = (UILabel *)[self textLabel];
  [theTextLabel setFrame:rect2];
}*/

@end

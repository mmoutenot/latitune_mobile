//
//  LTInstructionsViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTInstructionsViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;

- (IBAction)close:(id)sender;

@end

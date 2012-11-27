//
//  LTInstructionsViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTInstructionsViewController.h"

@interface LTInstructionsViewController ()

@end

@implementation LTInstructionsViewController

@synthesize pageController, pageControl, closeButton;

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
  closeButton.accessibilityLabel = @"Close Instructions Button";
  pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  pageController.delegate = self;
  pageController.dataSource = self;
  [pageController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"Instructions1"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
  CGRect viewRect = self.view.bounds;
  [pageController.view setFrame:CGRectMake(viewRect.origin.x, viewRect.origin.y, viewRect.size.width, viewRect.size.height-36)];
  [self.view addSubview:pageController.view];
  self.view.gestureRecognizers = self.pageController.gestureRecognizers;
  self.view.accessibilityLabel = @"Instructions View";
  self.pageControl.numberOfPages = 2;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Page Controller Delegate

- (void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  UIViewController *vc = pageViewController.viewControllers[0];
  [pageControl setCurrentPage:vc.view.tag];
}

#pragma mark - Page Controller Data Source

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
  // Return the data view controller for the given index.
  if (index >= 3) {
    return nil;
  }
  // Create a new view controller and pass suitable data.
  UIViewController * viewc = [storyboard instantiateViewControllerWithIdentifier:@"Instructions1"];
  viewc.view.tag = index;
  return viewc;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
  // Return the index of the given data view controller.
  // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
  return viewController.view.tag;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index = [self indexOfViewController:viewController];
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  
  index--;
  return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = [self indexOfViewController:viewController];
  if (index == NSNotFound) {
    return nil;
  }
  
  index++;
  if (index == 2) {
    return nil;
  }
  return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}


@end

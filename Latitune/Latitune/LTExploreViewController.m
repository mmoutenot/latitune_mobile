//
//  LTFirstViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTExploreViewController.h"
#import "LTLocationController.h"

@interface LTExploreViewController ()

@end

@implementation LTExploreViewController
@synthesize blips, webViewPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
  LTLocationController *locationController = [LTLocationController sharedInstance];
  locationController.delegate = self;
  CLLocationCoordinate2D location = [locationController location];
  GeoPoint point;
  point.lat = location.latitude;
  point.lng = location.longitude;
  [[LTCommunication sharedInstance] getBlipsNearLocation:point withDelegate:self];
  blips = [[NSMutableArray alloc] init];
  webViewPlayer = [[UIWebView alloc] init];
  webViewPlayer.delegate = self;
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getBlipsDidSucceedWithBlips:(NSArray *)_blips {
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D currentLocationCoordinate = [locationController location];
  CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocationCoordinate.latitude
                                                           longitude:currentLocationCoordinate.longitude];
  __block int waiting = 0;
  for (Blip *blip in _blips) {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:blip.location.lat longitude:blip.location.lng];
    waiting++;
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      waiting--;
      NSDictionary *locationData = @{@"description":((CLPlacemark*)placemarks[0]).name,@"latlng":location,@"song":blip.song};
      NSUInteger newIndex = [blips indexOfObject:locationData
                                   inSortedRange:(NSRange){0, [blips count]}
                                         options:NSBinarySearchingInsertionIndex
                                     usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                       CLLocation *obj1location = obj1[@"latlng"];
                                       CLLocation *obj2location = obj2[@"latlng"];
                                       return [@([obj1location distanceFromLocation:currentLocation]) compare:@([obj2location distanceFromLocation:currentLocation])] ;
                                     }];
      [blips insertObject:locationData atIndex:newIndex];
      if (waiting == 0) {
        for (NSDictionary *loc in blips) {
          NSLog(@"%@ by %@ at %@",((Song *)loc[@"song"]).title, ((Song *)loc[@"song"]).artist, loc[@"description"]);
        }
        [self.tableView reloadData];
      }
    }];
  }
}

- (void) getBlipsDidFail {
  NSLog(@"get blips fail");
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [blips count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  NSDictionary *blipDict = blips[indexPath.row];
  Song *song = blipDict[@"song"];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", song.title, song.artist];
  cell.detailTextLabel.text = blipDict[@"description"];
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D currentLocationCoordinate = [locationController location];
  float heading = [self getHeadingForDirectionFromCoordinate:currentLocationCoordinate toCoordinate:((CLLocation*)blipDict[@"latlng"]).coordinate];
  cell.imageView.image = [UIImage imageNamed:@"glyphicons_233_direction.png"];
  return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
  NSDictionary* selBlipDict = blips[indexPath.row];
  Song* selSong = selBlipDict[@"song"];
  NSString *selSongID = selSong.providerSongID;
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&autoplay=1", YOUTUBE_PREFIX, selSongID]];
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  [webViewPlayer loadRequest:requestObj];
  NSLog(@"Loaded webview with %@", url);
}

- (UIButton *)findButtonInView:(UIView *)view {
  UIButton *button = nil;
  
  if ([view isMemberOfClass:[UIButton class]]) {
    return (UIButton *)view;
  }
  
  if (view.subviews && [view.subviews count] > 0) {
    for (UIView *subview in view.subviews) {
      button = [self findButtonInView:subview];
      if (button) return button;
    }
  }
  
  return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
  NSLog(@"TRALALAL");
  _webView.mediaPlaybackRequiresUserAction=FALSE;
  UIButton *b = [self findButtonInView:_webView];
  [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
  
  CGFloat angleInRadians = angle * (M_PI / 180);
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGRect imgRect = CGRectMake(0, 0, width, height);
  CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
  CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                 rotatedRect.size.width,
                                                 rotatedRect.size.height,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
  CGContextSetAllowsAntialiasing(bmContext, YES);
  CGContextSetShouldAntialias(bmContext, YES);
  CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
  CGColorSpaceRelease(colorSpace);
  CGContextTranslateCTM(bmContext,
                        +(rotatedRect.size.width/2),
                        +(rotatedRect.size.height/2));
  CGContextRotateCTM(bmContext, angleInRadians);
  CGContextTranslateCTM(bmContext,
                        -(rotatedRect.size.width/2),
                        -(rotatedRect.size.height/2));
  CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                           rotatedRect.size.width,
                                           rotatedRect.size.height),
                     imgRef);
  
  
  
  CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
  CFRelease(bmContext);
  return rotatedImage;
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
  float fLat = degreesToRadians(fromLoc.latitude);
  float fLng = degreesToRadians(fromLoc.longitude);
  float tLat = degreesToRadians(toLoc.latitude);
  float tLng = degreesToRadians(toLoc.longitude);
  
  float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
  
  if (degree >= 0) {
    return degree;
  } else {
    return 360+degree;
  }
}

-(void)locationUpdate:(CLLocation *)location {
  NSArray *visibleCells= [self.tableView visibleCells];
  for (UITableViewCell* cell in visibleCells) {
    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    NSDictionary *blipDict = blips[cellIndex];
    float heading = [self getHeadingForDirectionFromCoordinate:location.coordinate toCoordinate:((CLLocation*)blipDict[@"latlng"]).coordinate];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    //[UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadians(heading));
    cell.imageView.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
  }
}

@end

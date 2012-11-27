//
//  LTExploreViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTExploreViewController.h"
#import "LTLocationController.h"
#import "LTYouTubeViewController.h"

@interface LTExploreViewController ()

@end

@implementation LTExploreViewController
@synthesize blips, webViewPlayer, controller;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // get location controller singleton and get current location
  LTLocationController *locationController = [LTLocationController sharedInstance];
  locationController.delegate = self;
  CLLocationCoordinate2D location = [locationController location];
  GeoPoint point;
  point.lat = location.latitude;
  point.lng = location.longitude;
  
  [[LTCommunication sharedInstance] getBlipsNearLocation:point withDelegate:self];
  blips = [[NSMutableArray alloc] init];
  
  // web view player to play youtube videos in the background
  webViewPlayer = [[UIWebView alloc] init];
  webViewPlayer.delegate = self;
  
  // timer for updating compass
  [NSTimer scheduledTimerWithTimeInterval:0.1
                                   target:self
                                 selector:@selector(updateCompass)
                                 userInfo:nil
                                  repeats:YES];
  
  // 'pull to refresh' control
  UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
  [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refresh;
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

// callback for the communication to handle get 'getBlipsNearLocation' response
- (void) getBlipsDidSucceedWithBlips:(NSArray *)_blips {
  // get location controller from location singleton and current location
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D currentLocationCoordinate = [locationController location];
  CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocationCoordinate.latitude
                                                           longitude:currentLocationCoordinate.longitude];
  NSLog(@"getting blips %@ %@\n\n\n", _blips, blips);
  __block int waiting = 0;
  for (Blip *blip in _blips) {
    BOOL addBlip = true;
    for (NSDictionary *existingLocationData in blips) {
      NSInteger existingBlipID = ((Blip *)[existingLocationData objectForKey:@"blip"]).blipID;
      NSLog(@"%d - %d", blip.blipID, existingBlipID);
      if (blip.blipID == existingBlipID){
        addBlip = false;
      }
    }
    NSLog(@"%d",addBlip);
    // only add blip if it doesn't already exist in the table
    if (addBlip){
      CLLocation *location = [[CLLocation alloc] initWithLatitude:blip.location.lat longitude:blip.location.lng];
      
      // skip if it is far away
      NSLog(@"%f",[location distanceFromLocation:currentLocation]);
      if ([location distanceFromLocation:currentLocation] > 8000) continue;
      
      waiting++;
      [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        waiting--;
        NSDictionary *locationData = @{@"description":((CLPlacemark*)placemarks[0]).name,@"latlng":location,@"song":blip.song, @"blip":blip};
        
        // order by distance
        NSUInteger newIndex = [blips indexOfObject:locationData
                                     inSortedRange:(NSRange){0, [blips count]}
                                           options:NSBinarySearchingInsertionIndex
                                   usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                     CLLocation *obj1location = obj1[@"latlng"];
                                     CLLocation *obj2location = obj2[@"latlng"];
                                     return [@([obj1location distanceFromLocation:currentLocation]) compare:@([obj2location distanceFromLocation:currentLocation])] ;
                                   }];
        [blips insertObject:locationData atIndex:newIndex];
        if (true) {
          for (NSDictionary *loc in blips) {
            NSLog(@"%@ by %@ at %@",((Song *)loc[@"song"]).title, ((Song *)loc[@"song"]).artist, loc[@"description"]);
          }
          [self.tableView reloadData];
        }
      }];
    }
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
  if (cell.accessoryView.tag != 3) {
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    accessoryView.tag = 3;
    UIImageView *compassView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    compassView.contentMode = UIViewContentModeScaleAspectFit;
    compassView.frame = CGRectMake(0,5,44,22);
    compassView.tag = 0;
    UILabel *mileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 44, 22)];
    mileLabel.font = [UIFont systemFontOfSize:14];
    mileLabel.tag = 1;
    [accessoryView addSubview:mileLabel];
    [accessoryView addSubview:compassView];
    [cell setAccessoryView:accessoryView];
    [mileLabel setText:@"2.2mi"];
    
  }
  NSDictionary *blipDict = blips[indexPath.row];
  Song *song = blipDict[@"song"];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", song.title, song.artist];
  cell.detailTextLabel.text = blipDict[@"description"];
  LTLocationController *ltlc = [LTLocationController sharedInstance];
  CLLocationCoordinate2D coord = [ltlc location];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
  float distance = [location distanceFromLocation:blipDict[@"latlng"]]/1609.34;
  UILabel *distanceLabel = (UILabel *)[cell.accessoryView viewWithTag:1];
  [distanceLabel setText:[NSString stringWithFormat:@"%.01fmi",distance]];
  [distanceLabel setTextColor:[UIColor grayColor]];
  //cell.imageView.image = [UIImage imageNamed:@"arrow.png"];
  return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
  NSDictionary* selBlipDict = blips[indexPath.row];
  Song* selSong = selBlipDict[@"song"];
  NSString *selSongID = selSong.providerSongID;
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YOUTUBE_PREFIX, selSongID]];
  
  self.controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:url quality:LBYouTubeVideoQualitySmall];
  self.controller.delegate = self;
  self.controller.view.delegate = self;
  self.controller.view.frame = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
  self.controller.view.center = self.view.center;
  self.controller.view.hidden = true;
  
  [self.view addSubview:self.controller.view];
  
  //  [self.webViewPlayer loadRequest:[NSURLRequest requestWithURL:url]];
  //  webViewPlayer.frame = self.view.frame;
  NSLog(@"%@",url);
}




// UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.view addSubview:webView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"YouTubeSegue"]) {
    LTYouTubeViewController *ytc = ((UINavigationController*)[segue destinationViewController]).topViewController;
    NSArray *selectedPaths = [self.tableView indexPathsForSelectedRows];
    NSInteger selectedRow = ((NSIndexPath*)selectedPaths[0]).row;
    NSDictionary *selBlipDict = blips[selectedRow];
    Song* selSong = selBlipDict[@"song"];
    NSString *selSongID = selSong.providerSongID;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YOUTUBE_PREFIX, selSongID]];
    [ytc.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // ytc.webView loadRequest:];
  }
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
  float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
  
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
    float distance = [location distanceFromLocation:blipDict[@"latlng"]]/1609.34;
    UILabel *distanceLabel = (UILabel *)[cell.accessoryView viewWithTag:1];
    [distanceLabel setText:[NSString stringWithFormat:@"%.01fmi",distance]];
  }
}

-(void)locationError:(NSError *)error {
  NSLog(@"Location error!");
}

- (void)updateCompass {
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D coordinate = locationController.location;
  float magneticHeading = [locationController heading];
  //NSLog(@"%f",magneticHeading);
  NSArray *visibleCells= [self.tableView visibleCells];
  for (UITableViewCell* cell in visibleCells) {
    NSInteger cellIndex = [self.tableView indexPathForCell:cell].row;
    NSDictionary *blipDict = blips[cellIndex];
    float heading = [self getHeadingForDirectionFromCoordinate:coordinate toCoordinate:((CLLocation*)blipDict[@"latlng"]).coordinate];
    // NSLog(@"%f",heading);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    //[UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((-magneticHeading-heading)*M_PI/180);
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, 0.6, 0.6);
    [cell.accessoryView viewWithTag:0].transform = scaleTransform;
    
    // Commit the changes
    [UIView commitAnimations];
  }
}

-(void)refreshView:(UIRefreshControl *)refresh {
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
  
  // custom refresh logic would be placed here...
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D location = [locationController location];
  GeoPoint point;
  point.lat = location.latitude;
  point.lng = location.longitude;
  
  [[LTCommunication sharedInstance] getBlipsNearLocation:point withDelegate:self];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
  [refresh endRefreshing];
}


#pragma mark -
#pragma mark LBYouTubePlayerViewControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
  NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
  NSLog(@"Failed loading video due to error:%@", error);
}

#pragma mark -
#pragma mark LBYouTubePlayerViewDelegate

-(void) videoFinished {
  NSLog(@"video finished");
}

@end

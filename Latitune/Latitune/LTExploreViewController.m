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
@synthesize blips, webViewPlayer, autoplay;

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
  
  [NSTimer scheduledTimerWithTimeInterval:0.1
                                   target:self
                                 selector:@selector(updateCompass)
                                 userInfo:nil
                                  repeats:YES];
  
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
  if (cell.accessoryView.tag != 3) {
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    accessoryView.tag = 3;
    UIImageView *compassView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyphicons_233_direction.png"]];
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
  //cell.imageView.image = [UIImage imageNamed:@"glyphicons_233_direction.png"];
  return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
  NSDictionary* selBlipDict = blips[indexPath.row];
  Song* selSong = selBlipDict[@"song"];
  NSString *selSongID = selSong.providerSongID;
  //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://www.youtube.com/embed/", selSongID]];
  self.autoplay = YES;
  NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html>\
                                      <html>\
                                      <head>\
                                      </head>\
                                      <body>\
                                      <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->\
                                      <div id=\"player\"></div>\
                                      \
                                      <script>\
                                      alert('abc');\
                                      var tag = document.createElement('script');\
                                      tag.src = \"http://www.youtube.com/iframe_api\";\
                                      var firstScriptTag = document.getElementsByTagName('script')[0];\
                                      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);\
                                      \
                                      var player;\
                                      function onYouTubeIframeAPIReady() {\
                                        player = new YT.Player('player', {\
                                        height: '390',\
                                        width: '640',\
                                        videoId: '%@',\
                                        events: {\
                                          'onReady': onPlayerReady,\
                                          'onStateChange': onPlayerStateChange\
                                        }\
                                        });\
                                      }\
                                      \
                                      function onPlayerReady(event) {\
                                        alert('qwerty');\
                                        event.target.playVideo();\
                                        \
                                      }\
                                      \
                                      var done = false;\
                                      function onPlayerStateChange(event) {\
                                        if (event.data == YT.PlayerState.PLAYING && !done) {\
                                          done = true;\
                                        }\
                                      }\
                                      function stopVideo() {\
                                        player.stopVideo();\
                                      }\
                                      </script>\
                                      testing 1 2 3\
                                      <script>\
                                      alert(\"123\");\
                                      player.playVideo();\
                                      </script>\
                                      </body>\
                                   </html>", selSongID];
  [self.webViewPlayer loadHTMLString:html baseURL:nil];
  [self clickVideo];
  self.webViewPlayer.frame = self.view.frame;
  [self.view addSubview:self.webViewPlayer];
}




// UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (self.autoplay) {
    self.autoplay = NO;
    [self clickVideo];
  }
}

- (void)clickVideo {
  [self.webViewPlayer stringByEvaluatingJavaScriptFromString:@"\
   function pollToPlay() {\
   var vph5 = document.getElementById(\"video-player-html5\");\
   if (vph5) {\
   vph5.click();\
   } else {\
   setTimeout(pollToPlay, 100);\
   }\
   }\
   pollToPlay();\
   "];
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

@end

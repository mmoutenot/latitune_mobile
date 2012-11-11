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
  CLLocationCoordinate2D location = [locationController location];
  GeoPoint point;
  point.lat = location.latitude;
  point.lng = location.longitude;
  [[LTCommunication sharedInstance] getBlipsNearLocation:point withDelegate:self];
  blips = [[NSMutableArray alloc] init];
  webViewPlayer = [[UIWebView alloc] init];
  
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
  //cell.imageView = [UIImageView]
  return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
  NSDictionary* selBlipDict = blips[indexPath.row];
  Song* selSong = selBlipDict[@"song"];
  NSString *selSongID = selSong.providerSongID;
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YOUTUBE_PREFIX, selSongID]];
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  
  [webViewPlayer loadRequest:requestObj];
  NSLog(@"Loaded webview with %@", url);
}

@end

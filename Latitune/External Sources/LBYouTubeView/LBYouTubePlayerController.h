//
//  LBYouTubePlayerController.h
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol LBYouTubePlayerDelegate;

@interface LBYouTubePlayerController : UIView {
  MPMoviePlayerController* videoController;
  id delegate;
}

@property (nonatomic, strong, readonly) MPMoviePlayerController* videoController;
@property (nonatomic, strong) id delegate;

-(void)loadYouTubeVideo:(NSURL*)URL;

@end

@protocol LBYouTubePlayerDelegate <NSObject>

- (void) videoFinished;

@end

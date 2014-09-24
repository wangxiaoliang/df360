//
//  EGORefreshView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h> 

//#define DISPLAY_ARROW

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

typedef enum{
    RefreshViewTypePull = 0,
    RefreshViewTypeGetMore,
} RefreshType;

@protocol RefreshViewDelegate;

@interface RefreshView : UIView {
	
	id _delegate;
	EGOPullRefreshState _state;
    RefreshType _refreshType;
    
    BOOL _loading;
    
    NSTimeInterval _lastUpdatedTime;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;

    SystemSoundID _soundid_trigger;
    SystemSoundID _soundid_release;
    
    //NSTimer *timer;
    
    //float angle;
    
    BOOL rc_default;
}

@property(nonatomic, assign) id <RefreshViewDelegate> delegate;

- (id)initWithOwner:(UIScrollView *)owner delegate:(id<RefreshViewDelegate>)delegate refreshType:(RefreshType)refreshType;

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingWithAnimated:(BOOL)animated;

- (BOOL)isLoading;
- (void)updateGetMorePosition;
- (void)updateLastUpdatedTime;
- (NSTimeInterval)getLastUpdatedTime;
- (void)updateLastUpdatedTimeWith:(NSTimeInterval)time;

-(void)enableAudioEffect:(BOOL)enable;

@end

@protocol RefreshViewDelegate

- (void)refreshViewDidCallBack:(RefreshView*)view;

@end

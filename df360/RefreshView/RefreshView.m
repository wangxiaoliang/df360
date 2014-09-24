
#define  RefreshViewHight 65.0f

#import "RefreshView.h"
#import "DFToolClass.h"
#define REFRESH_TEXT_COLOR	 [UIColor blackColor] 
#define FLIP_ANIMATION_DURATION 0.18f

@interface RefreshView (Private)

- (void)setState:(EGOPullRefreshState)aState;

@end

@implementation RefreshView

@synthesize delegate=_delegate;

- (void)enableAudioEffect:(BOOL)enable
{
#if 1
    if( enable )
    {
        NSURL* soundURL = [[NSBundle mainBundle] URLForResource:@"refresh_triggering" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &_soundid_trigger);
        
        soundURL = [[NSBundle mainBundle] URLForResource:@"refresh_release" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &_soundid_release);
    }
    else
    {
        AudioServicesDisposeSystemSoundID(_soundid_trigger);
        AudioServicesDisposeSystemSoundID(_soundid_release);
    }
#endif
}

-(void)playEffectTriggering
{
//    
//    int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"setting_audio"] intValue];
//    if( value == 1 )
//        return;
//
//    AudioServicesPlaySystemSound(_soundid_trigger);
}

- (void)playEffectRelease
{
//    int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"setting_audio"] intValue];
//    if( value == 1 )
//        return;
//    
//    AudioServicesPlaySystemSound(_soundid_release);
}

//- (id)initWithFrame:(CGRect)frame refreshType:(EGORefreshType)refreshType 
- (id)initWithOwner:(UIScrollView *)owner delegate:(id<RefreshViewDelegate>)delegate refreshType:(RefreshType)refreshType
{
    self = [super initWithFrame: CGRectZero];
    
    if (self) 
    {
        _loading = NO;
        _lastUpdatedTime = 0;
        _refreshType = refreshType;
        
        [self enableAudioEffect:YES];
        
        CGRect frame = owner.bounds;
        
        if( refreshType == RefreshViewTypeGetMore )
        {
            self.frame = CGRectMake(0, owner.contentSize.height, owner.bounds.size.width, owner.bounds.size.height);
        }
        else
        {
            self.frame = CGRectMake(0, -owner.bounds.size.height,owner.bounds.size.width, owner.bounds.size.height); 
        }
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor] ;
        
		UILabel *label;
        
        if( refreshType == RefreshViewTypePull )
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        else
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 30.0f, self.frame.size.width, 20.0f)];
            
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = REFRESH_TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
        if( refreshType == RefreshViewTypePull )
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        else
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 40.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = REFRESH_TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [DFToolClass getColor:@"666666"];
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
#ifdef DISPLAY_ARROW
		CALayer *layer = [CALayer layer];
        if( refreshType == RefreshViewTypePull )
            layer.frame = CGRectMake(60.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        else
            layer.frame = CGRectMake(60.0f, RefreshViewHight - RefreshViewHight, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"whiteArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
#endif
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] init];
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        if( refreshType == RefreshViewTypePull )
            //view.frame = CGRectMake(60.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
            view.frame = CGRectMake(88.5, 407, 20.0f, 20.0f);
        else
            view.frame = CGRectMake(70.0f, RefreshViewHight - 38.0f, 20.0f, 20.0f);
        
        //view.image = [UIImage imageNamed:@"loading_icon.png"];
		[self addSubview:view];
        
        _activityView = view;
		
		[view release];
		
        [owner insertSubview:self atIndex:0];
        _delegate = delegate;
		
		[self setState:EGOOPullRefreshNormal playEffect:NO];
        
        //angle = 0;
    }
	
    return self;
}

//- (void)inAngel
//{
//    angle = angle - 6;
//    
//    //if( _refreshType == RefreshViewTypeGetMore )
//    //    _activityView.layer.transform = CATransform3DIdentity;
//    //else
//    _activityView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    _activityView.layer.transform =  CATransform3DMakeRotation((M_PI / 180.0) * angle, 0.0f, 0.0f, 1.0f);
//}

#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullRefreshState)aState playEffect:(BOOL)playEffect{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
            if( playEffect )
                [self playEffectRelease];
            if( _refreshType == RefreshViewTypeGetMore )
                _statusLabel.text = @"松开加载更多...";
            else
            {
                _statusLabel.text = @"松开即可更新...";
            }
            
            //_activityView.hidden = YES;
            
#ifdef DISPLAY_ARROW
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            if( _refreshType == RefreshViewTypeGetMore )
                _arrowImage.transform = CATransform3DIdentity;
            else
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
               
			[CATransaction commit];
#endif
			
			break;
		case EGOOPullRefreshNormal:
            if( playEffect )
                [self playEffectRelease];
			
#ifdef DISPLAY_ARROW
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                if( _refreshType == RefreshViewTypeGetMore )
                    _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                else
                    _arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
#endif
            if( _refreshType == RefreshViewTypeGetMore )
                _statusLabel.text = @"上拉获取更多...";
            else
            {
                _statusLabel.text = @"下拉即可更新...";
            }
            
            //_activityView.hidden = YES;
            
            //if (timer)
            //{
            //    timer = nil;
            //}
                
			[_activityView stopAnimating];
            
#ifdef DISPLAY_ARROW
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
            if( _refreshType == RefreshViewTypeGetMore )
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            else
                _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
#endif
			
			break;
		case EGOOPullRefreshLoading:
            if( playEffect )
                [self playEffectTriggering];
			
			_statusLabel.text = @"正在加载...";
            
            //_activityView.hidden = NO;
            
            //if (timer == nil)
            //{
            //    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(inAngel) userInfo:nil repeats:YES];
            //}
        
#ifndef DISPLAY_ARROW
        {
            //if (!rc_default)
            //{
                rc_default = YES;
                CGRect rc = _activityView.frame;
                CGSize sz = [_statusLabel.text sizeWithFont:_statusLabel.font forWidth:99999 lineBreakMode:NSLineBreakByTruncatingTail];
                CGRect rc1 = _statusLabel.frame;
                float x = rc1.origin.x + (rc1.size.width - sz.width)/2 + 10;
                rc.origin.x = x - rc.size.width - 20;
                rc.origin.y = rc1.origin.y + rc1.size.height/2 - rc.size.height/2;
                _activityView.frame = rc;
            //}
        }
            
#endif
			[_activityView startAnimating];
            
#ifdef DISPLAY_ARROW
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
#endif
			break;
		default:
			break;
	}
	
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    
}

//手指屏幕上不断拖动调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	if (_state == EGOOPullRefreshLoading)
    {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
        
        if( _refreshType == RefreshViewTypeGetMore )
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
        else
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

	} else if (scrollView.isDragging) {
		
        if( _refreshType == RefreshViewTypeGetMore )
        {
            if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading)
            {
                [self setState:EGOOPullRefreshNormal  playEffect:YES];
                
            } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading)
            {
                [self setState:EGOOPullRefreshPulling   playEffect:YES];
            }
            
            if (scrollView.contentInset.bottom != 0)
            {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
        else
        {
            if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading)
            {
                [self setState:EGOOPullRefreshNormal  playEffect:YES];
            } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading)
            {
                [self setState:EGOOPullRefreshPulling  playEffect:YES];
            }
            
            if (scrollView.contentInset.top != 0)
            {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
	}
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( _refreshType == RefreshViewTypeGetMore )
    {
        if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
            
            if ([_delegate respondsToSelector:@selector(refreshViewDidCallBack:)]) {
                [_delegate refreshViewDidCallBack:self];
            }
        }
    }
    else
    {
        if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
            
            if ([_delegate respondsToSelector:@selector(refreshViewDidCallBack:)]) {
                [_delegate refreshViewDidCallBack:self];
            }
        }
    }
}

- (void)updateGetMorePosition
{
    if( _refreshType == RefreshViewTypeGetMore )
    {
        UIScrollView* sv = (UIScrollView*)[self superview];
        CGRect rc = self.frame;
        
        rc.origin.y = sv.contentSize.height;
        if( sv.contentSize.height < sv.bounds.size.height )
            rc.origin.y = sv.bounds.size.height;
        
        self.frame = rc;
    }
}

- (BOOL)isLoading
{
    return _loading;
}

- (NSTimeInterval)getLastUpdatedTime
{
    return _lastUpdatedTime;
}

- (void)updateLastUpdatedTimeWith:(NSTimeInterval)time
{
    _lastUpdatedTime = time;
    
    NSDate* de = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    
    NSString* timeStr = [dateFormatter stringFromDate:de];	
    [dateFormatter release];
    
    // UI 赋值
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", 
                              NSLocalizedStringFromTable(@"最后更新", @"RefreshLocal", @"最后更新"),
                              timeStr];
}

- (void)updateLastUpdatedTime
{
    NSDate *nowDate = [NSDate date];
    _lastUpdatedTime = [nowDate timeIntervalSince1970];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    [outFormat release];
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", 
                              NSLocalizedStringFromTable(@"最后更新", @"RefreshLocal", @"最后更新"),
                            timeStr];
}

- (void)startLoading
{
    _loading = YES;
    UIScrollView* scrollView = (UIScrollView*)[self superview];
    
    [self setState:EGOOPullRefreshLoading  playEffect:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    if( _refreshType == RefreshViewTypeGetMore )
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
    else
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);

    [UIView commitAnimations];
}

- (void)stopLoadingWithAnimated:(BOOL)animated
{
    _loading = NO;
    UIScrollView* scrollView = (UIScrollView*)[self superview];
    
    if( animated )
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
    }
    
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	
    if( animated )
        [UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal  playEffect:YES];
    
    if( _refreshType == RefreshViewTypeGetMore )
    {
        [self updateGetMorePosition];
    }
}

- (void)stopLoading
{
    _loading = NO;
    UIScrollView* scrollView = (UIScrollView*)[self superview];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    scrollView.contentInset = UIEdgeInsetsZero;
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal  playEffect:YES];
    
    if( _refreshType == RefreshViewTypeGetMore )
    {
        [self updateGetMorePosition];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    [self enableAudioEffect:NO];
    
    //if (timer.isValid)
    //{
    //    timer = nil;
    //}
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end



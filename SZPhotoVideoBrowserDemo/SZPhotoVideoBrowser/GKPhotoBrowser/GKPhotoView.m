//
//  GKPhotoView.m
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/10/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "GKPhotoView.h"

@interface GKPhotoView()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, strong, readwrite) FLAnimatedImageView *imageView;

@property (nonatomic, strong, readwrite) GKLoadingView *loadingView;

@property (nonatomic, strong, readwrite) GKPhoto *photo;

@property (nonatomic, strong) id<GKWebImageProtocol> imageProtocol;

@end

@implementation GKPhotoView
{
    CGFloat w;
    CGFloat h;
}

- (instancetype)initWithFrame:(CGRect)frame imageProtocol:(nonnull id<GKWebImageProtocol>)imageProtocol {
    if (self = [super initWithFrame:frame]) {
        _imageProtocol = imageProtocol;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                      = [UIScrollView new];
        _scrollView.frame                = CGRectMake(0, 0, GKScreenW, GKScreenH);
        _scrollView.backgroundColor      = [UIColor clearColor];
        _scrollView.delegate             = self;
        
        _scrollView.clipsToBounds        = YES;
        _scrollView.multipleTouchEnabled = YES; // 多点触摸开启
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.gk_gestureHandleDisabled = YES;
    }
    return _scrollView;
}

//-(CLPlayerView *)_playerView {
//    return _playerView;
//}
-(SBPlayer *)_playerView {
    return _playerView;
}

-(SBPlayer *)playerView {
    if (!_playerView) {

    //初始化播放器
    _playerView = [[SBPlayer alloc] init];
    //设置标题
//    [_playerView setTitle:@"这是一个标题"];
    //设置播放器背景颜色
    _playerView.backgroundColor = [UIColor blackColor];
    //约束，也可以使用Frame
//    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view.mas_top);
//        make.height.mas_equalTo(@250);
//    }];
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
            if (UIDeviceOrientationIsLandscape(currentOrientation)) {
                w = MAX(screenBounds.size.width, screenBounds.size.height);
                h = MIN(screenBounds.size.width, screenBounds.size.height);
            } else {
                h = MAX(screenBounds.size.width, screenBounds.size.height);
                w = MIN(screenBounds.size.width, screenBounds.size.height);
            }
    _playerView.frame = CGRectMake(0, 0, w,h);

    }
    return _playerView;
}



- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView               = [FLAnimatedImageView new];
        _imageView.frame         = CGRectMake(0, 0, GKScreenW, GKScreenH);
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (GKLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [GKLoadingView loadingViewWithFrame:self.bounds style:GKLoadingStyleIndeterminate];
        _loadingView.lineWidth   = 3;
        _loadingView.radius      = 12;
        _loadingView.bgColor     = [UIColor blackColor];
        _loadingView.strokeColor = [UIColor whiteColor];
    }
    return _loadingView;
}

- (void)setupPhoto:(GKPhoto *)photo {
    _photo = photo;
    
    if (photo.isVideo) {
        _playerView.hidden = NO;
        [_playerView assetWithURL:photo.url];
        //设置播放器填充模式 默认SBLayerVideoGravityResizeAspectFill，可以不添加此语句
        _playerView.mode = SBLayerVideoGravityResizeAspect;
    }
    
    [self loadImageWithPhoto:photo];
}

#pragma mark - 加载图片
- (void)loadImageWithPhoto:(GKPhoto *)photo {
    // 取消以前的加载
    [_imageProtocol cancelImageRequestWithImageView:self.imageView];
    
    if (photo.isVideo) {
        // 每次设置数据时，恢复缩放
        [self.scrollView setZoomScale:1.0 animated:NO];
        
        return;
    }
    
    
    if (photo) {
        // 每次设置数据时，恢复缩放
        [self.scrollView setZoomScale:1.0 animated:NO];
        
        // 已经加载成功，无需再加载
        if (photo.image || photo.animatedImage) {
            [self.loadingView stopLoading];
            
            if (photo.animatedImage) {
                self.imageView.animatedImage = photo.animatedImage;
            }else if (photo.image) {
                self.imageView.image = photo.image;
            }
            
            [self adjustFrame];
            return;
        }
        
        // 显示原来的图片
        self.imageView.image          = self.photo.placeholderImage;
        self.scrollView.scrollEnabled = NO;
        // 进度条
        [self addSubview:self.loadingView];
        [self.loadingView startLoading];
        
        [self adjustFrame];
        
        __weak typeof(self) weakSelf = self;
        gkWebImageProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//
//            if (receivedSize > kMinProgress) {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    strongSelf.loadingView.progress = (float)receivedSize / expectedSize;
//                });
//            }
        };
        
        gkWebImageCompletionBlock completionBlock = ^(UIImage *image, NSURL *url, BOOL finished, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (finished) {
                photo.animatedImage = self.imageView.animatedImage;
                photo.image         = self.imageView.image;
                photo.finished      = YES; // 下载完成
                
                strongSelf.scrollView.scrollEnabled = YES;
                [strongSelf.loadingView stopLoading];
            }else { // 加载失败
                [strongSelf addSubview:weakSelf.loadingView];
                [weakSelf.loadingView showFailure];
            }
            [strongSelf adjustFrame];
        };
        
        // 加载图片
        [_imageProtocol setImageWithImageView:self.imageView url:photo.url placeholder:photo.placeholderImage progress:progressBlock completion:completionBlock];
        
    }else {
        self.imageView.image = nil;
        
        [self adjustFrame];
    }
}

- (void)resetFrame {
    self.scrollView.frame  = self.bounds;
    self.loadingView.frame = self.bounds;
    
    [self adjustFrame];
}

#pragma mark - 调整frame
- (void)adjustFrame {
    CGRect frame = self.scrollView.frame;
    
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageF = (CGRect){{0, 0}, imageSize};
        
        // 图片的宽度 = 屏幕的宽度
        CGFloat ratio = frame.size.width / imageF.size.width;
        imageF.size.width  = frame.size.width;
        imageF.size.height = ratio * imageF.size.height;
        
        // 默认情况下，显示出的图片的宽度 = 屏幕的宽度
        // 如果kIsFullWidthForLandSpace = NO，需要把图片全部显示在屏幕上
        // 此时由于图片的宽度已经等于屏幕的宽度，所以只需判断图片显示的高度>屏幕高度时，将图片的高度缩小到屏幕的高度即可
        
        if (!kIsFullWidthForLandSpace) {
            // 图片的高度 > 屏幕的高度
            if (imageF.size.height > frame.size.height) {
                CGFloat scale = imageF.size.width / imageF.size.height;
                imageF.size.height = frame.size.height;
                imageF.size.width  = imageF.size.height * scale;
            }
        }
        
        // 设置图片的frame
        self.imageView.frame = imageF;
                
        self.scrollView.contentSize = self.imageView.frame.size;
        
        self.imageView.center = [self centerOfScrollViewContent:self.scrollView];
        
        // 根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height / imageF.size.height;

        maxScale = frame.size.width / imageF.size.width > maxScale ? frame.size.width / imageF.size.width : maxScale;
        // 超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        // 初始化
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.zoomScale        = 1.0;
    }else {
        frame.origin     = CGPointZero;
        CGFloat width  = frame.size.width;
        CGFloat height = width * 2.0 / 3.0;
        _imageView.bounds = CGRectMake(0, 0, width, height);
        _imageView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        _playerView.bounds = CGRectMake(0, 0, width, frame.size.height);
        _playerView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        
        // 重置内容大小
        self.scrollView.contentSize = self.imageView.frame.size;
    }
    self.scrollView.contentOffset = CGPointZero;
    
    // frame调整完毕，重新设置缩放
    if (self.photo.isZooming) {
        [self zoomToRect:self.photo.zoomRect animated:NO];
    }
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (CGRect)frameWithWidth:(CGFloat)width height:(CGFloat)height center:(CGPoint)center {
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    
    return CGRectMake(x, y, width, height);
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    [self.scrollView zoomToRect:rect animated:YES];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)cancelCurrentImageLoad {
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)dealloc {
    [self cancelCurrentImageLoad];
}

@end

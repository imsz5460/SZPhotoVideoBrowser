//
//  GKPhotoView.h
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/10/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPhoto.h"
#import "GKWebImageProtocol.h"
#import "GKLoadingView.h"
#import "CLPlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@class GKPhotoView;

@interface GKPhotoView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) FLAnimatedImageView *imageView;

@property (nonatomic, strong, readonly) GKLoadingView *loadingView;

@property (nonatomic, strong, readonly) GKPhoto *photo;
/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
/** 是否重新布局 */
@property (nonatomic, assign) BOOL isLayoutSubViews;

- (instancetype)initWithFrame:(CGRect)frame imageProtocol:(id<GKWebImageProtocol>)imageProtocol;

// 设置数据
- (void)setupPhoto:(GKPhoto *)photo;

- (void)adjustFrame;

// 缩放
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

// 重新布局
- (void)resetFrame;
-(CLPlayerView *)_playerView;
@end

NS_ASSUME_NONNULL_END

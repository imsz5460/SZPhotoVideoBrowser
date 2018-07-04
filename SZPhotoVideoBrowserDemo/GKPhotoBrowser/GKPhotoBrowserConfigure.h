//
//  GKPhotoBrowserConfigure.h
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/10/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#ifndef GKPhotoBrowserConfigure_h
#define GKPhotoBrowserConfigure_h

#import "UIScrollView+GKGestureHandle.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <SDWebImage/SDWebImageManager.h>

#define GKScreenW [UIScreen mainScreen].bounds.size.width
#define GKScreenH [UIScreen mainScreen].bounds.size.height

#define kMaxZoomScale               2.0f
#define kIsFullScreenEnable         YES
#define kIsFullWidthForLandSpace    YES

#define kPhotoViewPadding           10

#define kAnimationDuration          0.35f

// 图片浏览器的显示方式
typedef NS_ENUM(NSUInteger, GKPhotoBrowserShowStyle) {
    GKPhotoBrowserShowStyleNone,       // 直接显示，默认方式
    GKPhotoBrowserShowStyleZoom,       // 缩放显示，动画效果
    GKPhotoBrowserShowStylePush        // push方式展示
};

// 图片浏览器的隐藏方式
typedef NS_ENUM(NSUInteger, GKPhotoBrowserHideStyle) {
    GKPhotoBrowserHideStyleZoom,           // 缩放
    GKPhotoBrowserHideStyleZoomScale,      // 缩放和滑动缩小
    GKPhotoBrowserHideStyleZoomSlide       // 缩放和滑动平移
};

#endif /* GKPhotoBrowserConfigure_h */

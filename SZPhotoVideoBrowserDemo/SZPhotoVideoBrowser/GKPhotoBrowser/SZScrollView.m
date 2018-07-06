//
//  SZScrollView.m
//  GKPhotoBrowserDemo
//
//  Created by shizhi on 2018/6/28.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "SZScrollView.h"

@implementation SZScrollView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这里暂时写死
    if (CGRectContainsPoint(CGRectMake(0, self.frame.size.height -50, 100000, 50), point)) {
        self.scrollEnabled = NO;
        return [super hitTest:point withEvent:event];
    }
    self.scrollEnabled = YES;
    return [super hitTest:point withEvent:event];
}

@end

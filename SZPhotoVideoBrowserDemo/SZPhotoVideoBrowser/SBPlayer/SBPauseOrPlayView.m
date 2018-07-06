//
//  PauseOrPlayView.m
//  SBPlayer
//
//  Created by sycf_ios on 2017/4/11.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "SBPauseOrPlayView.h"
@interface SBPauseOrPlayView ()

@end
@implementation SBPauseOrPlayView

- (void)drawRect:(CGRect)rect {
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.imageBtn setShowsTouchWhenHighlighted:YES];
    [self.imageBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [self.imageBtn addTarget:self action:@selector(handleImageTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imageBtn];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
-(void)handleImageTapAction:(UIButton *)button{
    button.selected = !button.selected;
    _state = button.isSelected ? YES : NO;
    if ([self.delegate respondsToSelector:@selector(pauseOrPlayView:withState:)]) {
        [self.delegate pauseOrPlayView:self withState:_state];
    }
}

@end

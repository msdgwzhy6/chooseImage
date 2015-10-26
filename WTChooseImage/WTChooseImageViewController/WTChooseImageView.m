//
//  WTChooseImageView.m
//  WTChooseImage
//
//  Created by wadewade on 15/10/16.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import "WTChooseImageView.h"

#define IOS7 [[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0

@implementation WTChooseImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setImage:image];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(0, 0, 20, 20);
    _deleteButton.layer.cornerRadius   = 5.0f;
    if (IOS7) {
        [_deleteButton setBackgroundImage:[[UIImage imageNamed:@"pic_delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"pic_delete.png"] forState:UIControlStateNormal];
    }
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    
}
- (void)deleteButtonClick:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteChooseImageWith:)]) {
        [_delegate performSelector:@selector(deleteChooseImageWith:) withObject:button];
    }
}
@end

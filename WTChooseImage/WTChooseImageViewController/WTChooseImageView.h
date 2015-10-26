//
//  WTChooseImageView.h
//  WTChooseImage
//
//  Created by wadewade on 15/10/16.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTChooseImageViewDelegate <NSObject>

- (void)deleteChooseImageWith:(UIButton *)button;

@end

@interface WTChooseImageView : UIImageView
@property (nonatomic,strong)UIButton *deleteButton;
@property (weak, nonatomic)id<WTChooseImageViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
@end

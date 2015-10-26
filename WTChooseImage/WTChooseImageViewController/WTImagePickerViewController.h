//
//  WTImagePickerViewController.h
//  WTChooseImage
//
//  Created by wadewade on 15/10/16.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTImagePickerViewDelegate <NSObject>

- (void)getSelectedImages:(NSArray *)imageArray;

@end

@interface WTImagePickerViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController     *   _myPickController;
    NSMutableArray            *   _photoArray;
    UIView                     *   _showDetailView;//展示所选图片
    
}
@property (nonatomic,strong)UIImagePickerController *_myPickController;
@property (nonatomic,weak) id<WTImagePickerViewDelegate> delegate;
+(id)shareInstance;
@end

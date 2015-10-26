//
//  WTImagePickerViewController.m
//  WTChooseImage
//
//  Created by wadewade on 15/10/16.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import "WTImagePickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WTChooseImageView.h"

#define maxChooseNum 5 //最多选择的照片张数

#define viewWIDTH self.view.bounds.size.width
#define viewHEIGHT self.view.bounds.size.height

@interface WTImagePickerViewController ()<WTChooseImageViewDelegate>
{
    UILabel *_showChooseLabel;
    UIScrollView    *_chooseScroll;
}
@end

@implementation WTImagePickerViewController
@synthesize _myPickController;
@synthesize delegate;
- (id)init{
    self = [super init];
    if (self) {
        _photoArray = [[NSMutableArray alloc]init];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
+(id)shareInstance{
    static WTImagePickerViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
//加载imagepick时不经过viewdidload
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, viewWIDTH, viewHEIGHT - 200)];
    
    _showDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHEIGHT - 150, viewWIDTH, 150)];
    _showDetailView.backgroundColor = [UIColor brownColor];
    [viewController.view addSubview:_showDetailView];
    
    _showChooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, viewWIDTH - 100, 30)];
    _showChooseLabel.text = [NSString stringWithFormat:@"你当前选择0张照片，最多选择%d张",maxChooseNum];
    _showChooseLabel.font = [UIFont systemFontOfSize:12];
    [_showDetailView addSubview:_showChooseLabel];
    
    UIButton    * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(viewWIDTH - 100, 0, 80, 30);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 10;
    [button addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
    [_showDetailView addSubview:button];
    
    
    _chooseScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, viewWIDTH, 80)];
    _chooseScroll.showsHorizontalScrollIndicator = NO;
    _chooseScroll.showsVerticalScrollIndicator = NO;
    _chooseScroll.backgroundColor = [UIColor whiteColor];
    //初始时显示的图片
    WTChooseImageView *imageView = [[WTChooseImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60) andImage:[UIImage imageNamed:@"add_pic.png"]];
    imageView.tag = 100;
    _chooseScroll.contentSize = CGSizeMake(10 *6 + 60 *5, 80);
    [_chooseScroll addSubview:imageView];
    [_showDetailView addSubview:_chooseScroll];

}
- (void)finishChoose{
    if (delegate && [delegate respondsToSelector:@selector(getSelectedImages:)]) {
            [delegate performSelector:@selector(getSelectedImages:) withObject:_photoArray];
    }
    [self close];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (_photoArray.count >= maxChooseNum) {
        UIAlertView *showAlter = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多只能选择%d张照片",maxChooseNum] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [showAlter show];
        return;
    }
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_photoArray addObject:img];
    [self addImage];
}

- (void)addImage{
    
    WTChooseImageView *showImageView = [[WTChooseImageView alloc]initWithFrame:CGRectMake(10 * _photoArray.count + 60 * (_photoArray.count - 1), 10, 60, 60) andImage:[_photoArray objectAtIndex:(_photoArray.count-1)]];
    showImageView.delegate = self;
//    showImageView.deleteButton.hidden = NO;
    showImageView.deleteButton.tag = 200 + (_photoArray.count - 1);
    [_chooseScroll addSubview:showImageView];
    if ((10 * (_photoArray.count + 1) +  (60 * _photoArray.count))> _chooseScroll.contentSize.width) {
        return;
    }
    else{
    NSLog(@"改变add的frame");
    ((WTChooseImageView *)[_chooseScroll viewWithTag:100]).frame = CGRectMake(10 * (_photoArray.count + 1) + 60 * _photoArray.count , 10, 60, 60);
    }
    _showChooseLabel.text = [NSString stringWithFormat:@"你当前选择0张照片，最多选择%lu张",(unsigned long)_photoArray.count];
    
}
- (void)deleteChooseImageWith:(UIButton *)button{
    [((WTChooseImageView *)[_chooseScroll viewWithTag:button.tag]) removeFromSuperview];
    [_photoArray removeObjectAtIndex:button.tag - 200];
    if (button.tag == 200 + maxChooseNum - 1) {
        
    }
    else{
        
        ((WTChooseImageView *)[_chooseScroll viewWithTag:100]).frame = CGRectMake(10 * (_photoArray.count + 1) + 60 * _photoArray.count, 10, 60, 60);

    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self close];

}
-(void)close
{
    [_myPickController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

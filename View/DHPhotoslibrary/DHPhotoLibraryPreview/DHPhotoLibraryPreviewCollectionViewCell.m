//
//  DHPhotoLibraryPreviewCollectionViewCell.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotoLibraryPreviewCollectionViewCell.h"
#import "DHPhotoLibraryPreviewViewController.h"

@interface DHPhotoLibraryPreviewCollectionViewCell()<UIAlertViewDelegate>

@end

@implementation DHPhotoLibraryPreviewCollectionViewCell {
    UIImageView *_imageView;
}

-(void)setPreviewImage:(UIImage *)previewImage {
    _previewImage = previewImage;
    if (!_imageView) {
        _imageView =[[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.image = previewImage;
         [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
       
//        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureImage:)];
//        [_imageView addGestureRecognizer:ges];
        _imageView.userInteractionEnabled = NO;
//         UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] init];
//        [_imageView addGestureRecognizer:ges];
//        [ges addTarget:self  action:@selector(longPressGesture)];
        
    }
}

-(void)tapGestureImage:(UIGestureRecognizer *)ges {
    [[self getViewController].navigationController popViewControllerAnimated:NO];
}


-(void)longPressGesture:(UIGestureRecognizer *)ges {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"长按保存" message:@"message" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
         UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);//保存到本地
    }
    
}
-(UIViewController *)getViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[DHPhotoLibraryPreviewViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end

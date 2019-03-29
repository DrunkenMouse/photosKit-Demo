//
//  DHPhotoLibraryCameraCollectionViewCell.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotoLibraryCameraCollectionViewCell.h"
#import "DHNewPhotoLibraryViewController.h"

@interface DHPhotoLibraryCameraCollectionViewCell()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation DHPhotoLibraryCameraCollectionViewCell {
    UIImagePickerController *_imagePickerController;
    UIButton *_CammeraButton;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _CammeraButton = [[UIButton alloc] init];
        _CammeraButton.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_CammeraButton];
        [_CammeraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [_CammeraButton addTarget:self action:@selector(clickCammeraButton) forControlEvents:UIControlEventTouchUpInside];
        


    }
    return self;
}

-(void)clickCammeraButton {
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.delegate = self;
    
    [[self getViewController] presentViewController:_imagePickerController animated:YES completion:nil];
    
   
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //    NSString *const  UIImagePickerControllerMediaType ;指定用户选择的媒体类型（文章最后进行扩展）
    //    NSString *const  UIImagePickerControllerOriginalImage ;原始图片
    //    NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
    //    NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸
    //    NSString *const  UIImagePickerControllerMediaURL ;媒体的URL
    //    NSString *const  UIImagePickerControllerReferenceURL ;原件的URL
    //    NSString *const  UIImagePickerControllerMediaMetadata;当来数据来源是照相机的时候这个值才有效
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:image forKey:@"image"];
    
   
    DHWeakSelf;
    
    
    [_imagePickerController dismissViewControllerAnimated:NO completion:^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到本地
        if (weakSelf.getImage) {
//            UIImageWriteToSavedPhotosAlbum
            weakSelf.getImage(dict);
        }
    }];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    [_imagePickerController dismissModalViewControllerAnimated:NO];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [_imagePickerController dismissModalViewControllerAnimated:NO];
}
-(UIViewController *)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[DHNewPhotoLibraryViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


@end

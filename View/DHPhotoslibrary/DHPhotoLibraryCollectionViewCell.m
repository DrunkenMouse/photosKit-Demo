//
//  DHPhotoLibraryCollectionViewCell.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotoLibraryCollectionViewCell.h"

@implementation DHPhotoLibraryCollectionViewCell{
    UIImageView *_imageView;
    UIButton *_selectedButton;
}


-(void)setImages:(UIImage *)images {
    
    _images = images;
    if (!_imageView) {
        _imageView =[[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
    }
    _imageView.image = images;
    
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc] init];
        [self.contentView addSubview:_selectedButton];
        
        [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(DHAdaptive(40));
        }];
        _selectedButton.backgroundColor = [UIColor whiteColor];
        
        _selectedButton.userInteractionEnabled = NO;//让父类去响应

        
    }
    
}


-(void)setIsUserSelected:(BOOL)isUserSelected {
    _isUserSelected = isUserSelected;
    
    if (isUserSelected) {
         _selectedButton.backgroundColor = [UIColor purpleColor];
    }else {
        _selectedButton.backgroundColor = [UIColor whiteColor];
    }
}

@end

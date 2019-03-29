//
//  DHPhotoLibraryCollectionViewCell.h
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHPhotoLibraryCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImage *images;

@property(nonatomic, assign)BOOL isUserSelected;//是否选中

@property(nonatomic, assign)BOOL isCammeraImage;//是相机拍到的图片

@end

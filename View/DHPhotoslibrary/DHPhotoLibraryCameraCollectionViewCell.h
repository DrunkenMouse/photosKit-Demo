//
//  DHPhotoLibraryCameraCollectionViewCell.h
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cammeraGetImageBlock)(NSMutableDictionary *dict);

@interface DHPhotoLibraryCameraCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy)cammeraGetImageBlock getImage;

@end

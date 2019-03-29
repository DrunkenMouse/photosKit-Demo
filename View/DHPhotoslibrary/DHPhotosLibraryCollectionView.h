//
//  DHPhotosLibraryCollectionView.h
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Photos/PHPhotoLibrary.h>

@interface DHPhotosLibraryCollectionView : UICollectionView

@property(nonatomic, weak)UIViewController *toolVC;

@property(nonatomic, strong)NSMutableDictionary *fetchResultDict;

@property(nonatomic, strong)NSString *photoLibraryName;

-(NSMutableArray *)getSelectedImage;

@end

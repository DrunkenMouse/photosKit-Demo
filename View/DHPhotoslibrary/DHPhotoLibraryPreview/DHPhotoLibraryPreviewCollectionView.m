//
//  DHPhotoLibraryPreviewCollectionView.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotoLibraryPreviewCollectionView.h"
#import "DHPhotoLibraryPreviewCollectionViewCell.h"

@interface DHPhotoLibraryPreviewCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation DHPhotoLibraryPreviewCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[DHPhotoLibraryPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"DHPhotoLibraryPreviewCollectionViewCell"];
        
       
        
    }
    return self;
}

-(void)setSelectedImageArr:(NSMutableArray *)selectedImageArr {
    
    _selectedImageArr = selectedImageArr;
  
    [self reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _selectedImageArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DHPhotoLibraryPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DHPhotoLibraryPreviewCollectionViewCell" forIndexPath:indexPath];
    cell.previewImage = _selectedImageArr[indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.VC.navigationController popViewControllerAnimated:NO];
}

@end

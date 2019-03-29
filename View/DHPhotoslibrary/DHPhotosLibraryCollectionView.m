//
//  DHPhotosLibraryCollectionView.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotosLibraryCollectionView.h"
#import <Photos/Photos.h>
#import <Photos/PHAsset.h>
#import <Photos/PHFetchResult.h>
#import "DHPhotoLibraryCollectionViewCell.h"
#import "DHPhotoLibraryCameraCollectionViewCell.h"


@interface DHPhotosLibraryCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)NSMutableArray <PHAsset *> *assets;//保存所有的Phasset

@property(nonatomic, strong)NSMutableDictionary *selectedDict;//选中的Cell

@property(nonatomic, strong)NSMutableArray <UIImage *> *cammeraImageArr;//照相机获取到的图片

@property(nonatomic, strong)NSMutableArray *dictKeyArr;//保存选中图片的Key

@property(nonatomic, strong)NSMutableArray *preViewImageArr;//保存预览时的高清图片


@end

@implementation DHPhotosLibraryCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[DHPhotoLibraryCollectionViewCell class] forCellWithReuseIdentifier:@"DHPhotoLibraryCollectionViewCell"];
        
        [self registerClass:[DHPhotoLibraryCameraCollectionViewCell class] forCellWithReuseIdentifier:@"DHPhotoLibraryCameraCollectionViewCell"];
        
        self.assets =  [self getAllAssetInPhotoAblumWithAscending:NO];
        self.selectedDict = [NSMutableDictionary dictionary];
        self.cammeraImageArr = [NSMutableArray array];
        self.dictKeyArr = [NSMutableArray array];
        self.preViewImageArr = [NSMutableArray array];
        
    }
    return self;
}

-(void)setFetchResultDict:(NSMutableDictionary *)fetchResultDict {
    
    _fetchResultDict = fetchResultDict;
    
    [self.assets removeAllObjects];//清除之前的数据
    
    PHFetchResult *fetchResult = fetchResultDict[@"fetchResult"];
    _photoLibraryName = fetchResultDict[@"title"];
    if (fetchResult.count > 0) {
        for (int i = 0; i < fetchResult.count; i++) {
            
            [self.assets addObject:fetchResult[i]];
        }
    }
    [self reloadData];
}


#pragma mark - 获取相册内所有照片资源
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending

{
    
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PHAsset *asset = (PHAsset *)obj;
        
        [assets addObject:asset];
        
    }];
    _photoLibraryName = @"all";
    [self reloadData];
    
    
    return assets;
    
}

#pragma mark - delegate & dataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //相册图片+照相机图标+照相机获取到的图片
    return self.assets.count+1+self.cammeraImageArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DHPhotoLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DHPhotoLibraryCollectionViewCell" forIndexPath:indexPath];
    
    DHPhotoLibraryCameraCollectionViewCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DHPhotoLibraryCameraCollectionViewCell" forIndexPath:indexPath];
    
    DHWeakSelf;
    cameraCell.getImage = ^(NSMutableDictionary *dict) {
        UIImage *image = dict[@"image"];
        NSMutableArray *tempArr  = [NSMutableArray array];
        
        [tempArr addObjectsFromArray:weakSelf.cammeraImageArr];
        
        //将之前保存的选中状态中的Row移后一行
        NSMutableArray *tempKeyStringArr = [NSMutableArray array];
        NSMutableDictionary *tempSelectedDict = [NSMutableDictionary dictionary];//用临时的来保存修改后的
        //遍历旧的一个个修改
        for (NSString *keyString in weakSelf.dictKeyArr) {
         
            NSArray *sectionAndRow =  [keyString componentsSeparatedByString:@"-"];
            if (sectionAndRow.count < 3) {//相册名称 组 行
                return ;
            }
            NSString *row = [sectionAndRow lastObject];
            
            NSInteger newRow = (long)[row integerValue]+1;
            NSString *newSection = sectionAndRow[1];
            NSString *newSectionAndRow = [NSString stringWithFormat:@"%@-%@-%ld",[sectionAndRow firstObject],newSection,newRow];
            
            [tempSelectedDict setValue:_selectedDict[keyString] forKey:newSectionAndRow];
            [tempKeyStringArr addObject:newSectionAndRow];
        }
        //修改数组中的数据
        [weakSelf.dictKeyArr removeAllObjects];
        [weakSelf.dictKeyArr addObjectsFromArray:tempKeyStringArr];
        
        //修改字典中的数据
        [weakSelf.selectedDict removeAllObjects];
        weakSelf.selectedDict = tempSelectedDict.mutableCopy;
        
        
        //新选中的图片放在第一位，而且默认选中
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
        NSString *dictKey = [NSString stringWithFormat:@"%@-%ld-%ld",_photoLibraryName,(long)tempIndexPath.section,(long)tempIndexPath.row];
        [weakSelf.dictKeyArr addObject:dictKey];
        [weakSelf.selectedDict setValue:image forKey:dictKey];
        
        //将新图片放在第一位
        [weakSelf.cammeraImageArr removeAllObjects];
        [weakSelf.cammeraImageArr addObject:image];
        [weakSelf.cammeraImageArr addObjectsFromArray:tempArr];
      
        //刷新
        [weakSelf reloadData];
    };
    if (indexPath.row == 0) {//如果是第一个则返回相机
        return cameraCell;
    }
    
    if (indexPath.row < self.cammeraImageArr.count+1) {//照相机拍到的图片
        
        cell.images = self.cammeraImageArr[indexPath.row - 1];
        
    }else {
        
        //相册的图片
        cell.images =  [self getImageWithAssets:self.assets[indexPath.row-1-self.cammeraImageArr.count] Size:CGSizeMake([UIScreen mainScreen].bounds.size.width/5, 70) synchronous:NO];
      
    }
 
    NSString *dictKey = [NSString stringWithFormat:@"%@-%ld-%ld",_photoLibraryName,indexPath.section,indexPath.row-1];
    if ([_selectedDict objectForKey:dictKey]) {//已选择的
        cell.isUserSelected = YES;
    }else {
        cell.isUserSelected = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return;//按逻辑来说，不会走到这一行，因为Cell有个按钮会盖住自身去响应
    }
   
    DHPhotoLibraryCollectionViewCell *cell = (DHPhotoLibraryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    
    cell.isUserSelected = !cell.isUserSelected;
    
    NSString *dictKey = [NSString stringWithFormat:@"%@-%ld-%ld",_photoLibraryName,(long)indexPath.section,(long)indexPath.row-1];//选中的图片
    
//    NSString *preViewImageKey = [NSString stringWithFormat:@"%@-%ld-%ld-preView",_photoLibraryName,(long)indexPath.section,(long)indexPath.row-1];//预览时观看的图片
    //存在则移除，不存在则添加
    if ([_selectedDict objectForKey:dictKey]) {
        [_dictKeyArr removeObject:dictKey];
        [_selectedDict removeObjectForKey:dictKey];
        
    }else {
        [_dictKeyArr addObject:dictKey];
        
        UIImage *image = [self getImageWithAssets:self.assets[indexPath.row-1-self.cammeraImageArr.count] Size:SCREEN_SIZE synchronous:YES];
        
        [_selectedDict setValue:image forKey:dictKey];
        
//        [_selectedDict setValue:image forKey:preViewImageKey];
        
    }

}


-(UIImage *)getImageWithAssets:(PHAsset *)asset Size:(CGSize)size synchronous:(BOOL)synchronous{
    
    //相册的图片
    PHImageManager *manage = [[PHImageManager alloc] init];
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
    opt.synchronous = synchronous;//同步会获取高质量图片，等待太久
    
     __block UIImage *image = [[UIImage alloc] init];
    [manage requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (result) {
            image = result;
        }
        
    }];
    
    return image;
}

-(NSMutableArray *)getSelectedImage {
    
    return [_selectedDict allValues].mutableCopy;;
}

@end

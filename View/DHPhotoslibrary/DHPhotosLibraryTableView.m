//
//  DHPhotosLibraryTableView.m
//  appStore
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotosLibraryTableView.h"
#import <Photos/Photos.h>
#import <Photos/PHAsset.h>
#import <Photos/PHFetchResult.h>
#import "DHPhotoLibraryTableViewCell.h"

@interface DHPhotosLibraryTableView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *dataArray;//存有相册名称和首张图片



@property(nonatomic, strong)NSMutableArray *fetchResultArr;//所有的相册数据
@end

@implementation DHPhotosLibraryTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.dataArray = [NSMutableArray array];
        self.fetchResultArr = [NSMutableArray array];
        self.rowHeight = DHAdaptive(300);
        
        [self getSmartAlbumsPhoto];
    }
    return self;
}

//获取智能相册列表
- (void)getSmartAlbumsPhoto{
    
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
        
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            [self.fetchResultArr addObject:assetCollection];//保存当前相册的所有信息
            
            //相册标题
            [dict setValue:assetCollection.localizedTitle forKey:@"title"];

            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
            opt.synchronous = NO;//同步会获取高质量图片，等待太久
            if (fetchResult.count > 0) {
//                PHImageContentModeAspectFill
                [imageManager requestImageForAsset:fetchResult[0] targetSize:CGSizeMake(DHAdaptive(300), DHAdaptive(200)) contentMode:PHImageContentModeDefault options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result) {
                        //相册的第一张图片
                        [dict setValue:result forKey:@"Image"];
                    }
                }];
            }else {
                 [dict setValue:[[UIImage alloc]init] forKey:@"Image"];
            }
            
            
            [self.dataArray addObject:dict];
        }
    }
    [self reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DHPhotoLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DHPhotoLibraryTableViewCell"];
    if (!cell) {
        cell = [[DHPhotoLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DHPhotoLibraryTableViewCell"];
    }
    
    cell.dataDict = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    PHAssetCollection *assetCollection = self.fetchResultArr[indexPath.row];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //相册的所有信息
    [dict setValue:fetchResult forKey:@"fetchResult"];
    //相册标题
    [dict setValue:assetCollection.localizedTitle forKey:@"title"];
    if (self.clickCell) {
        self.clickCell(dict);
    }
    

}


@end

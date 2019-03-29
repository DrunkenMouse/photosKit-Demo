//
//  DHPhotoLibraryTableViewCell.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHPhotoLibraryTableViewCell.h"

@implementation DHPhotoLibraryTableViewCell{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}


-(void)setDataDict:(NSMutableDictionary *)dataDict {
    _dataDict = dataDict;
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DHAdaptive(300), DHAdaptive(200))];
        [self.contentView addSubview:_imageView];
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DHAdaptive(300), 0, DHAdaptive(200), DHAdaptive(200))];
        [self.contentView addSubview:_titleLabel];
    }
    _imageView.image = dataDict[@"Image"];
    _titleLabel.text = dataDict[@"title"];
}
@end

//
//  DHPhotosLibraryTableView.h
//  appStore
//
//  Created by 王奥东 on 2018/3/30.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHTableView.h"

typedef void(^clickCellBlock)(NSMutableDictionary *dict);

@interface DHPhotosLibraryTableView : DHTableView

@property(nonatomic, copy)clickCellBlock clickCell;

@end

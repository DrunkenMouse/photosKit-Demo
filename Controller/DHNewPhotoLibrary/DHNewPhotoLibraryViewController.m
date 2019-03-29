//
//  DHNewPhotoLibraryViewController.m
//  Project_Model
//
//  Created by 王奥东 on 2018/3/28.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHNewPhotoLibraryViewController.h"
#import <Photos/PHPhotoLibrary.h>

#import "DHPhotosLibraryTableView.h"
#import "DHPhotosLibraryCollectionView.h"
#import "DHPhotosLibraryTableView.h"
#import "DHNewPhotoLibraryViewController.h"
#import "DHPhotoLibraryPreviewViewController.h"

@interface DHNewPhotoLibraryViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong)DHPhotosLibraryCollectionView *listCollectionView;//显示图片的CollectionView

@property(nonatomic, strong)DHPhotosLibraryTableView *listTableView;//显示相册的TableView

@property(nonatomic, strong)UIButton *navMidButton;//导航栏中间的按钮

@property(nonatomic, strong)UIButton *navRightButton;//导航栏右边的按钮

@property(nonatomic, strong)UIButton *previewButton;//预览按钮

@property(nonatomic, assign)BOOL isTop;//是否上拉
@end

@implementation DHNewPhotoLibraryViewController{
    
    UIImagePickerController *_imagePickerController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNaviBackButton];
    //展示的Collection
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/5, 70);
    
    _listCollectionView = [[DHPhotosLibraryCollectionView alloc] initWithFrame:CGRectMake(0, DHAdaptive(44), SCREEN_WIDTH, SCREEN_HEIGHT-DHAdaptive(128)) collectionViewLayout:layout];
    _listCollectionView.toolVC = self;
    _listCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listCollectionView];
    //展示的TableView
    _listTableView = [[DHPhotosLibraryTableView alloc] initWithFrame:CGRectMake(0, -DHAdaptive(500), SCREEN_WIDTH, DHAdaptive(500)) style:UITableViewStylePlain];
    [self.view addSubview:_listTableView];
    
    DHWeakSelf;
    _listTableView.clickCell = ^(NSMutableDictionary *dict) {
        weakSelf.listCollectionView.fetchResultDict = dict;
        weakSelf.isTop = YES;
    };
    //导航栏中间的按钮
    _navMidButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-DHAdaptive(100), 0, DHAdaptive(200), DHAdaptive(88))];
    _navMidButton.backgroundColor = [UIColor purpleColor];
    [self.navigationController.navigationBar addSubview:_navMidButton];
   
    //下拉或上收TableView
    [_navMidButton addActionBlockWith:UIControlEventTouchUpInside withBlock:^{
        [UIView animateWithDuration:1.0 animations:^{
         
            weakSelf.isTop = !weakSelf.isTop;
        }];
    }];
    
    //导航栏的右边按钮
    _navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-DHAdaptive(200), 0, DHAdaptive(200), DHAdaptive(88))];
    _navRightButton.backgroundColor = [UIColor orangeColor];
    [self.navigationController.navigationBar addSubview:_navRightButton];
    [_navRightButton addActionBlockWith:UIControlEventTouchUpInside withBlock:^{
  
    }];

    //预览按钮
    _previewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - DHAdaptive(200), DHAdaptive(200), DHAdaptive(88))];
    _previewButton.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_previewButton];
    [_previewButton addActionBlockWith:UIControlEventTouchUpInside withBlock:^{
        DHPhotoLibraryPreviewViewController *vc = [[DHPhotoLibraryPreviewViewController alloc] init];
        NSMutableArray *arr =  [weakSelf.listCollectionView getSelectedImage];
        vc.previewImageArr = arr;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
}

-(void)setIsTop:(BOOL)isTop {
    _isTop = isTop;
    
    if (isTop) {
        _listTableView.frame = CGRectMake(0, -_listTableView.frame.size.height, _listTableView.frame.size.width, _listTableView.frame.size.height);
      
    }else {
        
        _listTableView.frame = CGRectMake(0, 0, _listTableView.frame.size.width, _listTableView.frame.size.height);
    }
    
}
//    [self havePhotoLibraryAuthority];

//    _imagePickerController = [[UIImagePickerController alloc] init];
//
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:_imagePickerController animated:YES completion:nil];
//    _imagePickerController.delegate = self;

//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//    //如果调用的方法没有传sender，则该属性必须提前赋值
//    actionSheet.sender = self;
//
//    //设置照片最大预览数
//    actionSheet.configuration.maxPreviewCount = 20;
//
//    //设置照片最大选择数
//    actionSheet.configuration.maxSelectCount = 9;
//
//    //设置相册内部显示拍照按钮
////    actionSheet.configuration.allowTakePhotoInLibrary = YES;
//
//
//    [actionSheet showPhotoLibraryWithSender:self];
//- (BOOL)havePhotoLibraryAuthority
//{
//
//
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//    if (status == PHAuthorizationStatusAuthorized) {
//        return YES;
//    }
//    return NO;
//}
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//
//
//    NSLog(@"imagePicker : %@",info);
//}
//


@end

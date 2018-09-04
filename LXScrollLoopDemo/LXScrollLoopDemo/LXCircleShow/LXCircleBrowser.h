//
//  LXCircleBrowser.h
//  XiaoLiuRetail
//
//  Created by MacBook pro on 16/5/19.
//  Copyright © 2016年 福中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXCircleBrowserCell.h"


typedef void(^BackBlock)(NSInteger index);

@interface LXCircleBrowser : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    UIPageControl *_pageControl;
    
}

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, strong) UIView *tempView;//快照  [View snapshotViewAfterScreenUpdates:NO]暂时没用到

@property (nonatomic,copy)BackBlock back;

+ (LXCircleBrowser *)showImageInView:(UIView *)view selectImageIndex:(NSInteger)index showPhotos:(NSArray *)photo;

@end

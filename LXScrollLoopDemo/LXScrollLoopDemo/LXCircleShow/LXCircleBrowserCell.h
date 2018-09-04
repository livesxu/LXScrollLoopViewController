//
//  LXCircleBrowserCell.h
//  XiaoLiuRetail
//
//  Created by MacBook pro on 16/5/19.
//  Copyright © 2016年 福中. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kCircleWidth [UIScreen mainScreen].bounds.size.width
#define kCircleHeight [UIScreen mainScreen].bounds.size.width

typedef void(^BackBlock)(NSInteger index);

@interface LXCircleBrowserCell : UICollectionViewCell<UIScrollViewDelegate>



@property(nonatomic,strong)UIScrollView *scrCell;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)CGFloat currentScale;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)NSString *url;//图片地址或者名称

@property(nonatomic,strong)UIView *tempView;//快照

@property (nonatomic,copy)BackBlock back;

@end

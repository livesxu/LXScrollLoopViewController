//
//  LXScrollLoopViewController.m
//  XiaoLiuRetail
//
//  Created by Livespro on 2017/2/17.
//  Copyright © 2017年 福中. All rights reserved.
//

#import "LXScrollLoopViewController.h"
@class ScrollCollectionCell;

@interface LXScrollLoopViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    dispatch_source_t timer;
}

@property (nonatomic,   copy) NSString *reuseIdentifier;

@property (nonatomic, assign)  NSTimeInterval timeInterval;

@property (nonatomic, assign)  NSUInteger itemsCount;

@property (nonatomic, strong)  UICollectionView *collectionShow;

@property (nonatomic, assign) BOOL isLoadOtherConfig;

@end

@implementation LXScrollLoopViewController

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTimer) object:nil];
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<LXScrollDelegate>)delegate;{
    self = [super init];
    if (self) {
        
        _reuseIdentifier = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([ScrollCollectionCell class]),self];
        self.view.frame = frame;
        self.delegate = delegate;
        
    }
    return self;
}

- (void)reloadData;{
    
    _itemsCount  = [self.delegate numberOfItemWithScroll];
    
    if (!_itemsCount) return;
    
    [self.collectionShow reloadData];
    
    [self otherConfig];
}

- (void)setDelegate:(id<LXScrollDelegate>)delegate {
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(numberOfItemWithScroll)] && [self.delegate respondsToSelector:@selector(lxScrollIndex:ReusableCell:)]) {
        
        _itemsCount  = [self.delegate numberOfItemWithScroll];
        
        [self.view addSubview:self.collectionShow];
    }
    
    [self otherConfig];
}

- (void)otherConfig {
    
    if (!_itemsCount || _isLoadOtherConfig) return;
    _isLoadOtherConfig = YES;
    
    if ([self.delegate respondsToSelector:@selector(timeIntervalWithLoop)]) {
        
        _timeInterval = [self.delegate timeIntervalWithLoop];
        
        [self performSelector:@selector(addTimer) withObject:nil afterDelay:_timeInterval];
    } else {
        _timeInterval = 0;
    }
    //first
    [self.collectionShow scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    [self judgeScrollIndex];
}

- (UICollectionView *)collectionShow {
    if (!_collectionShow) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.view.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionShow = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:flowLayout];
        _collectionShow.backgroundColor = [UIColor clearColor];
        _collectionShow.pagingEnabled = YES;
        _collectionShow.showsHorizontalScrollIndicator = NO;
        _collectionShow.showsVerticalScrollIndicator = NO;
        [_collectionShow registerClass:[ScrollCollectionCell class] forCellWithReuseIdentifier:_reuseIdentifier];
        _collectionShow.dataSource = self;
        _collectionShow.delegate = self;
        
    }
    return _collectionShow;
}

- (void)addTimer {
    
    if (timer) return ;
    
    __weak typeof(self) weakSelf = self;
    //定时器
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("LXScrollLoop", DISPATCH_QUEUE_SERIAL));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf autoScroll];
        });
    });
    dispatch_resume(timer);
}

- (void)autoScroll {
    NSInteger curIndex = (self.collectionShow.contentOffset.x) / self.view.bounds.size.width;
    NSInteger toIndex = curIndex + 1;
    
    if (!_itemsCount) return;
        
    [self.collectionShow scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

- (void)stopTimer {
    
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    if (!_itemsCount) return 0;
    
    return _itemsCount + 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    ScrollCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        
        return [self.delegate lxScrollIndex:_itemsCount -1 ReusableCell:collectionCell];
    } else if (indexPath.item == _itemsCount + 1){
        
        return [self.delegate lxScrollIndex:0 ReusableCell:collectionCell];
    } else {
        
        return [self.delegate lxScrollIndex:indexPath.item -1 ReusableCell:collectionCell];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([self.delegate respondsToSelector:@selector(lxScrollSelectIndex:)]) {
        
        if (indexPath.item == 0 || (indexPath.item == _itemsCount + 1)) {
            
            if (indexPath.item) {//伪装真实的第一个
                
                [self.delegate lxScrollSelectIndex:0];
                
            } else {//伪装真实的最后一个
                
                [self.delegate lxScrollSelectIndex:_itemsCount -1];
                
            }
            
        } else {
            
            [self.delegate lxScrollSelectIndex:indexPath.item - 1];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;{

    if (!(indexPath.item == 0 || (indexPath.item == _itemsCount + 1))) {
        
        [self judgeScrollIndex];
    }
}

- (void)judgeScrollIndex {
    
    if (!_itemsCount) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lxScrollDidScrollIndex:)]) {
        
        [self.delegate lxScrollDidScrollIndex:(NSInteger)(self.collectionShow.contentOffset.x/self.view.bounds.size.width)-1];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < self.view.bounds.size.width) {
        
        scrollView.contentOffset=CGPointMake(self.view.bounds.size.width*(_itemsCount) + scrollView.contentOffset.x, 0);
        
    }
    if (scrollView.contentOffset.x >= self.view.bounds.size.width*(_itemsCount + 1)) {
        
        scrollView.contentOffset=CGPointMake(self.view.bounds.size.width + (scrollView.contentOffset.x - self.view.bounds.size.width*(_itemsCount + 1)), 0);
    }
}

@end

@interface ScrollCollectionCell ()

@end

@implementation ScrollCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

@end


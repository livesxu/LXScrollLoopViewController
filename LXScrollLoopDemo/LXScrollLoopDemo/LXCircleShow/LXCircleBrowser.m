//
//  LXCircleBrowser.m
//  XiaoLiuRetail
//
//  Created by MacBook pro on 16/5/19.
//  Copyright © 2016年 福中. All rights reserved.
//

#import "LXCircleBrowser.h"

@implementation LXCircleBrowser
static NSString *LXidentifier = @"LXCircleCell";

+ (LXCircleBrowser *)showImageInView:(UIView *)view selectImageIndex:(NSInteger)index showPhotos:(NSArray *)photo{
    
    LXCircleBrowser *photoBrower = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    photoBrower.currentPhotoIndex = index;
    
    photoBrower.photos=photo;
    
    [view addSubview:photoBrower];
    
    [photoBrower createCollectionView];
    
    [photoBrower createPageControl];
    
    return photoBrower;
    
}
#pragma mark 创建UICollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LXCircleBrowserCell class] forCellWithReuseIdentifier:LXidentifier];
    
    [self addSubview:_collectionView];
    
    //滚动到点击的图片
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - 创建UIPageControl
-(void)createPageControl{
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 30)];
    _pageControl.numberOfPages = _photos.count -2;
    
    _pageControl.currentPage=_currentPhotoIndex-1;
    
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:61/255.0 green:213/255.0 blue:240/255.0 alpha:1];
    
    [_pageControl addTarget:self action:@selector(pageTurn) forControlEvents:UIControlEventValueChanged];

    [self addSubview:_pageControl];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
     LXCircleBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LXidentifier forIndexPath:indexPath];
    
    if (cell.scrCell.zoomScale !=1) {
        
        cell.scrCell.zoomScale = 1;
    }
    
    NSString *urlStr= _photos[indexPath.item];
    
    cell.index=indexPath.item;
    cell.url=urlStr;
    
    __weak LXCircleBrowser *weakSelf=self;
    
    cell.back=^(NSInteger index){
        
        weakSelf.back(index);
    };
    
    return cell;
}

- (void)pageTurn{
    
    _collectionView.contentOffset = CGPointMake((_pageControl.currentPage +1)*[UIScreen mainScreen].bounds.size.width, 0);
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width/2) {
        //
        scrollView.contentOffset=CGPointMake([UIScreen mainScreen].bounds.size.width*(_photos.count-2)+scrollView.contentOffset.x, 0);
        //
    }
    if (scrollView.contentOffset.x > [UIScreen mainScreen].bounds.size.width*(_photos.count-2)+[UIScreen mainScreen].bounds.size.width/2) {
        scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x-(_photos.count-2)*self.frame.size.width, 0);
    }
    
    NSInteger x=scrollView.contentOffset.x/self.frame.size.width;
    
    _pageControl.currentPage=x-1;
  
}


@end

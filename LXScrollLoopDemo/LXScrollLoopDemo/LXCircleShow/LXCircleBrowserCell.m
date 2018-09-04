//
//  LXCircleBrowserCell.m
//  XiaoLiuRetail
//
//  Created by MacBook pro on 16/5/19.
//  Copyright © 2016年 福中. All rights reserved.
//

#import "LXCircleBrowserCell.h"

#import <YYWebImage/YYWebImage.h>

@implementation LXCircleBrowserCell

-(instancetype)initWithFrame:(CGRect)frame{
   
    if ([super initWithFrame:frame]) {
       
        self.contentView.backgroundColor=[UIColor blackColor];
        
        _scrCell=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _scrCell.contentSize=CGSizeMake(kCircleWidth, kCircleHeight);
        _scrCell.delegate=self;
        _scrCell.maximumZoomScale=5;
        
        UITapGestureRecognizer *tapBack=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToBack)];
        
        [_scrCell addGestureRecognizer:tapBack];
        
        [self.contentView addSubview:_scrCell];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,([UIScreen mainScreen].bounds.size.height - kCircleHeight)/2, kCircleWidth, kCircleHeight)];

        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imgView.userInteractionEnabled=YES;
        
        [_scrCell addSubview:_imgView];
    }
    
    return self;
}
-(void)setUrl:(NSString *)url{
    
    _url=url;
    
    _imgView.yy_imageURL = [NSURL URLWithString:_url];
    
}

-(void)tapToBack{
    
    self.back(_index);
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _imgView;//指定_imgView做zoom操作
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{//停止减速还原
    
    if (scrollView.contentOffset.x == 0 || (scrollView.contentOffset.x +1)>(_currentScale-1) *kCircleWidth) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.scrCell.zoomScale=1;
        }];
        
    }
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{//停止zoom判断加手势
    
    if (scale !=1) {//添加一个zoomScale=1的手势
        
        _currentScale=scale;
        
        UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [_imgView addGestureRecognizer:tapG];
      
    }
}
//移除掉自身，zoomScale=1
-(void)tap:(UITapGestureRecognizer *)tapG{
    
    __weak typeof(self) weakSelf = self;
    [_imgView removeGestureRecognizer:tapG];
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.scrCell.zoomScale=1;
    }];
  
}


@end

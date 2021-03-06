//
//  LXCircleShow.m
//  XiaoLiuRetail
//
//  Created by MacBook pro on 16/5/18.
//  Copyright © 2016年 福中. All rights reserved.
//

#import "LXCircleShow.h"

#import <YYWebImage/YYWebImage.h>

#define kDefaultHeaderFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

@interface LXCircleShow ()

@property(nonatomic,strong)NSMutableArray *parallaxImageArr;//轮播图用的图片数组

@property(nonatomic,strong)UIScrollView *circleScrView;//展示轮播图scr



@end

@implementation LXCircleShow

+(LXCircleShow *)LXCircleShowWithFrame:(CGRect)frame{
    
    LXCircleShow *showVC=[[LXCircleShow alloc]init];
    
    showVC.view.frame=frame;
    
    return showVC;
}


-(void)setImageArr:(NSArray *)imageArr{
    
    _imageArr=imageArr;
    
    [self staticData];
}


//下拉或者上拉的时候改变circleScrView的大小
-(void)changeFrameWithFatherOffset:(CGPoint)offset{
    
//    CGRect frame = self.circleScrView.frame;
    
    if (offset.y > 0)
    {
//        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
//        self.circleScrView.frame = frame;
//        
//        self.view.clipsToBounds = YES;
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = kDefaultHeaderFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.circleScrView.frame = rect;
        self.view.clipsToBounds = NO;
    }
}

-(void)staticData{
    
    //添加两张伪图
    self.parallaxImageArr = [NSMutableArray arrayWithArray:_imageArr];
    
    if (_imageArr.count) {
        [self.parallaxImageArr insertObject:_imageArr.lastObject atIndex:0];
        [self.parallaxImageArr addObject:_imageArr.firstObject];
    }
    
    self.circleScrView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.circleScrView.pagingEnabled = YES;
    self.circleScrView.delegate = self;
    self.circleScrView.showsHorizontalScrollIndicator = NO;
    
     self.circleScrView.contentSize = CGSizeMake(self.view.bounds.size.width * self.parallaxImageArr.count, self.view.bounds.size.height);
    
    self.circleScrView.contentOffset=CGPointMake(self.view.bounds.size.width, 0);
    
    [self.view addSubview:self.circleScrView];
    
    
    for (int i = 0; i < self.parallaxImageArr.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        
        if (self.parallaxImageArr[i])
        {
            [self giveImgInView:imageView index:i];
            
            [self.circleScrView addSubview:imageView];
            
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tapG];
            
        }
    }
}
//赋值图片
-(void)giveImgInView:(UIImageView *)imageView index:(int)i{
    
    NSString *urlStr = self.parallaxImageArr[i];
    
    imageView.yy_imageURL = [NSURL URLWithString:urlStr];
}
//手势action
-(void)tapImage:(UITapGestureRecognizer *)tap{
    
    NSInteger i = tap.view.tag-100;
    
    LXCircleBrowser *browser=[LXCircleBrowser showImageInView:[UIApplication sharedApplication].keyWindow selectImageIndex:i showPhotos:_parallaxImageArr];
    __weak LXCircleBrowser *safeBrowser=browser;
    __weak typeof(self) weakSelf = self;
    browser.back=^(NSInteger i){
        
       [safeBrowser removeFromSuperview];
       weakSelf.circleScrView.contentOffset = CGPointMake(weakSelf.view.bounds.size.width * i, 0);
    };
    
}

//轮播
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < self.view.bounds.size.width/2) {
        
        scrollView.contentOffset=CGPointMake(self.view.bounds.size.width*(self.parallaxImageArr.count-2)+scrollView.contentOffset.x, 0);
        
    }
    if (scrollView.contentOffset.x > self.view.bounds.size.width*(self.parallaxImageArr.count-2)+self.view.bounds.size.width/2) {
        scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x-(self.parallaxImageArr.count-2)*self.view.bounds.size.width, 0);
    }
}

@end

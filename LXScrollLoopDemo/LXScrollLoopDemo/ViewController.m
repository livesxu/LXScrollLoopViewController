//
//  ViewController.m
//  LXScrollLoopDemo
//
//  Created by livesxu on 2018/9/4.
//  Copyright © 2018年 Livesxu. All rights reserved.
//

#import "ViewController.h"

#import "LXScrollLoopViewController.h"

#import <YYWebImage/YYWebImage.h>

#import "LXCircleShow.h"

@interface ViewController ()<LXScrollDelegate>

@property (nonatomic, strong) LXScrollLoopViewController *loopVc;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) LXCircleShow *circleVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addChildViewController:self.loopVc];
    [self.view addSubview:self.loopVc.view];
    
    
    [self addChildViewController:self.circleVc];
    [self.view addSubview:self.circleVc.view];
    self.circleVc.imageArr = self.dataArray;
}

- (LXScrollLoopViewController *)loopVc {
    
    if (!_loopVc) {
        
        _loopVc = [[LXScrollLoopViewController alloc]initWithFrame:CGRectMake(0, 20, 375, 375) Delegate:self];
    }
    return _loopVc;
}

- (LXCircleShow *)circleVc {
    
    if (!_circleVc) {
        
        _circleVc = [LXCircleShow LXCircleShowWithFrame:CGRectMake(0, 420, 250, 250)];
    }
    return _circleVc;
}


- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536055101494&di=d863968a632b2443e324ee9778ce05a4&imgtype=0&src=http%3A%2F%2Fpic.xiudodo.com%2Ffigure%2F00%2F00%2F33%2F16%2F73%2F1655bda6abbcd26.jpg"];
        [_dataArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536055143387&di=d7ecd5ca38597a782b395c5d843165d3&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Falbum%2F201605%2F09%2F155052ru0wm064s8jh0mju.jpg"];
        [_dataArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536055157331&di=91594a316b52adc94911aceaeacf3e95&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fblog%2F201404%2F06%2F20140406232455_m5XVy.jpeg"];
        [_dataArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536055174257&di=dddaa9f392917b4718c7a09d5eda0611&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fe%2F58fb005766f6b.jpg"];
    }
    return _dataArray;
}

- (NSInteger)numberOfItemWithScroll;{
    
    return self.dataArray.count;
}

- (ScrollCollectionCell *)lxScrollIndex:(NSInteger)index ReusableCell:(ScrollCollectionCell *)reusableCell;{
    
    NSString *imgUrl = self.dataArray[index];
    
    [reusableCell.imageView yy_setImageWithURL:[NSURL URLWithString:imgUrl] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    
    //自定义样式范例
    UILabel *label = [reusableCell.contentView viewWithTag:10001];
    if (!label) {
        label= [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 300, 50)];
        label.tag = 10001;
        [reusableCell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"第%ld张图片",index];
    
    return reusableCell;
}

//@optional

- (void)lxScrollDidScrollIndex:(NSInteger)index {
    
    NSLog(@"%@", [NSString stringWithFormat:@"出现第%ld张图片",index]);
}

- (void)lxScrollSelectIndex:(NSInteger)index;{
    
    NSLog(@"%@", [NSString stringWithFormat:@"第%ld张图片",index]);
}

//- (NSTimeInterval)timeIntervalWithLoop;{
//    
//    return 5;
//}

@end

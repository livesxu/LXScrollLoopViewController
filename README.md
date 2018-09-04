# LXScrollLoopViewController
轮播图，轮播展示，demo放大展示
LXScrollLoopViewController
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

- (void)lxScrollSelectIndex:(NSInteger)index;{

NSLog(@"%@", [NSString stringWithFormat:@"第%ld张图片",index]);
}

- (NSTimeInterval)timeIntervalWithLoop;{

return 5;
}

LXCircleShow 放大代码
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

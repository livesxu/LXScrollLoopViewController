
#import <UIKit/UIKit.h>
@class ScrollCollectionCell;

@protocol LXScrollDelegate <NSObject>

@required
/**
 数据源

 @return 展示数据量
 */
- (NSInteger)numberOfItemWithScroll;
/**
 数据源

 @param index 下标
 @param reusableCell 复用cell(基础cell)
 @return 使用cell
 */
- (ScrollCollectionCell *)lxScrollIndex:(NSInteger)index ReusableCell:(ScrollCollectionCell *)reusableCell;

@optional

/**
 点击事件

 @param index 下标
 */
- (void)lxScrollSelectIndex:(NSInteger)index;
/**
 轮播间隔时间

 @return 间隔时间
 */
- (NSTimeInterval)timeIntervalWithLoop;

@end

@interface LXScrollLoopViewController : UIViewController

@property (nonatomic, assign) id<LXScrollDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<LXScrollDelegate>)delegate;

- (void)reloadData;

@end

@interface ScrollCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

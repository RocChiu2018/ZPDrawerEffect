//
//  ViewController.m
//  抽屉效果
//
//  Created by 赵鹏 on 2018/10/30.
//  Copyright © 2018 赵鹏. All rights reserved.
//

#define kMaxY 80  //当中间视图移到最右侧或者最左侧的时候，中间视图在y轴上移动的最大距离
#define kScreenW [UIScreen mainScreen].bounds.size.width  //屏幕的宽度
#define kScreenH [UIScreen mainScreen].bounds.size.height  //屏幕的高度
#define kMiddleViewLeftLocatedPoint 275  //把中间视图往右拖拽并且当拖拽停止的时候，如果此时中间视图的x值大于屏幕宽度一半的话则中间视图停留在该位置上。
#define kMiddleViewRightLocatedPoint -250  //把中间视图往左拖拽并且当拖拽停止的时候，如果此时中间视图的x值小于屏幕宽度一半的话则中间视图停留在该位置上。

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化子视图
    [self initializeChildView];
    
    //添加拖拽手势识别器
    [self addPanGestureRecognizer];
    
    //利用KVO模式来监听中间视图的frame的x值，如果x值大于0则证明中间视图是往右侧滑动的，如果x值小于0则证明中间视图是往左侧滑动的。
    [self.middleView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    /**
     无论中间视图处在什么位置上，点击窗口上的任意一点，中间视图都会恢复到覆盖整个屏幕的位置上；
     添加上述的点击手势：
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark ————— 初始化子视图 —————
- (void)initializeChildView
{
    //左边子视图
    _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.leftView];
    
    //右边子视图
    _rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.rightView];
    
    //中间子视图
    _middleView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.middleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.middleView];
}

#pragma mark ————— 添加拖拽手势识别器 —————
- (void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark ————— 拖拽 —————
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取手势移动的位置
    CGPoint currentPoint = [pan translationInView:self.view];
    
    //获取手势在X轴上的偏移量(这个偏移量是相对于上个位置来说的)
    CGFloat offsetX = currentPoint.x;
    
    //修改中间子视图的位置
    self.middleView.frame = [self modificationMiddleViewFrameWithOffsetX:offsetX];
    
    //复位
    [pan setTranslation:CGPointZero inView:self.view];
    
    /**
     当拖拽手势结束的时候要判断中间视图所处的位置，根据当时中间视图所处的位置来让中间视图覆盖整个窗口或处于窗口的某个位置上。
     */
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat locatedPoint = 0;
        
        NSLog(@"%@", NSStringFromCGRect(self.middleView.frame));
        
        if (self.middleView.frame.origin.x > kScreenW * 0.5)  //把中间视图往右拖拽并且当拖拽停止的时候，如果此时中间视图的x值大于屏幕宽度一半的话则中间视图停留在屏幕的kMiddleViewLeftLocatedPoint位置上。
        {
            locatedPoint = kMiddleViewLeftLocatedPoint;
        }else if (CGRectGetMaxX(self.middleView.frame) < kScreenW * 0.5)  //把中间视图往左拖拽并且当拖拽停止的时候，如果此时中间视图的x值小于屏幕宽度一半的话则中间视图停留在kMiddleViewRightLocatedPoint位置上。
        {
            locatedPoint = kMiddleViewRightLocatedPoint;
        }else  //其余的情况则中间视图恢复原状（覆盖整个窗口）
        {
            locatedPoint = 0;
        }
        
        if (locatedPoint == 0)  //经过拖拽后中间视图恢复原状(覆盖整个窗口)
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.middleView.frame = self.view.bounds;
            }];
        }else  //经过拖拽后中间视图停留在窗口的某个位置上
        {
            [UIView animateWithDuration:0.25 animations:^{
                //获取中间视图在x轴上的偏移量
                CGFloat offsetX = locatedPoint - self.middleView.frame.origin.x;
                
                //修改中间视图的位置
                self.middleView.frame = [self modificationMiddleViewFrameWithOffsetX:offsetX];
            }];
        }
    }
}

#pragma mark ————— 根据手势在X轴上的偏移量修改中间子视图的位置 —————
- (CGRect)modificationMiddleViewFrameWithOffsetX:(CGFloat)offsetX
{
    //获取上一次中间视图的frame
    CGRect frame = self.middleView.frame;
    
    /**
     设置中间视图在y轴上移动的距离：
     中间视图在x轴上移动一段距离的同时也要在y轴上移动一段距离；
     y轴移动的距离应该是x轴移动的距离乘以一个系数，这个系数应该是当中间视图移动到最左端或者最右端时在y轴上的坐标除以屏幕的高度，在本Demo中在上述的情况下假设y轴的坐标为80；
     中间视图往右滑的时候是正值，往左滑的时候是负值。
     */
    CGFloat offsetY = offsetX * kMaxY / kScreenH;
    
    //获取上一次中间视图的高度
    CGFloat previousH = frame.size.height;
    
    //获取上一次中间视图的宽度
    CGFloat previousW = frame.size.width;
    
    //设置当前中间视图的高度：
    CGFloat currentH;
    if (frame.origin.x < 0)  //中间视图往左滑动，offsetY是负值
    {
        currentH = previousH + 2 * offsetY;
    }else  //中间视图往右滑动，offsetY是正值
    {
        currentH = previousH - 2 * offsetY;
    }
    
    /**
     获取中间视图在拖拽时它的缩放比例：
     这个缩放比例有别于上面"kMaxY / kScreenH"的比例系数，这两个比例是两个完全不同的比例。
     */
    CGFloat scale = currentH / previousH;
    
    //设置当前中间视图的宽度：
    CGFloat currentW = previousW * scale;
    
    //设置当前中间视图的x值：
    frame.origin.x += offsetX;
    
    /**
     设置当前中间视图的y值：
     不能依赖于offsetY，因为中间视图往右滑的时候offsetY是正值，往左滑的时候offsetY是负值。
     */
    CGFloat currentY = (kScreenH - currentH) / 2;
    
    //设置当前中间视图的坐标和位置：
    frame.origin.y = currentY;
    frame.size.height = currentH;
    frame.size.width = currentW;
    
    return frame;
}

#pragma mark ————— KVO的监听方法 —————
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
    NSLog(@"%@", NSStringFromCGRect(self.middleView.frame));
    
    if (self.middleView.frame.origin.x > 0)  //中间视图往右边滑，露出左边的绿色视图
    {
        self.rightView.hidden = YES;
    }else if (self.middleView.frame.origin.x < 0)  //中间视图往左边滑，露出右边的蓝色视图
    {
        self.rightView.hidden = NO;
    }
}

#pragma mark ————— 点击 —————
- (void)tap
{
    if (self.middleView.frame.origin.x != 0)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.middleView.frame = self.view.bounds;
        }];
    }
}

//在视图销毁的时候移除观察者
- (void)dealloc
{
    [self.middleView removeObserver:self forKeyPath:@"frame"];
}

@end

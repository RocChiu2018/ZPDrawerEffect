//
//  ZPViewController.m
//  抽屉效果
//
//  Created by 赵鹏 on 2018/11/27.
//  Copyright © 2018 赵鹏. All rights reserved.
//

#import "ZPViewController.h"
#import "ZPTableViewController.h"

@interface ZPViewController ()

@end

@implementation ZPViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZPTableViewController *VC = [[ZPTableViewController alloc] init];
    VC.view.frame = self.view.bounds;
    
    /**
     为了防止出了这个方法之外VC视图控制器会被销毁，所以当A视图控制器的view成为B视图控制器的view的子视图的时候，一定要先让A视图控制器成为B视图控制器的子视图控制器。
     */
    [self addChildViewController:VC];
    
    [self.middleView addSubview:VC.view];
}

@end

//
//  ZPTableViewController.m
//  抽屉效果
//
//  Created by 赵鹏 on 2018/11/27.
//  Copyright © 2018 赵鹏. All rights reserved.
//

#import "ZPTableViewController.h"

@interface ZPTableViewController ()

@end

@implementation ZPTableViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据 -- %ld", (long)indexPath.row];
    
    return cell;
}

@end

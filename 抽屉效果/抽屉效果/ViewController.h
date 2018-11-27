//
//  ViewController.h
//  抽屉效果
//
//  Created by 赵鹏 on 2018/10/30.
//  Copyright © 2018 赵鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 为了在本类的子类中能够引用如下的几个属性，所以要把如下的几个控件暴露出来放在.h文件中；
 为了防止本类的子类擅自篡改本类的属性，所以要在这些属性的前面加上"readonly"关键字，加完该关键字之后就只能生成这些属性的getter方法而不能生成setter方法了，换言之在子类中就只能读取父类属性的值而不能设置它们的值了;
 给父类中的属性加完"readonly"关键字之后，在其子类中如果利用"self."语法（调用该属性的setter方法）设置这个属性的值的话就会报错，但是可以利用"self."语法（调用该属性的getter方法）获取这个父类中该属性的值。
 */
@property (nonatomic, strong, readonly) UIView *leftView;  //左侧子视图
@property (nonatomic, strong, readonly) UIView *rightView;  //右侧子视图
@property (nonatomic, strong, readonly) UIView *middleView;  //中间子视图

@end

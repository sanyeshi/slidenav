//
//  SSLSlideNav.h
//  SSLSlideNav
//
//  Created by 孙硕磊 on 16/2/6.
//  Copyright © 2016年 dhu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSLSlideNav : UIViewController
-(instancetype) initWithTitles:(NSArray<NSString *> *) titles viewControllers:(NSArray<UIViewController *> *)viewControllers;
@end

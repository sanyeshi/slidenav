//
//  MainViewController.m
//  SSLSlideNav
//
//  Created by 孙硕磊 on 16/2/6.
//  Copyright © 2016年 dhu.cst. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Util.h"
#import "SSLSlideNav.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    CGFloat statusBarH=[UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarH=self.navigationController.navigationBar.frame.size.height;
    NSArray * titles=@[@"头条",@"热点",@"科技",@"体育",@"本地",@"订阅",@"财经",@"汽车",@"时尚",@"图片"];
    
    UIViewController * headline=[[UIViewController alloc] init];
    headline.view.backgroundColor=[UIColor yellowColor];
    
    UIViewController * hotspot=[[UIViewController alloc] init];
    hotspot.view.backgroundColor=[UIColor blueColor];
    
    UIViewController * tec=[[UIViewController alloc] init];
    tec.view.backgroundColor=[UIColor greenColor];
    
    UIViewController * sport=[[UIViewController alloc] init];
    sport.view.backgroundColor=[UIColor yellowColor];
    
    UIViewController * local=[[UIViewController alloc] init];
    local.view.backgroundColor=[UIColor blueColor];
    
    UIViewController * sub=[[UIViewController alloc] init];
    sub.view.backgroundColor=[UIColor greenColor];
    
    UIViewController * fin=[[UIViewController alloc] init];
    fin.view.backgroundColor=[UIColor yellowColor];
    
    UIViewController * car=[[UIViewController alloc] init];
    car.view.backgroundColor=[UIColor blueColor];

    UIViewController * fashion=[[UIViewController alloc] init];
    fashion.view.backgroundColor=[UIColor greenColor];
    
    UIViewController * image=[[UIViewController alloc] init];
    image.view.backgroundColor=[UIColor yellowColor];
    
    NSArray * vcs=@[headline,hotspot,tec,sport,local,sub,fin,car,fashion,image];
    
    SSLSlideNav * nav=[[SSLSlideNav alloc] initWithTitles:titles viewControllers:vcs];
    nav.view.frame=CGRectMake(0, 0, self.view.width, self.view.height-statusBarH-navBarH);
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end

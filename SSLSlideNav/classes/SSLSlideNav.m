//
//  SSLSlideNav.m
//  SSLSlideNav
//
//  Created by 孙硕磊 on 16/2/6.
//  Copyright © 2016年 dhu.cst. All rights reserved.
//

#import "SSLSlideNav.h"
#import "UIView+Util.h"
#import "NSString+Util.h"

#define kBtnHeight  44.0f    //按钮高度
#define kBtnMargin  22.0f    //按钮间距
#define kBtnPadding 10.0f    //按钮左右内填充
#define kBtnFont    [UIFont systemFontOfSize:14.0f] //按钮字体
#define kMaxScale   1.2f     //选中文字放大

@interface SSLSlideNav ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView * titleScrollView;            //标题滚动视图
@property(nonatomic,strong) UIScrollView * contentScrollView;          //内容滚动视图
@property(nonatomic,strong) NSArray<NSString *> * titles;              //标题文字
@property(nonatomic,strong) NSArray<UIViewController *> * viewControllers; //子视图控制器
@property(nonatomic,strong) NSArray<UIButton *> * buttons;             //标题按钮
@property(nonatomic,strong) UIButton * selectedBtn;

@end

@implementation SSLSlideNav

-(instancetype)initWithTitles:(NSArray<NSString *> *)titles viewControllers:(NSArray<UIViewController *> *)viewControllers
{
    self=[super init];
    if (self)
    {
        _titles=titles;
        _viewControllers=viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setupTitleScrollView];
    [self setupContentScrollView];
}


-(void) setupTitleScrollView
{
    _titleScrollView=[[UIScrollView alloc] init];
    _titleScrollView.frame=CGRectMake(0, 0, self.view.width, 44);
    _titleScrollView.backgroundColor=[UIColor whiteColor];
    _titleScrollView.showsHorizontalScrollIndicator=NO;
    _titleScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_titleScrollView];
    CGFloat btnX=0.0f;
    CGFloat btnY=0.0f;
    CGFloat btnH=kBtnHeight;
    CGFloat btnW=0.0f;
    CGFloat btnMargin=kBtnMargin;
    CGFloat btnPadding=kBtnPadding;
    UIFont * font=[UIFont systemFontOfSize:14.0f];
    NSMutableArray * btns=[NSMutableArray arrayWithCapacity:_titles.count];
    for (int i=0; i<_titles.count; i++)
    {
        //计算title占用空间大小
        CGSize size=[_titles[i] sizeWithFont:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        UIButton * btn=[[UIButton alloc] init];
        btn.tag=i;
        btnX+=btnMargin;
        //按钮宽度=左右内填充+title宽度
        btnW=btnPadding+size.width+btnPadding;
        btn.frame=CGRectMake(btnX,btnY, btnW, btnH);
        btn.titleLabel.font=font;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:btn];
        [btns addObject:btn];
        btnX+=btnW;
    }
    _titleScrollView.contentSize=CGSizeMake(btnX+btnMargin, 0);
    _buttons=[btns copy];
    _selectedBtn=_buttons[0];
    [self clickBtn:_selectedBtn];
}


-(void) setupContentScrollView
{
    _contentScrollView=[[UIScrollView alloc] init];
    _contentScrollView.frame=CGRectMake(0, CGRectGetMaxY(_titleScrollView.frame), self.view.width, self.view.height-CGRectGetMaxY(_titleScrollView.frame));
    _contentScrollView.backgroundColor=[UIColor whiteColor];
    _contentScrollView.showsHorizontalScrollIndicator=NO;
    _contentScrollView.showsVerticalScrollIndicator=NO;
    _contentScrollView.pagingEnabled=YES;
    _contentScrollView.delegate=self;
    [self.view addSubview:_contentScrollView];
    CGFloat vcW=_contentScrollView.width;
    CGFloat vcH=_contentScrollView.height;
    CGFloat vcX=0;
    CGFloat vcY=0;
#warning 改进：循环利用
    for (int i=0; i<_viewControllers.count; i++)
    {
        vcX=i*vcW;
        UIView * view=_viewControllers[i].view;
        view.frame=CGRectMake(vcX, vcY, vcW, vcH);
        [_contentScrollView addSubview:view];
    }
    _contentScrollView.contentSize=CGSizeMake(_viewControllers.count*vcW, 0);
}

/*
 *使按钮在titleScrollView可视区域内居中显示
 */
-(void)setupBtnCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - _titleScrollView.width * 0.5;
    if (offset < 0)
    {
        offset = 0;
    }
    CGFloat maxOffset  = _titleScrollView.contentSize.width - _titleScrollView.width;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
/*
 *点击标题按钮触发
 */
-(void) clickBtn:(UIButton *) btn
{

    [self scrollToViewAtIndex:btn.tag];
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectedBtn.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(kMaxScale,kMaxScale);
    _selectedBtn = btn;
    
    [self setupBtnCenter:btn];
}
/*
 *将内容视图滚动到指定位置
 */
-(void) scrollToViewAtIndex:(NSInteger) index
{
    if (index>=0)
    {
        _contentScrollView.contentOffset=CGPointMake(index*_contentScrollView.width,0);
    }
}
#pragma mark -- scrollView代理方法
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX  = scrollView.contentOffset.x;
    if (offsetX<0)
    {
        return;
    }
    NSInteger fromIndex  = scrollView.contentOffset.x/ scrollView.width;
    NSInteger toIndex=fromIndex+1;
    //左滑 offset.x增大;右滑 offset.x减小
    UIButton * fromBtn=_buttons[fromIndex];
    UIButton * toBtn=nil;
    if(toIndex<_buttons.count)
    {
        toBtn=_buttons[toIndex];
    }
    CGFloat scaleTo  = offsetX /scrollView.width -fromIndex;
    CGFloat scaleFrom  = 1.0f- scaleTo;
    CGFloat transScale = kMaxScale - 1.0f;
    
    fromBtn.transform = CGAffineTransformMakeScale(scaleFrom * transScale + 1, scaleFrom * transScale + 1);
    toBtn.transform = CGAffineTransformMakeScale(scaleTo * transScale + 1, scaleTo * transScale + 1);
    
    //fromColor:Red(255,0,0)->Black(0,0,0)
    //toColor:Black(0,0,0)->Red(255,0,0)
    UIColor *fromColor =[UIColor colorWithRed:(255-255*scaleTo)/255.0 green:0.0 blue:0.0 alpha:1];
    UIColor *toColor =[UIColor colorWithRed:(0+255*scaleTo)/255.0 green:0.0 blue:0.0 alpha:1];
    
    [fromBtn setTitleColor:fromColor forState:UIControlStateNormal];
    [toBtn setTitleColor:toColor forState:UIControlStateNormal];

}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index=scrollView.contentOffset.x/scrollView.width;
    _selectedBtn=_buttons[index];
    [self clickBtn:_selectedBtn];
}
@end

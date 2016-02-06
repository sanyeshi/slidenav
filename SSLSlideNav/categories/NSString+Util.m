//
//  NSString+Util.m
//  SSLSlideNav
//
//  Created by 孙硕磊 on 16/2/6.
//  Copyright © 2016年 dhu.cst. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)
//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

//
//  UIImage+CSRCategory.h
//  Test
//
//  Created by LeoAiolia on 2017/2/14.
//  Copyright © 2017年 run. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CSRCategory)

+ (UIImage *)imageFromColor:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
@end

//
//  OpenCVWrapper.h
//  MyRecolor
//
//  Created by Linsw on 16/4/27.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject
+ (UIImage *)floodFill:(UIImage*)inputImage point:(CGPoint)point replacementColor:(UIColor*)replacementColor;
@end

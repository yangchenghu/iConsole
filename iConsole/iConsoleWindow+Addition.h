//
//  iConsoleWindow+Addition.h
//  
//
//  Created by yangchenghu on 13-6-20.
//  Copyright (c) 2013年  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iConsole.h"

@interface iConsoleWindow (Addition)

/**
 * @description 指定显示iConsoleView的Controller的class的name
 * @param
 * @return
 */
- (void)setShowConsoleViewControllerClass:(NSString *)strClassName;

/**
 * @description 手指滑动距离后触发，建议范围在（10 - 40），因为window的取样比较快
 * @description 即两个一个touch对象的前一个点和当前点的距离比较短
 * @param
 * @return
 */
- (void)setSlideDistance:(NSInteger )iDistance;




@end

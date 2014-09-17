//
//  iConsoleWindow+Addition.m
//
//
//  Created by yangchenghu on 13-6-20.
//  Copyright (c) 2013年  All rights reserved.
//

#import "iConsoleWindow+Addition.h"
#import <objc/runtime.h>

static char const * const showiConsoleViewClassName = "calssName";
static char const * const slideDistance = "slideDistance";

@implementation iConsoleWindow(Addition)

- (void)setShowConsoleViewControllerClass:(NSString *)strClassName
{
    objc_setAssociatedObject(self, showiConsoleViewClassName, strClassName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)getShowViewControllerClassName;
{
    id obj = objc_getAssociatedObject(self, showiConsoleViewClassName);
    
    return (NSString *)obj;
}

- (void)setSlideDistance:(NSInteger)iDistance
{
    if (0 > iDistance)
    {
        iDistance = (NSInteger)abs((int)iDistance);
    }
    objc_setAssociatedObject(self, slideDistance, @(iDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)getSlideDistance
{
    id obj = objc_getAssociatedObject(self, slideDistance);
    
    if (nil == obj)
    {
        return 1;
    }
    
    return [(NSNumber *)obj integerValue];
}

- (void)sendEvent:(UIEvent *)event
{
#ifdef DEBUG
    
    NSString * strShowViewControllerClassName = [self getShowViewControllerClassName];
    
    BOOL bIsSelectedView = YES;
    
    if (nil !=  strShowViewControllerClassName)
    {
        UIViewController * currentViewController = nil;
        
        if ([self.rootViewController isKindOfClass:[UITabBarController class]])
        {
            UIViewController * vc = [(UITabBarController *)self.rootViewController selectedViewController];
            if ([vc isKindOfClass:[UINavigationController class]])
            {
                currentViewController = ((UINavigationController *)vc).topViewController;
            }
            else
            {
                currentViewController = vc;
            }
            bIsSelectedView = [currentViewController isKindOfClass:NSClassFromString(strShowViewControllerClassName)];
        }
    }
    
	if ([iConsole sharedConsole].enabled && event.type == UIEventTypeTouches && bIsSelectedView)
	{
		NSSet *touches = [event allTouches];
		if ([touches count] == (TARGET_IPHONE_SIMULATOR ? [iConsole sharedConsole].simulatorTouchesToShow: [iConsole sharedConsole].deviceTouchesToShow))
		{
			BOOL allUp = NO;
			BOOL allDown = NO;
			BOOL allLeft = NO;
			BOOL allRight = NO;
			
            NSInteger idistance = [self getSlideDistance];
            
			for (UITouch *touch in touches)
			{
                int y = [touch locationInView:self].y - [touch previousLocationInView:self].y;
                //        NSLog(@"y is:%d", y);
                if( y >0  &&  y > idistance)
				{
					allDown = YES;
				}
                if (y <0 && abs(y) > idistance)
				{
					allUp = YES;
				}
                
                int x = [touch locationInView:self].x - [touch previousLocationInView:self].x;

                if (x > 0 && x > idistance)
				{
					allLeft = YES;
				}
                if (x < 0 && abs(x) > idistance)
				{
					allRight = YES;
				}
			}
			
			switch ((NSInteger)[UIApplication sharedApplication].statusBarOrientation)
            {
				case UIInterfaceOrientationPortrait:
                {
					if (allUp)
					{
						[iConsole show];
					}
					else if (allDown)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationPortraitUpsideDown:
                {
					if (allDown)
					{
						[iConsole show];
					}
					else if (allUp)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeLeft:
                {
					if (allRight)
					{
						[iConsole show];
					}
					else if (allLeft)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeRight:
                {
					if (allLeft)
					{
						[iConsole show];
					}
					else if (allRight)
					{
						[iConsole hide];
					}
					break;
                }
			}
		}
	}
#endif
    
	return [super sendEvent:event];
}

@end

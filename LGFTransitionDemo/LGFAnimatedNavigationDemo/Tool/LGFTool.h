//
//  LGFTool.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGFNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGFTool : NSObject
+ (LGFNavigationBar *)lgf_AddNavigationBar:(UIView *)SV title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END

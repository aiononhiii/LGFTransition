//
//  LGFPopMenuStyle.m
//  LGFOCTool
//
//  Created by apple on 2017/5/9.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import "LGFPopMenuStyle.h"

@implementation LGFPopMenuStyle

- (instancetype)init {
    if (self = [super init]) {
        // 默认配置
        
    }
    return self;
}

+ (instancetype)na {
    static LGFPopMenuStyle *style = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        style = [[LGFPopMenuStyle alloc] init];
    });
    return style;
}

@end

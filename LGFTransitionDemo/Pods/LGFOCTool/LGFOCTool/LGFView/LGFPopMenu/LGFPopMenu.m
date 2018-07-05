//
//  LGFPopMenu.m
//  LGFOCTool
//
//  Created by apple on 2017/5/9.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import "LGFPopMenu.h"

@implementation LGFPopMenu

+ (instancetype)na {
    static LGFPopMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[LGFPopMenu alloc] init];
    });
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

@end

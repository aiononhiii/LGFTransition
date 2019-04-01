//
//  LGFTitleLine.h
//  LGFPageTitleView
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFTitles.h"

@interface LGFTitleLine : UIImageView

/**
 配置用模型
 */
@property (strong, nonatomic) LGFPageTitleStyle *style;

/**
 标底部滚动条初始化

 @param style 配置用模型
 @return LGFTitleLine
 */
+ (instancetype)style:(LGFPageTitleStyle *)style;
@end

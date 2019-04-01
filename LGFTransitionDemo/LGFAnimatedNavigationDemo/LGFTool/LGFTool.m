//
//  LGFTool.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import "LGFTool.h"

@implementation LGFTool

+ (LGFNavigationBar *)lgf_AddNavigationBar:(UIView *)SV title:(NSString *)title {
    LGFNavigationBarStyle *style = [LGFNavigationBarStyle lgf];
    style.lgf_ShowLeftBtnImage = YES;
    style.lgf_TitleText = title;
    style.lgf_LeftBtnImageDark = lgf_Image(@"back-black");
    style.lgf_LeftBtnImageLight = lgf_Image(@"back");
    LGFNavigationBar *bar = [LGFNavigationBar lgf];
    [bar lgf_ShowLGFNavigationBar:SV style:style];
    return bar;
}

@end

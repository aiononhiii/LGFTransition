//
//  LGFTitles.h
//  LGFPageTitleView
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#ifndef LGFTitles_h
#define LGFTitles_h

#import "LGFPageTitleView.h"
#import "LGFPageTitleStyle.h"
#import "LGFTitleButton.h"
#import "LGFTitleLine.h"
#import "LGFMethod.h"
#import "UIView+LGF.h"
  
//********************** 帮助 ***************************
// 本控件是一个特殊的分页控件，实现了title和page的分离，方便一些喜欢自由搭配的产品，主要为一些复杂的页面布局而打造
// 由于和分页控件分离，具体用法请一定参考该项目 https://github.com/aiononhiii/LGFPageTitleView
// 本控件已经支持cocoapods, 导入方法在Podfile文件里加入：pod 'LGFPageTitle'
// 有问题可以在github上提给我哦～
//******************************************************

#undef LGFBundle
#define LGFBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"LGFPageTitle" ofType:@"bundle"]] ?: [NSBundle mainBundle]
#undef LGFRGB
#define LGFRGB(A,B,C,D) [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:D]
#undef LGFRandomColor
#define LGFRandomColor LGFRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)
#undef LGFAFTER
#define LGFAFTER(time,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{block});

#undef LGFLog
#ifdef DEBUG
#define LGFLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define LGFLog(FORMAT, ...) nil
#endif

#undef lgf_Weak
#ifndef lgf_Weak
#if DEBUG
#if __has_feature(objc_arc)
#define lgf_Weak(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define lgf_Weak(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define lgf_Weak(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define lgf_Weak(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
#undef lgf_Strong
#ifndef lgf_Strong
#if DEBUG
#if __has_feature(objc_arc)
#define lgf_Strong(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define lgf_Strong(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define lgf_Strong(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define lgf_Strong(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* LGFTitles_h */

//
//  LGFTransition.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#ifndef LGFTransition_h
#define LGFTransition_h

// SDWebImage
#undef lgf_SDImage
#define lgf_SDImage(imageView, imageUrl) [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
#undef lgf_SDAnimatedImage
#define lgf_SDAnimatedImage(imageView, imageData) [imageView setAnimatedImage:[FLAnimatedImage animatedImageWithGIFData:imageData]];

// 屏幕
#undef lgf_MainScreen
#define lgf_MainScreen [UIScreen mainScreen].bounds

// 通知中心
#undef lgf_NCenter
#define lgf_NCenter [NSNotificationCenter defaultCenter]

// 设置图片
#undef lgf_Image
#define lgf_Image(imageName) [UIImage imageNamed:imageName]

// IPhoneX
#undef lgf_IPhoneX
#define lgf_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// IPhoneXS
#undef lgf_IPhoneXS
#define lgf_IPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

// IPhoneXR
#undef lgf_IPhoneXR
#define lgf_IPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

// IPhoneX 或 IPhoneXS 或 IPhoneXR
#undef lgf_IPhoneXSR
#define lgf_IPhoneXSR (lgf_IPhoneX || lgf_IPhoneXS || lgf_IPhoneXR)

// IPhoneX 导航栏高度
#undef IPhoneX_NAVIGATION_BAR_HEIGHT
#define IPhoneX_NAVIGATION_BAR_HEIGHT (lgf_IPhoneXSR ? 88 : 64)

// 屏幕尺寸
#undef lgf_ScreenWidth
#define lgf_ScreenWidth ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#undef lgf_ScreenHeight
#define lgf_ScreenHeight ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

// 判断 block 是否被引用
#undef lgf_HaveBlock
#define lgf_HaveBlock(block, ...) if (block) { block(__VA_ARGS__); };

// 资源文件 Bundle
#undef lgf_Bundle
#define lgf_Bundle(bundleName)\
[NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"]] ?: [NSBundle mainBundle]

// 获取对应名字 storyboard
#undef lgf_GetSBWithName
#define lgf_GetSBWithName(storyboardStr, bundleStr)\
[UIStoryboard storyboardWithName:(storyboardStr) bundle:lgf_Bundle(bundleStr)]

// storyboard
#undef lgf_GetSBVC
#define lgf_GetSBVC(className, storyboardStr, bundleStr)\
[lgf_GetSBWithName(storyboardStr, bundleStr) instantiateViewControllerWithIdentifier:(NSStringFromClass([className class]))]

// xib
#undef lgf_GetXibView
#define lgf_GetXibView(className, bundleStr) [lgf_Bundle(bundleStr) loadNibNamed:NSStringFromClass([className class]) owner:self options:nil].firstObject;

// 屏幕宽高
#undef lgf_ScreenWidth
#define lgf_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#undef lgf_ScreenHeight
#define lgf_ScreenHeight [[UIScreen mainScreen] bounds].size.height

// 单列
#undef lgf_AllocOnlyOnceForH
#define lgf_AllocOnlyOnceForH(methodName) + (instancetype)shared##methodName
#undef lgf_AllocOnlyOnceForM
#define lgf_AllocOnlyOnceForM(name,methodName) static name* _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype)shared##methodName{\
\
return [[name alloc] init];\
}\
- (instancetype)init{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super init];\
});\
return _instance;\
}\
\
- (instancetype)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
- (instancetype)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}

//---------------------- 获取 Storyboard VC 快捷设置 ----------------------
#undef lgf_SBViewControllerForH
#define lgf_SBViewControllerForH + (instancetype)lgf
#undef lgf_SBViewControllerForM
#define lgf_SBViewControllerForM(className, storyboardStr, bundleStr) \
+ (instancetype)lgf\
{\
return lgf_GetSBVC(className, storyboardStr, bundleStr);\
}

//---------------------- 获取 Xib View 快捷设置 ----------------------
#undef lgf_XibViewForH
#define lgf_XibViewForH + (instancetype)lgf
#undef lgf_XibViewForM
#define lgf_XibViewForM(className, bundleStr) \
+ (instancetype)lgf\
{\
return lgf_GetXibView(className, bundleStr);\
}

//---------------------- 初始化 CollectionViewCell ----------------------
#undef lgf_CVGetCell
#define lgf_CVGetCell(collectionView, cellClass, indexPath)\
[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([cellClass class]) forIndexPath:indexPath]

// block 防止强引用
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

#endif /* LGFTransition_h */

##Show效果展示
![](https://upload-images.jianshu.io/upload_images/2857609-27c8f312e5d524e4.gif?imageMogr2/auto-orient/strip)
##Modal 效果展示
![](https://upload-images.jianshu.io/upload_images/2857609-0cb5bbc5ba881943.gif?imageMogr2/auto-orient/strip)

##制作目的
* 想要自定义系统转场动画速度
* 放弃不顺畅的 NavigationBar 隐藏消失
* 干脆直接干掉每个页面的 NavigationBar，在使用 UINavigationController 管理的同时，每个页面的 NavigationBar 都使用自定义的 UIView, 这样既定制程度高又可以在不需要 NavigationBar 的页面无缝对接，包括一些之前 NavigationBar 动画也可以更轻松的利用自定义的 UIView 的适配动画来更灵活的实现

##实现功能
* 可以设置一个自己认为舒服的速度进行转场动画（该动画模仿系统转场动画效果，如果需要其他转场动画可以替换我的 LGFTransition 类，或者修改 LGFTransition 类的代码）
* 这个动画速度同时也舒服的作用到边缘手势拖动 POP 返回上

##使用方式
* pod 'LGFTransition' 或者  [LGFTransition](https://github.com/aiononhiii/LGFTransition)

* 接着在 AppDelegate 中导入头文件 UINavigationController+LGFAnimatedTransition.h
```objc
#import "UINavigationController+LGFAnimatedTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure whether to use a custom transition animation here
    [UINavigationController lgf_AnimatedTransitionIsUse:YES];
//    [UINavigationController lgf_AnimatedTransitionIsUse:YES showDuration: 1.0 modalDuration:1.0];
    return YES;
}
```
* 在 didFinishLaunchingWithOptions 方法中调用 UINavigationController 由分类添加的新方法 lgf_AnimatedTransitionIsUse
* 传 NO 或不掉用该方法 使用系统效果， 调用该方法并传 YES 启用本效果
* showDuration Show动画想要执行的时间，默认 0.5 秒
* modalDuration Modal动画想要执行的时间，默认 0.5 秒

##Demo 里还添加了一个可以让普通按钮变成pop返回按钮的 UIButton 父类
* 自定义 NavigationBar 上的 UIButton 直接继承 LGFNavigationBackButton 就可以有pop返回的功能了


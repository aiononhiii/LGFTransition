# 制作目的
* 想要自定义系统转场动画速度
* 放弃不顺畅的 NavigationBar 隐藏消失
* 干脆直接干掉每个页面的 NavigationBar，在使用 UINavigationController 管理的同时，每个页面的 NavigationBar 都使用自定义的 UIView, 这样既定制程度高又可以在不需要 NavigationBar 的页面无缝对接，包括一些之前 NavigationBar 动画也可以更轻松的利用自定义的 UIView 的适配动画来更灵活的实现

# 实现功能
* 可以设置一个自己认为舒服的速度进行转场动画（该动画模仿系统转场动画效果，如果需要其他转场动画可以替换我的 LGFTransition 类，或者修改 LGFTransition 类的代码）
* 这个动画速度同时也舒服的作用到边缘手势拖动 POP 返回上

# 使用方式
* pod 'LGFAnimatedNavigation' 或者  [LGFAnimatedNavigation](https://github.com/aiononhiii/LGFAnimatedNavigation)

* 接着在 AppDelegate 中导入头文件 UINavigationController+LGFAnimatedTransition.h
```objc
#import "UINavigationController+LGFAnimatedTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 在这里配置是否使用自定义转场动画
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

# 添加了一个自定义 NavigationBar 和 一个自定义TabBar 具体使用方法参考 Demo
* 其中自定义TabBar 由于一些特殊需求需要出现子控制器的毛玻璃效果（类似淘宝的tabbar），同时要修改毛玻璃效果可以尝试修改 lgf_VisualView 这个 view 的背景色透明度，因此子控制器我做了全屏处理，所以子控制器上 scrollview 需要底部预留 49 的 bottom
* 最好在我的自定义 NavigationBar 上再封装一小层，在封装时为它添加 tag 值，用于部分全屏菊花加载页面忽视 NavigationBar，这样即便是数据加载不出来也可以做一些返回等基本操作，这样能让添加的代码更简洁易用（参考 Demo）

# 全局搜索 Demo 里有一个 333333
* 如果内嵌子控制器上有 scrollview 且为横向滚动 那么请赋值 tag 为 333333，以解决边缘返回手势与 scrollview Pan 手势冲突的问题

# 如果想要使用本 Demo 外的自定义跳转
* 请在 VC 初始化的时候给VC的 lgf_OtherShowDelegate/lgf_OtherModalDelegate 赋值（你自己定义的跳转代理）

# Show 效果展示
![Show 效果展示](https://upload-images.jianshu.io/upload_images/2857609-302c44ba835cc67b.gif?imageMogr2/auto-orient/strip)
# Modal 效果展示
![Modal 效果展示](https://upload-images.jianshu.io/upload_images/2857609-96d9ab5b83d3576d.gif?imageMogr2/auto-orient/strip)

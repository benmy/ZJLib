//
//  Macros.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

//-------------------获取设备大小-------------------------

// App Frame Height&Width
#define App_Frame_Height                            [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width                             [[UIScreen mainScreen] applicationFrame].size.width

//获取View的属性
#define Frame2Bounds(frame)                         CGRectMake(0, 0, (frame).size.width, (frame).size.height)
#define GetViewWidth(view)                          view.frame.size.width
#define GetViewHeight(view)                         view.frame.size.height
#define GetViewX(view)                              view.frame.origin.x
#define GetViewY(view)                              view.frame.origin.y

// MainScreen Height&Width
#define Main_Screen_Height                          [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width                           [[UIScreen mainScreen] bounds].size.width
#define Main_Screen_Scale                           [UIScreen mainScreen].scale

// MainScreen bounds
#define Main_Screen_Bounds                          [[UIScreen mainScreen] bounds]

//导航栏高度
#define TopBarHeight 64.5
#define NavigationBar_Height 44

//-------------------获取设备大小-------------------------




//----------------------系统----------------------------

// 当前版本
#define IOS_VERSION                                 ([[[UIDevice currentDevice] systemVersion] floatValue])
#define CurrentSystemVersion                        ([[UIDevice currentDevice] systemVersion])

//获取当前语言
#define CurrentLanguage                             ([[NSLocale preferredLanguages] objectAtIndex:0])

//App版本号
#define appMPVersion                                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//AppDelegate对象
#define AppDelegateInstance                         [[UIApplication sharedApplication] delegate]

#define PATH_OF_APP_HOME                            NSHomeDirectory()
#define PATH_OF_TEMP                                NSTemporaryDirectory()
#define PATH_OF_DOCUMENT                            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//----------------------系统----------------------------





//----------------------图片----------------------------

//获取图片资源
//读取本地图片
#define LoadImage(file, ext)                        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A)                                    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

#define ImageNamed(imageName)                       [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//----------------------图片----------------------------




//----------------------其他----------------------------

// 是否空对象
#define IS_NULL_CLASS(OBJECT)                       [OBJECT isKindOfClass:[NSNull class]]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...)                             NSLocalizedString(x, nil)

//读取文件的文本内容,默认编码为UTF-8
#define FileString(name,ext)                        [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:(ext)] encoding:NSUTF8StringEncoding error:nil]
#define FileDictionary(name,ext)                    [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]]
#define FileArray(name,ext)                         [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]]

//在Main线程上运行
#define DISPATCH_MAIN(mainQueueBlock)               dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//主线程上Demo
//DISPATCH_ON_MAIN_THREAD(^{
//更新UI
//})

//在Global Queue上运行
#define DISPATCH_HIGH(globalQueueBlocl)             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlocl);
#define DISPATCH_DEFAULT(globalQueueBlocl)          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
#define DISPATCH_LOW(globalQueueBlocl)              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlocl);
#define DISPATCH_BACKGROUND(globalQueueBlocl)       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlocl);

//Global Queue
//DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
//异步耗时任务
//})

//由角度获取弧度 有弧度获取角度
#define DegreesToRadian(x)                          (M_PI * (x) / 180.0)
#define RadianToDegrees(radian)                     (radian*180.0)/(M_PI)
//----------------------其他----------------------------



//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

#if DEBUG
    #define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define NSLog(FORMAT, ...) nil
#endif

#ifdef DEBUG
    #define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
    #define ULog(...)
#endif

#define LogFrame(frame) NSLog(@"frame[X=%.1f, Y=%.1f, W=%.1f, H=%.1f]",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define LogPoint(point) NSLog(@"Point[X=%.1f, Y=%.1f]",point.x,point.y)
//-------------------打印日志-------------------------


#endif /* Macros_h */

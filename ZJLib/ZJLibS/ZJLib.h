//
//  ZJLib.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/17.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#ifndef ZJLib_h
#define ZJLib_h

//Contants
#import "ColorConstants.h"
#import "ServerConstants.h"

//Vendor
#import "ZJDeviceInfo.h"
#import "ARCMacros.h"
#import "Macros.h"

#import "CoreAnimationBasicEffect.h"

//Helper
#import "ZJAddressUtil.h"
#import "ZJUtil.h"
#import "ZJTelephone.h"
#import "ZJStorageKit.h"
#import "ZJNetworkKit.h"
#import "ZJVoiceRecordHelper.h"
#import "ZJVoicePlayerHelper.h"
#import "ZJLocationHelper.h"

//Category
#import "NSArray+Access.h"
#import "NSMutableArray+Access.h"

#import "NSBundle+AppIcon.h"

#import "NSData+APNSToken.h"
#import "NSData+Base64.h"
#import "NSData+Encrypt.h"
#import "NSData+Hash.h"
#import "NSData+SDDataCache.h"

#import "NSDate+Extensions.h"
#import "NSDate+TimeAgo.h"

#import "NSDictionary+Access.h"
#import "NSDictionary+JSON.h"
#import "NSDictionary+URL.h"

#import "NSIndexPath+Offset.h"

#import "NSNotificationCenter+MainThread.h"

#import "NSNumber+Round.h"

#import "NSString+Base64.h"
#import "NSString+Contains.h"
#import "NSString+Encrypt.h"
#import "NSString+Extends.h"
#import "NSString+Hash.h"
#import "NSString+Matcher.h"
#import "NSString+MIME.h"
#import "NSString+Regex.h"
#import "NSString+Size.h"
#import "NSString+Trims.h"
#import "NSString+UUID.h"

#import "NSUserDefaults+Access.h"

#import "UIApplication+Permissions.h"

#import "UIDevice+Extends.h"

#import "NSTimer+Addition.h"
#import "NSTimer+Blocks.h"

#import "NSURL+Param.h"
#import "NSURL+QueryDictionary.h"

#import "NSHTTPCookieStorage+FreezeDry.h"

#import "NSFileManager+Paths.h"

#import "NSRunLoop+PerformBlock.h"

#import "NSObject+AddProperty.h"
#import "NSObject+AppInfo.h"
#import "NSObject+AssociatedObject.h"
#import "NSObject+AutoCoding.h"
#import "NSObject+Blocks.h"
#import "NSObject+EasyCopy.h"
#import "NSObject+GCD.h"
#import "NSObject+KVOBlocks.h"
#import "NSObject+MKBlockTimer.h"
#import "NSObject+Reflection.h"
#import "NSObject+Runtime.h"

#import "CAMediaTimingFunction+AdditionalEquations.h"

#import "UIView+Animation.h"
#import "UIView+BlockGesture.h"
#import "UIView+Constraints.h"
#import "UIView+CustomBorder.h"
#import "UIView+Debug.h"
#import "UIView+draggable.h"
#import "UIView+FDCollapsibleConstraints.h"
#import "UIView+Find.h"
#import "UIView+Frame.h"
#import "UIView+Genie.h"
#import "UIView+GestureCallback.h"
#import "UIView+Nib.h"
#import "UIView+Recursion.h"
#import "UIView+RecursiveDescription.h"
#import "UIView+Screenshot.h"
#import "UIView+Shake.h"
#import "UIView+Toast.h"
#import "UIView+ViewController.h"
#import "UIView+Visuals.h"

#import "UIBezierPath+BasicShapes.h"
#import "UIBezierPath+Length.h"
#import "UIBezierPath+LxThroughPointsBezier.h"
#import "UIBezierPath+SVG.h"
#import "UIBezierPath+Symbol.h"

#import "UIButton+UIKit.h"
#import "UIButton+Block.h"
#import "UIButton+BackgroundColor.h"
#import "UIButton+countDown.h"
#import "UIButton+Indicator.h"
#import "UIButton+MiddleAligning.h"
#import "UIButton+TouchAreaInsets.h"

#import "UIColor+Gradient.h"
#import "UIColor+HEX.h"
#import "UIColor+Modify.h"
#import "UIColor+Random.h"
#import "UIColor+Web.h"

#import "UIImage+Alpha.h"
#import "UIImage+animatedGIF.h"
#import "UIImage+BetterFace.h"
#import "UIImage+Blur.h"
#import "UIImage+Capture.h"
#import "UIImage+Color.h"
#import "UIImage+FileName.h"
#import "UIImage+FX.h"
#import "UIImage+GIF.h"
#import "UIImage+Merge.h"
#import "UIImage+Orientation.h"
#import "UIImage+PDF.h"
#import "UIImage+RemoteSize.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+SuperCompress.h"
#import "UIImage+Vector.h"

#import "UIImageView+Addition.h"
#import "UIImageView+BetterFace.h"
#import "UIImageView+FaceAwareFill.h"
#import "UIImageView+GeometryConversion.h"
#import "UIImageView+Letters.h"
#import "UIImageView+Reflect.h"

#import "UILabel+AutomaticWriting.h"
#import "UILabel+AutoSize.h"
#import "UILabel+SuggestSize.h"

#import "UINavigationBar+Awesome.h"
#import "UINavigationBar+CustomHeight.h"

#import "UINavigationController+BATransitions.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UINavigationController+JZExtension.h"
#import "UINavigationController+StackManager.h"

#import "UINavigationItem+Loading.h"
#import "UINavigationItem+Lock.h"
#import "UINavigationItem+Margin.h"

#import "UIScrollView+Addition.h"
#import "UIScrollView+APParallaxHeader.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIScrollView+Pages.h"
#import "UIScrollView+Extends.h"

#import "UITableView+iOS7Style.h"
#import "UITableView+FDIndexPathHeightCache.h"
#import "UITableView+FDKeyedHeightCache.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"

#import "UITableViewCell+Extends.h"

#import "UITextField+Blocks.h"
#import "UITextField+History.h"
#import "UITextField+Select.h"
#import "UITextField+Shake.h"

#import "UITextView+PinchZoom.h"
#import "UITextView+PlaceHolder.h"
#import "UITextView+Select.h"

#import "UIViewController+Extends.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIViewController+BackButtonItemTitle.h"
#import "UIViewController+BackButtonTouched.h"
#import "UIViewController+BlockSegue.h"
#import "UIViewController+DDPopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIViewController+RecursiveDescription.h"
#import "UIViewController+ScrollingStatusBar.h"
#import "UIViewController+TopBarMessage.h"
#import "UIViewController+Visible.h"

#import "UIWebView+Alert.h"
#import "UIWebView+Blocks.h"
#import "UIWebView+Canvas.h"
#import "UIWebView+JS.h"
#import "UIWebView+Load.h"
#import "UIWebView+MetaParser.h"
#import "UIWebView+Style.h"
#import "UIWebVIew+SwipeGesture.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "WebView+Debug.h"

#import "UIWindow+Hierarchy.h"

#endif /* ZJLib_h */

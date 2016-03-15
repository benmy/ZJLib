//
//  ZJLocationHelper.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/11.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^DidGetGeolocationsCompledBlock)(NSArray *placemarks);

@interface ZJLocationHelper : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) DidGetGeolocationsCompledBlock didGetGeolocationsCompledBlock;

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled;

@end

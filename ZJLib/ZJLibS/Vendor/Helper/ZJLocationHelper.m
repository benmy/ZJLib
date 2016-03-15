//
//  ZJLocationHelper.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/11.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJLocationHelper.h"

@implementation ZJLocationHelper

- (void)setup {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0;
    if (![CLLocationManager locationServicesEnabled]) {
        //NSLog(@"定位服务当前可能尚未打开，请设置打开！");
    }
    [_locationManager requestWhenInUseAuthorization];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.didGetGeolocationsCompledBlock = nil;
}

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled {
    self.didGetGeolocationsCompledBlock = compled;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         if (self.didGetGeolocationsCompledBlock) {
             self.didGetGeolocationsCompledBlock(placemarks);
         }
     }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
}

@end

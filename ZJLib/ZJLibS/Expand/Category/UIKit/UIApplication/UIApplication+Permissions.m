//
//  UIApplication+Permissions.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/17.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "UIApplication+Permissions.h"
#import <objc/runtime.h>

//Import required frameworks
@import AddressBook;
@import Contacts;
@import AssetsLibrary;
@import Photos;
@import AVFoundation;
@import CoreBluetooth;
@import CoreLocation;
@import CoreMotion;
@import EventKit;

typedef void (^LocationSuccessCallback)();
typedef void (^LocationFailureCallback)();

static char PermissionsLocationManagerPropertyKey;
static char PermissionsLocationBlockSuccessPropertyKey;
static char PermissionsLocationBlockFailurePropertyKey;

@interface UIApplication () <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *permissionsLocationManager;
@property (nonatomic, copy) LocationSuccessCallback locationSuccessCallbackProperty;
@property (nonatomic, copy) LocationFailureCallback locationFailureCallbackProperty;

@end

@implementation UIApplication(Permissions)

#pragma mark - Check permissions
- (kPermissionAccess)hasAccessToBluetoothLE {
    switch ([[[CBCentralManager alloc] init] state]) {
        case CBCentralManagerStateUnsupported:
            return kPermissionAccessUnsupported;
            break;
            
        case CBCentralManagerStateUnauthorized:
            return kPermissionAccessDenied;
            break;
            
        default:
            return kPermissionAccessGranted;
            break;
    }
}

- (kPermissionAccess)hasAccessToCalendar {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
}

- (kPermissionAccess)hasAccessToContacts {
#ifdef __IPHONE_9_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)  {
        switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
            case CNAuthorizationStatusAuthorized:
                return kPermissionAccessGranted;
                break;
                
            case CNAuthorizationStatusDenied:
                return kPermissionAccessDenied;
                break;
                
            case CNAuthorizationStatusNotDetermined:
                return kPermissionAccessRestricted;
                break;
                
            default:
                return kPermissionAccessUnknown;
                break;
        }
    }else{
        switch (ABAddressBookGetAuthorizationStatus()) {
            case kABAuthorizationStatusAuthorized:
                return kPermissionAccessGranted;
                break;
                
            case kABAuthorizationStatusDenied:
                return kPermissionAccessDenied;
                break;
                
            case kABAuthorizationStatusRestricted:
                return kPermissionAccessRestricted;
                break;
                
            default:
                return kPermissionAccessUnknown;
                break;
        }
    }
#else
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case kABAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case kABAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
#endif
}

- (kPermissionAccess)hasAccessToLocation {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return kPermissionAccessGranted;
            break;
            
        case kCLAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case kCLAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
}

- (kPermissionAccess)hasAccessToPhotos {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case PHAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case PHAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
#else
    switch ([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case ALAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case ALAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
#endif
}

- (kPermissionAccess)hasAccessToReminders {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
}

#pragma mark - Request permissions
- (void)requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

- (void)requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
#ifdef __IPHONE_9_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CNContactStore* contactStore = [[CNContactStore alloc]init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    accessGranted();
                } else {
                    accessDenied();
                }
            });
        }];
    }else{
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if(addressBook) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        accessGranted();
                    } else {
                        accessDenied();
                    }
                });
            });
        }
    }
#else
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if(addressBook) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    accessGranted();
                } else {
                    accessDenied();
                }
            });
        });
    }
#endif
}

- (void)requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

- (void)requestAccessToMotionWithSuccess:(void(^)())accessGranted {
    CMMotionActivityManager *motionManager = [[CMMotionActivityManager alloc] init];
    NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
    [motionManager startActivityUpdatesToQueue:motionQueue withHandler:^(CMMotionActivity *activity) {
        accessGranted();
        [motionManager stopActivityUpdates];
    }];
}

- (void)requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                accessGranted();
                break;
                
            default:
                accessDenied();
                break;
        }
    }];
#else
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        accessGranted();
    } failureBlock:^(NSError *error) {
        accessDenied();
    }];
#endif
}

- (void)requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

#pragma mark - Needs investigating
/*
 -(void)requestAccessToBluetoothLEWithSuccess:(void(^)())accessGranted {
 //REQUIRES DELEGATE - NEEDS RETHINKING
 }
 */

- (void)requestAccessToLocationWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    self.permissionsLocationManager = [[CLLocationManager alloc] init];
    self.permissionsLocationManager.delegate = self;
    
    self.locationSuccessCallbackProperty = accessGranted;
    self.locationFailureCallbackProperty = accessDenied;
    [self.permissionsLocationManager startUpdatingLocation];
}


#pragma mark - Location manager injection
- (CLLocationManager *)permissionsLocationManager {
    return objc_getAssociatedObject(self, &PermissionsLocationManagerPropertyKey);
}

- (void)setPermissionsLocationManager:(CLLocationManager *)manager {
    objc_setAssociatedObject(self, &PermissionsLocationManagerPropertyKey, manager, OBJC_ASSOCIATION_RETAIN);
}

- (LocationSuccessCallback)locationSuccessCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey);
}

- (void)setLocationSuccessCallbackProperty:(LocationSuccessCallback)locationCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey, locationCallbackProperty, OBJC_ASSOCIATION_COPY);
}

- (LocationFailureCallback)locationFailureCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey);
}

- (void)setLocationFailureCallbackProperty:(LocationFailureCallback)locationFailureCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey, locationFailureCallbackProperty, OBJC_ASSOCIATION_COPY);
}


#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationSuccessCallbackProperty();
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        self.locationFailureCallbackProperty();
    }
}
@end

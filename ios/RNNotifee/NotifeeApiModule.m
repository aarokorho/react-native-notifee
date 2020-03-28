/**
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "NotifeeApiModule.h"
#import <NotifeeCore/Notifee.h>

static NSString *kReactNativeNotifeeNotificationEvent = @"app.notifee.notification.event";

@implementation NotifeeApiModule {
  bool hasListeners;
}

#pragma mark - Module Setup

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (id)init {
  if (self = [super init]) {
    [Notifee initialize];
  }
  return self;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[kReactNativeNotifeeNotificationEvent];
}

- (NSDictionary *)constantsToExport {
  return @{
      @"NOTIFICATION_EVENT_KEY": kReactNativeNotifeeNotificationEvent,
  };
}

- (void)startObserving {
  hasListeners = YES;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifee_onNotificationEvent:) name:kNotifeeOnEventNotification object:nil];
}

- (void)stopObserving {
  hasListeners = NO;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifeeOnEventNotification object:nil];
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

# pragma mark - Events

- (void)notifee_onNotificationEvent:(NSNotification *)notification {
  if (hasListeners) {
    [self sendEventWithName:kReactNativeNotifeeNotificationEvent body:notification.userInfo];
  }
}

# pragma mark - React Native Methods

RCT_EXPORT_METHOD(cancelNotification:
  (NSString *) notificationId
      resolve:
      (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] cancelNotification:notificationId withBlock:^(NSError *_Nullable error) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:nil];
  }];
}

RCT_EXPORT_METHOD(displayNotification:
  (NSDictionary *) notification
      resolve:
      (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] displayNotification:notification withBlock:^(NSError *_Nullable error) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:nil];
  }];
}

RCT_EXPORT_METHOD(requestPermission:
  (NSDictionary *) permissions
      resolve:
      (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] requestPermission:permissions withBlock:^(NSError *_Nullable error, NSDictionary *settings) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:settings];
  }];
}

RCT_EXPORT_METHOD(getNotificationSettings:
  (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] getNotificationSettings:^(NSError *_Nullable error, NSDictionary *settings) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:settings];
  }];
}

RCT_EXPORT_METHOD(getNotificationCategories:
  (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] getNotificationCategoriesWithBlock:^(NSError *_Nullable error, NSArray<NSDictionary *> *categories) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:categories];
  }];
}

RCT_EXPORT_METHOD(setNotificationCategories:
  (NSArray<NSDictionary *> *) categories
      resolve:
      (RCTPromiseResolveBlock) resolve
      reject:
      (RCTPromiseRejectBlock) reject
) {
  [[Notifee instance] setNotificationCategories:categories withBlock:^(NSError *_Nullable error) {
    [self resolve:resolve orReject:reject promiseWithError:error orResult:nil];
  }];
}

# pragma mark - Internals

- (void)resolve:(RCTPromiseResolveBlock)resolve orReject:(RCTPromiseRejectBlock)reject promiseWithError:(NSError *_Nullable)error orResult:(id _Nullable)result {
  if (error != nil) {
    // TODO codes & messages
    reject(@"todo", @"todo", error);
  } else {
    resolve(result);
  }
}


@end

//
//  Codec.m
//  ErmisStreamNative
//
//  Created by Giáp Phan Văn on 4/10/25.
//

#import <Foundation/Foundation.h>
#import "Fmp4ModuleBridge.h"
#import "fmp4_player-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@implementation Fmp4ModuleBridge {
  NativeFmp4PlayerLib *nativeFmp4Module;
}
RCT_EXPORT_MODULE(NativeFmp4Player)

- (instancetype)init {
  if (self = [super init]) {
    nativeFmp4Module = [[NativeFmp4PlayerLib alloc] init];  // Initialize in init method
  }
  return self;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeFmp4PlayerSpecJSI>(params);
}


- (void)startStreaming { 
  if (@available(iOS 16.0, *)) {
    [nativeFmp4Module startStreaming];
  } else {
    // Fallback on earlier versions
  }
}

- (void)stopStreaming { 
  [nativeFmp4Module stopStreaming];
}

@end

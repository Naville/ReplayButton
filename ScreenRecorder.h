//
//  ScreenRecorder.h
//  ReplayKit
//
//  Created by Zhang Naville on 12/11/2015.
//  Copyright © 2015 Naville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIButton.h>
#import <dlfcn.h>
#import <objc/runtime.h>
@protocol RPPreviewViewControllerDelegate;
@interface ScreenRecorder:UIButton <RPPreviewViewControllerDelegate>
@property (strong,readwrite,nonatomic,nonnull) id _screenRecorder;
@property (strong,readwrite,nonatomic,nonnull) UIViewController* _viewController;
+(ScreenRecorder*)screenRecorder:(UIViewController*)VC;
-(BOOL)startRecording;
-(BOOL)endRecording;
@end

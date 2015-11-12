//
//  ScreenRecorder.m
//  ReplayKit
//
//  Created by Zhang Naville on 12/11/2015.
//  Copyright © 2015 Naville. All rights reserved.
//

#import "ScreenRecorder.h"
@class RPScreenRecorder;
@interface RPScreenRecorder : NSObject
+ (RPScreenRecorder *)sharedRecorder;
@property (nonatomic, weak, nullable) id delegate;
- (void)startRecordingWithMicrophoneEnabled:(BOOL)microphoneEnabled handler:(nullable void(^)(NSError * __nullable error))handler;
- (void)stopRecordingWithHandler:(nullable void(^)(id __nullable previewViewController, NSError * __nullable error))handler;

@end
@protocol RPScreenRecorderDelegate <NSObject>
@end
@protocol RPPreviewViewControllerDelegate;

@interface RPPreviewViewController : UIViewController
@property (nonatomic, weak, nullable) id<RPPreviewViewControllerDelegate>previewControllerDelegate;
@end

@protocol RPPreviewViewControllerDelegate <NSObject>
@optional
/* @abstract Called when the view controller is finished. */
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController;

/* @abstract Called when the view controller is finished and returns a set of activity types that the user has completed on the recording. The built in activity types are listed in UIActivity.h. */
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes;
@end


@implementation ScreenRecorder
+(instancetype)screenRecorder:(UIViewController*)VC{
    ScreenRecorder* returnValue=[self buttonWithType:UIButtonTypeSystem];
    returnValue._viewController=VC;
    return returnValue;
}
+ (id)buttonWithType:(UIButtonType)buttonType{
    ScreenRecorder* returnButton=[super buttonWithType:buttonType];
    void* RPHandle=dlopen("/System/Library/Frameworks/ReplayKit.framework/ReplayKit",RTLD_NOW);
    if(RPHandle==NULL){
        NSLog(@"ReplayKit Unsupported");
        return nil;
    }
    else{
        NSLog(@"ReplayKit Loaded");
        Class RPScreenRecorder=objc_getClass("RPScreenRecorder");
        returnButton._screenRecorder=[RPScreenRecorder sharedRecorder];
   
}

    CGRect frame = CGRectMake(90, 200, 200, 60);
    [returnButton setTitle:@"Start to Record" forState:UIControlStateNormal];
    returnButton.frame=frame;
    returnButton.backgroundColor = [UIColor clearColor];
    [returnButton addTarget:returnButton action:@selector(startRecording) forControlEvents:UIControlEventTouchDown];
    return returnButton;
}
-(BOOL)startRecording{
   __block NSError* commonError;
    [self._screenRecorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        commonError=error;
    [self setTitle:@"Click To Stop" forState:UIControlStateNormal];
    [self removeTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(endRecording) forControlEvents:UIControlEventTouchDown];
        
    }];
    if(commonError==nil){
        return true;
    }
    else{
        return false;
    }
    
}
-(BOOL)endRecording{
    __block NSError* commonError;
    
    [__screenRecorder stopRecordingWithHandler:^(RPPreviewViewController* previewViewController, NSError * _Nullable error) {
         commonError=error;
        NSLog(@"Stopping");
        if(!error && previewViewController) {
            [self setTitle:@"Click To Record" forState:UIControlStateNormal];
            [self removeTarget:self action:@selector(endRecording) forControlEvents:UIControlEventTouchDown];
            [self addTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchDown];
            previewViewController.previewControllerDelegate =self;
            [[UIApplication sharedApplication] delegate];
            [self._viewController presentViewController:previewViewController animated:YES completion:nil];
        }
    }];
    if(commonError==nil){
        return true;
    }
    else{
        return false;
    }
 
    
}
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

/* @abstract Called when the view controller is finished and returns a set of activity types that the user has completed on the recording. The built in activity types are listed in UIActivity.h. */
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    //handle user's action (if activityTypes is empty, then user canceled editing)
}


@end

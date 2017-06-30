//
//  ViewController.h
//  ProcessGPUCamera
//
//  Created by arplanet on 2017/6/30.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
@end


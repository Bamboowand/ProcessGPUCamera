//
//  ViewController.m
//  ProcessGPUCamera
//
//  Created by arplanet on 2017/6/30.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    AVCaptureSession* _session;
    NSString* _sessionPreset;
    
    EAGLContext *_context;
    
    CGFloat _screenWidth;
    CGFloat _screenHeight;
    
    unsigned int _meshFactor;
}
- (void)setupAVCapture;
- (void)setupGL;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if(!_context){
        NSLog(@"Failed to create context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    self.preferredFramesPerSecond = 60;
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    view.contentScaleFactor = [UIScreen mainScreen].scale;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _meshFactor = 8;
        _sessionPreset = AVCaptureSessionPreset1280x720;
    }else{
        _meshFactor = 4;
        _sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    [self setupAVCapture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Set OpenGL
-(void)setupGL{
    [EAGLContext setCurrentContext:_context];
    
}

#pragma mark- Object init
-(void)setupAVCapture{
    //-- Setup Capture Session.
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    
    //-- Set preset session size.
    [_session setSessionPreset:_sessionPreset];
    
    //-- Create a Video device and input from that device. Add input to the capture session.
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if(videoDevice == nil){
        assert(0);
    }
    
    //-- Add the device to the session.
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: videoDevice error:&error];
    
    [_session addInput: input];
    
    //-- Create the output for the capture session.
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES]; //Probably went to set this to No when recording.
    
    //-- Set to YUV420
    [dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
                                                             forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    //Set dispatch to be on main thread so OpenGL can do thing with data.
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    [_session addOutput:dataOutput];
    [_session commitConfiguration];
    
    [_session startRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVReturn err;
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
 #pragma unused(err)
 #pragma unused(width)
 #pragma unused(height)
    
}

#pragma mark- GLKView and GLKViewController delegate methods
- (void)update{
    
}

- (void)glkview:(GLKView *)view drawInRect:(CGRect*)rect{
    
}

@end

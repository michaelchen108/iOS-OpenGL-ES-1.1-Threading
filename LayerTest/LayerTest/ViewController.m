//
//  ViewController.m
//  LayerTest
//
//  Created by Michael Chen on 6/6/16.
//  Copyright © 2016 michael. All rights reserved.
//

// Import QuartzCore.h at the top of the file
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import "ViewController.h"
#import "PyramidLayer.h"
#import "CubeLayer.h"

@interface ViewController ()

@end

@implementation ViewController {
    PyramidLayer* _sublayer;
    CubeLayer* _cubeSublayer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.layer.backgroundColor = [UIColor orangeColor].CGColor;
    self.view.layer.cornerRadius = 20.0;
    self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
    
    //setup the layers and place them into the current layer
    [self setupCubeLayer];
    [self setupLayer];
    [self setupDisplayLink];
    
    //animate the layers to move on the screen
    [self moveLayer:_sublayer toPoint:CGPointMake(self.view.frame.size.width - _sublayer.position.x + 30, _sublayer.position.y)];
    [self moveLayer:_cubeSublayer toPoint:CGPointMake(self.view.frame.size.width - _cubeSublayer.position.x + 30, _cubeSublayer.position.y)];
}

- (void)setupLayer {
    _sublayer = [PyramidLayer layer];
    _sublayer.contentsScale = [UIScreen mainScreen].nativeScale;
    _sublayer.backgroundColor = [UIColor blueColor].CGColor;
    _sublayer.shadowOffset = CGSizeMake(0, 3);
    _sublayer.shadowRadius = 5.0;
    _sublayer.shadowColor = [UIColor blackColor].CGColor;
    _sublayer.shadowOpacity = 0.8;
    _sublayer.frame = CGRectMake(30, 30, 150, 192);
    _sublayer.opaque = TRUE;
    _sublayer.bounds = CGRectMake(30, 30, 150, 192);
    
    [_sublayer setup];

    [self.view.layer addSublayer: _sublayer];
}

- (void) setupCubeLayer {
    _cubeSublayer = [CubeLayer layer];
    _cubeSublayer.contentsScale = [UIScreen mainScreen].nativeScale;
    _cubeSublayer.backgroundColor = [UIColor blueColor].CGColor;
    _cubeSublayer.shadowOffset = CGSizeMake(0, 3);
    _cubeSublayer.shadowRadius = 5.0;
    _cubeSublayer.shadowColor = [UIColor blackColor].CGColor;
    _cubeSublayer.shadowOpacity = 0.8;
    _cubeSublayer.frame = CGRectMake(30, 250, 150, 192);
    _cubeSublayer.opaque = TRUE;
    _cubeSublayer.bounds = CGRectMake(30, 250, 150, 192);
    
    [_cubeSublayer setup];
    
    [self.view.layer addSublayer: _cubeSublayer];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void) render : (CADisplayLink *) displayLink {
    if ([_sublayer canRender]) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_sublayer render: displayLink];
        });
    }
    
    if ([_cubeSublayer canRender]) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_cubeSublayer render: displayLink];
        });
    }
}

- (void) moveLayer: (CAEAGLLayer *) layer toPoint: (CGPoint) point {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:point];
    layer.position = point;
    animation.duration = 4.0f;
    [layer addAnimation:animation forKey:@"position"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

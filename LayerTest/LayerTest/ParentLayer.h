//
//  ParentLayer.h
//  LayerTest
//
//  Created by Michael Chen on 6/16/16.
//  Copyright © 2016 michael. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

@interface ParentLayer : CAEAGLLayer {
    GLuint framebuffer;
    GLuint renderbuffer;
    GLuint offscreenframebuffer;
    GLuint offscreenrenderbuffer;
    GLuint offscreenrenderbuffer2;
//    GLuint currentRenderbuffer;
//    GLuint backupRenderbuffer;
    EAGLSharegroup *sharegroup;
    int32_t firstFull;
    int32_t secondFull;
    EAGLContext* context;
    EAGLContext* offscreenContext;
    float currentRotation;
    int32_t atomicBit;
}

- (void) render: (CADisplayLink *) displayLink;
- (void) setup;
- (BOOL) canRender;

@end

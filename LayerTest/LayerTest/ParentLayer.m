//
//  ParentLayer.m
//  LayerTest
//
//  Created by Michael Chen on 6/16/16.
//  Copyright © 2016 michael. All rights reserved.
//

#import "ParentLayer.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>
#import <libkern/OSAtomic.h>

@implementation ParentLayer : CAEAGLLayer

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES1;
    context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 1.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
    offscreenContext = [[EAGLContext alloc] initWithAPI:[context API] sharegroup: [context sharegroup]];
    
    if (!offscreenContext) {
        NSLog(@"Failed to initialize OpenGLES 1.0 off screen context");
        exit(1);
    }
}

- (void)setupFrameBuffer {
    [EAGLContext setCurrentContext:context];
    glGenFramebuffers(1, &framebuffer);
    
    [EAGLContext setCurrentContext:offscreenContext];
    glGenFramebuffers(1, &offscreenframebuffer);
}

- (void)setupRenderBuffer {
    [EAGLContext setCurrentContext: offscreenContext];
    glBindFramebuffer(GL_FRAMEBUFFER, offscreenframebuffer);
    glGenRenderbuffers(1, &offscreenrenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, offscreenrenderbuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, self.frame.size.width*self.contentsScale, self.frame.size.height*self.contentsScale);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, offscreenrenderbuffer);
    
    [EAGLContext setCurrentContext:context];
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
}

- (void) setup {
    [self setupContext];
    [self setupFrameBuffer];
    [self setupRenderBuffer];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  // Set color's clear-value to black
    glClearDepthf(1.0f);            // Set depth's clear-value to farthest
    glEnable(GL_DEPTH_TEST);   // Enables depth-buffer for hidden surface removal
    glDepthFunc(GL_LEQUAL);    // The type of depth testing to do
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);  // nice perspective view
    glShadeModel(GL_SMOOTH);   // Enable smooth shading of color
    glDisable(GL_DITHER);      // Disable dithering for better performance

    glViewport(0, 0, self.frame.size.width*self.contentsScale, self.frame.size.height*self.contentsScale);

    // Setup perspective projection, with aspect ratio matches viewport
    glMatrixMode(GL_PROJECTION); // Select projection matrix
    glLoadIdentity();                 // Reset projection matrix

    glMatrixMode(GL_MODELVIEW);  // Select model-view matrix
    glLoadIdentity();                 // Reset
}


- (void) render : (CADisplayLink*)displayLink {
    [self setAtomicBit];
    
    if (![EAGLContext setCurrentContext: offscreenContext]) {
        NSLog(@"Failed to set current OpenGL offscreen context");
        exit(1);
    }
    
    //code from rendering from offscreen framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, offscreenframebuffer);

    // MARIOK - These should not be needed...
    glBindRenderbuffer(GL_RENDERBUFFER, offscreenrenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, offscreenrenderbuffer);
    
    //setting up the framebuffer and drawing to it
    glViewport(0, 0, self.frame.size.width*self.contentsScale, self.frame.size.height*self.contentsScale);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();                 // Reset the model-view matrix
    glTranslatef(0.0f, 0.1f, 1.0f); // Translate Up and away from the screen
    glScalef(0.5f, 0.5f, 0.5f);      // Scale down
    glRotatef(currentRotation, 0.1f, 1.0f, -0.1f); // Rotate
    currentRotation += displayLink.duration * 90.0;
    
    [self draw];
    glFlush();
 
    //displaying the currentframebuffer to the screen
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayOnscreen];
    });

}

- (void) draw {
    //will be overridden
}

- (void) displayOnscreen {
    [EAGLContext setCurrentContext:context];
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, framebuffer);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, offscreenframebuffer);
    glResolveMultisampleFramebufferAPPLE();
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    //clear to show that we swapped
    [self clearAtomicBit];
}

- (BOOL) canRender {
    //Return the opposite since the bit starts at 0
    return !atomicBit;
}

- (void) setAtomicBit {
    OSAtomicTestAndSet(7, &atomicBit);
}

- (void) clearAtomicBit {
    OSAtomicTestAndClear(7, &atomicBit);
}

-(void)dealloc {
    glDeleteRenderbuffers(1, &renderbuffer);
    glDeleteBuffers(1, &framebuffer);
    glDeleteRenderbuffers(1, &offscreenrenderbuffer);
    glDeleteBuffers(1, &offscreenframebuffer);
}

@end

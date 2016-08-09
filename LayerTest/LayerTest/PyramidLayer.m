//
//  PyramidLayer.m
//  LayerTest
//
//  Created by Michael Chen on 6/16/16.
//  Copyright © 2016 michael. All rights reserved.
//

#import "PyramidLayer.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>

@implementation PyramidLayer

GLfloat vertices[] = { // 5 vertices of the mPyramid in (x,y,z)
    -1.0f, -1.0f, -1.0f,  // 0. left-bottom-back
    1.0f, -1.0f, -1.0f,  // 1. right-bottom-back
    1.0f, -1.0f,  1.0f,  // 2. right-bottom-front
    -1.0f, -1.0f,  1.0f,  // 3. left-bottom-front
    0.0f,  1.0f,  0.0f   // 4. top
};

GLfloat colors[] = {  // Colors of the 5 vertices in RGBA
    0.0f, 0.0f, 1.0f, 1.0f,  // 0. blue
    0.0f, 1.0f, 0.0f, 1.0f,  // 1. green
    0.0f, 0.0f, 1.0f, 1.0f,  // 2. blue
    0.0f, 1.0f, 0.0f, 1.0f,  // 3. green
    1.0f, 0.0f, 0.0f, 1.0f   // 4. red
};

GLbyte indices[] = { // Vertex indices of the 4 Triangles
    2, 4, 3,   // front face (CCW)
    1, 4, 2,   // right face
    0, 4, 1,   // back faceb
    4, 0, 3    // left face
};

- (void) draw {
    glFrontFace(GL_CCW);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    glDrawElements(GL_TRIANGLES, 12, GL_UNSIGNED_BYTE, indices);
}

@end

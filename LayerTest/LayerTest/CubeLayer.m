//
//  CubeLayer.m
//  LayerTest
//
//  Created by Michael Chen on 6/16/16.
//  Copyright © 2016 michael. All rights reserved.
//

#import "CubeLayer.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>

@implementation CubeLayer

GLfloat cubeColors[6][4] = {  // Colors of the 6 faces
    {1.0f, 0.5f, 0.0f, 1.0f},  // 0. orange
    {1.0f, 0.0f, 1.0f, 1.0f},  // 1. violet
    {0.0f, 1.0f, 0.0f, 1.0f},  // 2. green
    {0.0f, 0.0f, 1.0f, 1.0f},  // 3. blue
    {1.0f, 0.0f, 0.0f, 1.0f},  // 4. red
    {1.0f, 1.0f, 0.0f, 1.0f}   // 5. yellow
};

GLfloat cubeVertices[] = {  // Vertices of the 6 faces
    // FRONT
    -1.0f, -1.0f,  1.0f,  // 0. left-bottom-front
    1.0f, -1.0f,  1.0f,  // 1. right-bottom-front
    -1.0f,  1.0f,  1.0f,  // 2. left-top-front
    1.0f,  1.0f,  1.0f,  // 3. right-top-front
    // BACK
    1.0f, -1.0f, -1.0f,  // 6. right-bottom-back
    -1.0f, -1.0f, -1.0f,  // 4. left-bottom-back
    1.0f,  1.0f, -1.0f,  // 7. right-top-back
    -1.0f,  1.0f, -1.0f,  // 5. left-top-back
    // LEFT
    -1.0f, -1.0f, -1.0f,  // 4. left-bottom-back
    -1.0f, -1.0f,  1.0f,  // 0. left-bottom-front
    -1.0f,  1.0f, -1.0f,  // 5. left-top-back
    -1.0f,  1.0f,  1.0f,  // 2. left-top-front
    // RIGHT
    1.0f, -1.0f,  1.0f,  // 1. right-bottom-front
    1.0f, -1.0f, -1.0f,  // 6. right-bottom-back
    1.0f,  1.0f,  1.0f,  // 3. right-top-front
    1.0f,  1.0f, -1.0f,  // 7. right-top-back
    // TOP
    -1.0f,  1.0f,  1.0f,  // 2. left-top-front
    1.0f,  1.0f,  1.0f,  // 3. right-top-front
    -1.0f,  1.0f, -1.0f,  // 5. left-top-back
    1.0f,  1.0f, -1.0f,  // 7. right-top-back
    // BOTTOM
    -1.0f, -1.0f, -1.0f,  // 4. left-bottom-back
    1.0f, -1.0f, -1.0f,  // 6. right-bottom-back
    -1.0f, -1.0f,  1.0f,  // 0. left-bottom-front
    1.0f, -1.0f,  1.0f   // 1. right-bottom-front
};



- (void) draw {
    glFrontFace(GL_CCW);    // Front face in counter-clockwise orientation
    glEnable(GL_CULL_FACE); // Enable cull face
    glCullFace(GL_FRONT);    // Cull the back face (don't display)
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
    
    // Render all the faces
    for (int face = 0; face < 6; face++) {
        // Set the color for each of the faces
        glColor4f(cubeColors[face][0], cubeColors[face][1], cubeColors[face][2], cubeColors[face][3]);
        // Draw the primitive from the vertex-array directly
        glDrawArrays(GL_TRIANGLE_STRIP, face*4, 4);
    }
}

@end

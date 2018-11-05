//
//  shaders.metal
//  MetalClearScreen
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "XCShaderTypes.h"

typedef struct {
    float4 position [[position]];
    float4 color;
    
}RasterizerData;

vertex RasterizerData vertexShader(constant XCVertex *vertices[[buffer(XCVertexInputIndexVertices)]],uint vid[[vertex_id]]){
    
    RasterizerData outVertex;
    outVertex.position = vector_float4(vertices[vid].position,0.0,1.0);
    outVertex.color = vertices[vid].color;
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex[[stage_in]]){
    return inVertex.color;
}



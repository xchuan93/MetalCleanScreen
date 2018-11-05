//
//  XCShaderTypes.h
//  MetalClearScreen
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef XCShaderTypes_h
#define XCShaderTypes_h

#include<simd/simd.h>

//SIMD定义的数据类型在(.swift , .m)中可以直接使用，在着色器中(.metal)也可以直接使用,保证了类型和内存分布一致
typedef struct {
    vector_float2 position;
    vector_float4 color;
}XCVertex;

typedef enum XCVertexImputIndex {
    XCVertexInputIndexVertices = 0,
    XCVertexInputCount         = 1,
}XCVertexInputIndex;

#endif /* XCShaderTypes_h */

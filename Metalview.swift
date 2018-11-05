//
//  Metalview.swift
//  MetalClearScreen
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class Metalview: UIView {
    
    var device : MTLDevice!
    var piplineState: MTLRenderPipelineState!
    
    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override class var layerClass: AnyClass{
        return CAMetalLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commoninit()
    }
    
    func setupPipline() {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let piplineDescriptor = MTLRenderPipelineDescriptor()
        piplineDescriptor.vertexFunction = vertexFunction
        piplineDescriptor.fragmentFunction = fragmentFunction
        piplineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        piplineState = try! device.makeRenderPipelineState(descriptor: piplineDescriptor)
    }
    
    func commoninit(){
        device = MTLCreateSystemDefaultDevice()
        setupPipline()
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            print("获取显示资源失败 ")
            return
        }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandQueue: MTLCommandQueue = device.makeCommandQueue()!
        let commandbuffer: MTLCommandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandbuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        commandEncoder?.setRenderPipelineState(piplineState)
        //顶点着色器坐标
        let vertics = [XCVertex(position: [0.5,-0.5], color: [1,0,0,1]),
                       XCVertex(position: [-0.5,-0.5], color: [0,1,0,1]),
                       XCVertex(position: [0.0,0.5], color: [0,0,1,1])]
        
        commandEncoder?.setVertexBytes(vertics, length: MemoryLayout<XCVertex>.size * 3, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder?.endEncoding()
        commandbuffer.present(drawable)
        commandbuffer.commit()
        
    }
}

//
//  Drawpass.swift
//
//  Created by Christopher Helf on 13.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import MetalKit

class DrawPass {

    private var vertexBuffer:MTLBuffer! = nil
    private var indexBuffer: MTLBuffer! = nil
    private var vertexDesc: MTLVertexDescriptor! = nil
    private var renderPipelineState : MTLRenderPipelineState! = nil
    private var samplerState : MTLSamplerState! = nil
    private var vertexCount : Int = 0
    private var indicesCount : Int = 0
    var uniformBuffer : MTLBuffer! = nil
    
    init() {
        
        let device = MetalContext.sharedContext.device
        
        let vertexProgram = MetalHelpers.getFunction("vertexShaderSimple")!
        let fragmentProgram = MetalHelpers.getFunction("sphericalSample")
        let (data, indices) = SphereVertices.generate(1.0, rows: 60, columns: 60)
        
        vertexCount = data.count
        var dataSize = data.count * MemoryLayout.size(ofValue: data[0])
        vertexBuffer = device?.makeBuffer(bytes: data, length: dataSize, options: MTLResourceOptions.storageModeShared)
        dataSize = indices.count * MemoryLayout.size(ofValue: indices[0])
        indexBuffer = device?.makeBuffer(bytes: indices, length: dataSize, options: MTLResourceOptions.storageModeShared)
        indicesCount = indices.count
        
        uniformBuffer = device?.makeBuffer(length: 32*MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        
        let vert = MTLVertexAttributeDescriptor()
        vert.format = .float3
        vert.bufferIndex = 0
        vert.offset = 0
        
        let tex = MTLVertexAttributeDescriptor()
        tex.format = .float2
        tex.bufferIndex = 0
        tex.offset = 3 * MemoryLayout<Float>.size
        
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stride = 5 * MemoryLayout<Float>.size
        layout.stepFunction = MTLVertexStepFunction.perVertex
        
        vertexDesc = MTLVertexDescriptor()
        vertexDesc.layouts[0] = layout
        vertexDesc.attributes[0] = vert
        vertexDesc.attributes[1] = tex
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Fragment"
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineStateDescriptor.vertexDescriptor = vertexDesc
        
        renderPipelineState = MetalHelpers.getRenderPipeline(pipelineStateDescriptor, vertexDescriptor: vertexDesc)!
        samplerState = MetalHelpers.getBilinearSampler()
        
    }
    
    func createPass(_ commandBuffer: MTLCommandBuffer, texture: MTLTexture, descriptor: MTLRenderPassDescriptor) {
        
        let bufferPointer = uniformBuffer?.contents()
        memcpy(bufferPointer!, &Camera.sharedInstance.viewMatrix, MemoryLayout<Float>.size*16)
        memcpy(bufferPointer! + MemoryLayout<Float>.size*16, &Camera.sharedInstance.projectionMatrix, MemoryLayout<Float>.size*16)
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        let name:String = renderPipelineState.label!
        renderEncoder.pushDebugGroup(name)
        renderEncoder.label = name
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, at: 1)
        renderEncoder.setFragmentTexture(texture, at: 0)
        renderEncoder.setFragmentSamplerState(samplerState, at: 0)
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip, indexCount: indicesCount, indexType: .uint32, indexBuffer: indexBuffer, indexBufferOffset: 0)
                
        renderEncoder.popDebugGroup()
        renderEncoder.endEncoding()
        
        
    }
    
    
    
    
    
    
    
}

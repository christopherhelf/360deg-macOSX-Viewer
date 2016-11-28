//
//  MetalView.swift
//
//  Created by Christopher Helf on 12.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import MetalKit

class MetalView : MTKView {
    
    var pass : DrawPass!
    var texture : MTLTexture?
    
    init(frame: CGRect) {
        super.init(frame: frame, device: MetalContext.sharedContext.device)
        self.clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        self.framebufferOnly = false
        self.pass = DrawPass()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let texture = self.texture, let drawable = self.currentDrawable, let descriptor = self.currentRenderPassDescriptor else {
            return
        }
        
        self.render(tex: texture, drawable: drawable, descriptor: descriptor)
    }
    
    func render(tex: MTLTexture, drawable: CAMetalDrawable, descriptor: MTLRenderPassDescriptor) {
        
        autoreleasepool {
            let commandBuffer = MetalContext.sharedContext.queue.makeCommandBuffer()
            pass.createPass(commandBuffer, texture: tex, descriptor: descriptor)
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
        
    }
    
}

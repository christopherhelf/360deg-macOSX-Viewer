//
//  ViewController.swift
//
//  Created by Christopher Helf on 12.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var metal : MetalContext!
    var metalView : MetalView!
    var texture : MTLTexture!
    var displayLink: CVDisplayLink? = nil
    var camera = Camera.sharedInstance
    
    override func mouseDragged(with theEvent: NSEvent) {
        
        let dx = theEvent.deltaX
        let dy = theEvent.deltaY

        let dh = Float(dx / self.view.frame.size.width) * camera.fovRadians
        let dv = Float(dy / self.view.frame.size.height) * camera.fovRadians
        let dt : Float = 1.0
        
        camera.yaw += dh * dt
        camera.pitch += dv * dt
        
    }
    
    override func rightMouseDragged(with theEvent: NSEvent) {
        let dx = theEvent.deltaX
        camera.fovRadians += Float(dx)/1000
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        metal = MetalContext.sharedContext
        metalView = MetalView(frame: self.view.frame)
        metalView.clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        
        self.view.addSubview(metalView)
        
        texture = MetalHelpers.loadImageFromPath("/Users/christopher/ownCloud/masterhesis/metalproject/sph/sph/sphere3.jpg")!
        metalView.texture = texture
    }


}


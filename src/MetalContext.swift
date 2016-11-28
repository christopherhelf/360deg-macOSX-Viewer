//
//  MetalHelper.swift
//
//  Created by Christopher Helf on 12.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import Metal

class MetalContext {
    
    static let sharedContext = MetalContext()
    
    var device : MTLDevice!
    var queue : MTLCommandQueue!
    var library : MTLLibrary!
    var maxThreadsPerThreadgroup : MTLSize!
    
    init() {
        var devices = MTLCopyAllDevices()
        device = devices[0]
        maxThreadsPerThreadgroup = device.maxThreadsPerThreadgroup
        queue = device.makeCommandQueue()
        library = device.newDefaultLibrary()
    }
    
    
    
    
}

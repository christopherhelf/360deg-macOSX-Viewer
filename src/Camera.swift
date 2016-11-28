//
//  Camera.swift
//
//  Created by Christopher Helf on 13.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import MetalKit
import GLKit

class Camera {
    
    static let sharedInstance = Camera()
    
    var projectionMatrix = GLKMatrix4()
    var viewMatrix = GLKMatrix4()
    
    var fovRadians: Float = GLKMathDegreesToRadians(65.0)
        {
        didSet { self.updateProjectionMatrix() }
    }
    
    var aspect: Float = (320.0 / 480.0)
        {
        didSet { self.updateProjectionMatrix() }
    }
    
    var nearZ: Float = 0.1
        {
        didSet { self.updateProjectionMatrix() }
    }
    
    var farZ: Float = 100.0
        {
        didSet { self.updateProjectionMatrix() }
    }
    
    var yaw: Float = 0.0
        {
        didSet { self.updateViewMatrix() }
    }
    
    var pitch: Float = 0.0
        {
        didSet { self.updateViewMatrix() }
    }
    
    var projection: GLKMatrix4
        {
        get { return self.projectionMatrix }
    }
    
    var view: GLKMatrix4
        {
        get { return self.viewMatrix }
    }
    
    init(fovRadians: Float = GLKMathDegreesToRadians(85.0), aspect: Float = (320.0 / 480.0), nearZ: Float = 0.1, farZ: Float = 400)
    {
        self.fovRadians = fovRadians
        self.aspect = aspect
        self.nearZ = nearZ
        self.farZ = farZ
        self.updateProjectionMatrix()
        self.updateViewMatrix()
    }
    
    private func updateProjectionMatrix()
    {
        objc_sync_enter(self)
        self.projectionMatrix = GLKMatrix4MakePerspective(self.fovRadians, self.aspect, self.nearZ, self.farZ)
        objc_sync_exit(self)
        
    }
    
    private func updateViewMatrix()
    {
        objc_sync_enter(self)
        let cosPitch = cosf(self.pitch)
        let sinPitch = sinf(self.pitch)
        let cosYaw = cosf(self.yaw)
        let sinYaw = sinf(self.yaw)
        
        let xaxis = GLKVector3(v: (cosYaw, 0, -sinYaw))
        let yaxis = GLKVector3(v: (sinYaw * sinPitch, cosPitch, cosYaw * sinPitch))
        let zaxis = GLKVector3(v: (sinYaw * cosPitch, -sinPitch, cosPitch * cosYaw))
        
        self.viewMatrix = GLKMatrix4(m:
            (
                xaxis.x, yaxis.x, zaxis.x, 0,
                xaxis.y, yaxis.y, zaxis.y, 0,
                xaxis.z, yaxis.z, zaxis.z, 0,
                0, 0, 0, 1
        ))
        objc_sync_exit(self)
    }
    
}

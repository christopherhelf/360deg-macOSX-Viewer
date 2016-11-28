//
//  SphereVertices.swift
//
//  Created by Christopher Helf on 13.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import MetalKit

class SphereVertices {
    
    struct VertexData {
        var x: Float
        var y: Float
        var z: Float
        var tx: Float
        var ty: Float
    }
    
    class func generateTest(_ radius: Float) -> ([VertexData], [UInt32]){
        
        var indices = [UInt32]()
        indices.append(0)
        indices.append(1)
        indices.append(2)
        indices.append(3)
        indices.append(4)
        indices.append(5)
        
        var vertices = [VertexData]()
        vertices.append(VertexData(x: 0, y: 1, z: 0, tx: 0, ty: 0))
        vertices.append(VertexData(x: -1, y: -1, z: 0, tx: 0, ty: 0))
        vertices.append(VertexData(x: 1, y: -1, z: 0, tx: 0, ty: 0))
        
        vertices.append(VertexData(x: 0, y: 1, z: 0, tx: 0, ty: 0))
        vertices.append(VertexData(x: 1, y: 1, z: 0, tx: 0, ty: 0))
        vertices.append(VertexData(x: 1, y: -1, z: 0, tx: 0, ty: 0))
        
        return (vertices, indices)
        
    }
    
    class func generate(_ radius: Float, rows: Int = 20, columns: Int = 20) -> ([VertexData], [UInt32]){
        
        var vertices = [VertexData]()
        
        let deltaAlpha = Float(2.0 * M_PI) / Float(columns)
        let deltaBeta = Float(M_PI) / Float(rows)
        for row in 0...rows
        {
            let beta = Float(row) * deltaBeta
            let y = radius * cosf(beta)
            let tv = Float(row) / Float(rows)
            for col in 0...columns
            {
                let alpha = Float(col) * deltaAlpha
                let x = radius * sinf(beta) * cosf(alpha)
                let z = radius * sinf(beta) * sinf(alpha)
                let tu = Float(col) / Float(columns)
                
                let vertex = VertexData(x: x, y: y, z: z, tx: tu, ty: tv)
                vertices.append(vertex)
            }
        }
        
        var indices = [UInt32]()
        
        for row in 1...rows
        {
            let topRow = row - 1
            let topIndex = (columns + 1) * topRow
            let bottomIndex = topIndex + (columns + 1)
            for col in 0...columns
            {
                indices.append(UInt32(topIndex + col))
                indices.append(UInt32(bottomIndex + col))
            }
            
            indices.append(UInt32(topIndex))
            indices.append(UInt32(bottomIndex))
        }
        
        return (vertices, indices)
        
    }
    
    class func generateSphere(_ numSlices: Int, radius: Float) -> ([VertexData]){
        
        let numParallels = numSlices / 2;
        let angleStep = Float(2.0 * M_PI) / (Float(numSlices));
        
        var data = [VertexData]()
        
        for i in 0..<numParallels+1 {
            for j in 0..<numSlices+1 {
                
                let x = radius * sinf(angleStep * Float(i)) * sinf(angleStep * Float(j))
                let y = radius * cosf(angleStep * Float(i))
                let z = radius * sinf(angleStep * Float(i)) * cosf(angleStep * Float(j))
                
                let tx = Float(j) / Float(numSlices);
                let ty = 1.0 - (Float(i) / Float(numParallels));
                
                data.append(VertexData(x: x, y: y, z: z, tx: tx, ty: ty))
            }
        }
        
        return data
        
    }
    
    
    
    
}

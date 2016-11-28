//
//  Helpers.swift
//
//  Created by Christopher Helf on 18.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import MetalKit

class Helpers {
    
    struct Vertex {
        var x : Float
        var y : Float
        var z : Float
        var color : Float
    }
    
    struct TexCoord {
        var tx : Float
        var ty : Float
    }
    
    struct Triangle {
        var a: UInt32
        var b: UInt32
        var c: UInt32
    }
    
    struct VertexData {
        var x: Float
        var y: Float
        var z: Float
        var tx: Float
        var ty: Float
    }
    
    class func getVertexSize() -> Int {
        return MemoryLayout<Vertex>.size
    }
    
    class func getTriangleSize() -> Int {
        return MemoryLayout<Triangle>.size
    }
    
    class func createFloatBuffer(_ size: Int) -> MTLBuffer {
        return MetalContext.sharedContext.device.makeBuffer(length: size, options: MTLResourceOptions())
    }
    
    class func buildBuffer(_ radius: Float, rows: Int = 20, columns: Int = 20) -> (MTLBuffer, MTLBuffer, MTLBuffer){
        
        var vertices = [Vertex]()
        var texCoords = [TexCoord]()
        var triangles = [Triangle]()
        
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
                
                let vertex = Vertex(x: x, y: y, z: z, color: 0.0)
                vertices.append(vertex)
                texCoords.append(TexCoord(tx: tu, ty: tv))
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
        
        for v in 0..<indices.count-2 {
            if v & 1 != 0 {
                triangles.append(Triangle(a: indices[v], b: indices[v+1], c: indices[v+2]))
            } else {
                triangles.append(Triangle(a: indices[v], b: indices[v+2], c: indices[v+1]))
            }
            
        }
        
        let tBuf = MetalContext.sharedContext.device.makeBuffer(bytes: &triangles, length: triangles.count * MemoryLayout<Triangle>.size, options: MTLResourceOptions())
        let texCoordsBuf = MetalContext.sharedContext.device.makeBuffer(bytes: &texCoords, length: texCoords.count * MemoryLayout<TexCoord>.size, options: MTLResourceOptions())
        let vBuf = MetalContext.sharedContext.device.makeBuffer(bytes: &vertices, length: vertices.count * MemoryLayout<Vertex>.size, options: MTLResourceOptions())
        
        return (vBuf, tBuf, texCoordsBuf)
    }
    
    class func buildVertexBuffer(_ _n : Int) -> MTLBuffer {
        var vals = [Vertex]()
        for _ in 0..._n {
            vals.append(Vertex(x: 0.0, y: 0.0, z: 0.0, color: 0.0))
        }
        return MetalContext.sharedContext.device.makeBuffer(bytes: &vals, length: vals.count * 4 * MemoryLayout<Float>.size, options: MTLResourceOptions())
    }
    
    class func buildSimpleBuffer(_ radius: Float, rows: Int = 20, columns: Int = 20) -> ([VertexData], [UInt32]){
        
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
    
    class func buildTriangleIdxBuffer(_ n: Int) -> MTLBuffer {
        var indices = [UInt32]()
        for i in 0..<n {
            indices.append(UInt32(i))
        }
        return MetalContext.sharedContext.device.makeBuffer(bytes: &indices, length: indices.count * MemoryLayout<UInt32>.size, options: MTLResourceOptions())
    }
    
}

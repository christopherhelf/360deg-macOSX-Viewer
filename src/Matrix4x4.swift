//
//  Matrix4x4.swift
//
//  Created by Christopher Helf on 13.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation

class Matrix4x4 {
    
    let rows: Int = 4
    let columns: Int = 4
    var grid: [Float]
    
    init() {
        grid = Array(repeating: 0.0, count: rows * columns)
        grid[0] = 1.0
        grid[5] = 1.0
        grid[10] = 1.0
        grid[15] = 1.0
    }
    
    func transpose()
    {
        var tmp: [Float] = Array(repeating: 0.0, count: rows * columns)
        for i in 0..<4
        {
            for j in 0..<4
            {
                tmp[4 * i + j] = grid[i + 4 * j]
            }
        }
        for i in 0..<16
        {
            grid[i] = tmp[i]
        }
    }
    
    func multiplyMatrix(_ matrix: Matrix4x4)
    {
        var tmp: [Float] = Array(repeating: 0.0, count: columns)
        for j in 0..<4
        {
            tmp[0] = grid[j]
            tmp[1] = grid[4+j]
            tmp[2] = grid[8+j];
            tmp[3] = grid[12+j];
            for i in 0..<4
            {
                var value = matrix.grid[4*i  ]*tmp[0]
                value = value + matrix.grid[4*i+1]*tmp[1]
                value = value + matrix.grid[4*i+2]*tmp[2]
                value = value + matrix.grid[4*i+3]*tmp[3]
                
                grid[4*i+j] = value
            }
        }
    }
    
    func rotateAroundX(_ angleRad: Float)
    {
        let m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = 1.0
        m.grid[ 5] = cosf(angleRad)
        m.grid[10] = m.grid[5]
        m.grid[ 6] = sinf(angleRad)
        m.grid[ 9] = -m.grid[6]
        
        multiplyMatrix(m)
    }
    
    func rotateAroundY(_ angleRad: Float)
    {
        let m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = cosf(angleRad)
        m.grid[ 5] = 1.0
        m.grid[10] = m.grid[0]
        m.grid[ 2] = -sinf(angleRad)
        m.grid[ 8] = -m.grid[2]
        
        multiplyMatrix(m)
    }
    
    func rotateAroundZ(_ angleRad: Float)
    {
        let m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = cosf(angleRad)
        m.grid[ 5] = m.grid[0]
        m.grid[10] =  1.0
        m.grid[ 1] = sinf(angleRad)
        m.grid[ 4] = -m.grid[1]
        
        multiplyMatrix(m)
    }
    
    func translate(_ x:Float, y:Float, z:Float)
    {
        let m: Matrix4x4 = Matrix4x4()            // create identity matrix
        m.grid[12] = x
        m.grid[13] = y
        m.grid[14] = z
        
        multiplyMatrix(m)
    }
    
    func scale(_ x:Float, y:Float, z:Float)
    {
        let m: Matrix4x4 = Matrix4x4()            // create identity matrix
        m.grid[12] = x
        m.grid[13] = y
        m.grid[14] = z
        
        multiplyMatrix(m)
    }
}

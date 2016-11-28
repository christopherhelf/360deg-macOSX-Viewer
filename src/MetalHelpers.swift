//
//  MetalHelpers.swift
//
//  Created by Christopher Helf on 12.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

import Foundation
import Metal
import CoreGraphics
import QuartzCore
import AppKit
import MetalKit

class MetalHelpers {
    
    class func loadImageFromPath(_ path: String) -> MTLTexture? {
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let textureLoader = MTKTextureLoader(device: MetalContext.sharedContext.device)
        do {
            return try textureLoader.newTexture(with: data, options: nil)
        } catch {
            return nil
        }
    }
    
    class func loadImage(_ _image: NSImage?) -> MTLTexture?
    {
        guard let image = _image else { return nil; }
        var imageRect = NSMakeRect(0, 0, image.size.width, image.size.height)
        let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        let width = imageRef?.width
        let height = imageRef?.height
        if width == 0 || height == 0 { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var rawData = [UInt8](repeating: 0, count: height! * width! * 4)
        
        let bytesPerPixel = 4;
        let bytesPerRow = bytesPerPixel * width!;
        let bitsPerComponent = 8;
        let bitmapInfo:CGBitmapInfo = [.byteOrder32Big, CGBitmapInfo(rawValue: ~CGBitmapInfo.alphaInfoMask.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)]
        let bitmapContext = CGContext(data: &rawData, width: width!, height: height!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        bitmapContext?.translateBy(x: 0, y: CGFloat(height!));
        bitmapContext?.scaleBy(x: 1, y: -1);
        bitmapContext?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)));
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Uint, width: width!, height: height!, mipmapped: false)
        let texture = MetalContext.sharedContext.device.makeTexture(descriptor: textureDescriptor)

        let region = MTLRegionMake2D(0, 0, width!, height!);
        texture.replace(region: region, mipmapLevel: 0, withBytes: &rawData, bytesPerRow: bytesPerRow)
        
        return texture;
    }
    
    class func getComputePipeline(_ kernel: String) -> MTLComputePipelineState? {
        do {
            guard let kernel = MetalContext.sharedContext.library.makeFunction(name: kernel) else {
                return nil
            }
            return try MetalContext.sharedContext.device.makeComputePipelineState(function: kernel)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
    }
    
    class func getFunction(_ name: String) -> MTLFunction? {
        return MetalContext.sharedContext.library.makeFunction(name: name)
    }
    
    class func getRenderPipeline(_ pipelineStateDescriptor: MTLRenderPipelineDescriptor, vertexDescriptor: MTLVertexDescriptor, pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLRenderPipelineState? {
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            return try MetalContext.sharedContext.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            
        } catch let pipelineError as NSError {
            print(pipelineError)
            return nil
        }

    }
    
    class func getBilinearSampler() -> MTLSamplerState {
        let bilinear = MTLSamplerDescriptor()
        bilinear.label = "bilinear"
        bilinear.minFilter = .linear
        bilinear.magFilter = .linear
        return MetalContext.sharedContext.device.makeSamplerState(descriptor: bilinear)
    }

    
    
}

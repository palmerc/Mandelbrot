import Cocoa
import MetalKit
import PlaygroundSupport

/*:

 # Mandelbrot - not a horse
 
 This playground demonstrates a compute shader generating a texture and outputting directly to the MTKView.

 */

let shaderURL = Bundle.main.url(forResource: "Shader", withExtension: "metal")
let device = MTLCreateSystemDefaultDevice()
let frame = NSRect(x:0, y:0, width:512, height:512)
let mtkView = MTKView(frame: frame, device: device)

let renderer = MetalRenderer(view: mtkView, shaderURL: shaderURL)
mtkView.delegate = renderer

PlaygroundPage.current.liveView = mtkView



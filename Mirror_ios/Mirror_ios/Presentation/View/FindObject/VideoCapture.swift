//
//  VideoCapture.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/5/24.
//

import UIKit
import AVFoundation
import CoreVideo

public protocol VideoCaptureDelegate: class {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame: CVPixelBuffer?, timestamp: CMTime)
}

public class VideoCapture: NSObject {
    
    public var previewLayer: AVCaptureVideoPreviewLayer?
    public weak var delegate: VideoCaptureDelegate?
    public var fps = 15
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let queue = DispatchQueue(label: "com.yoojin.camera-queue")
    
    var lastTimestamp = CMTime()
    
    public func setUp(sessionPreset: AVCaptureSession.Preset = .inputPriority,
                      completion: @escaping (Bool) -> Void) {
        self.setUpCamera(sessionPreset: sessionPreset, completion: { success in
            completion(success)
        })
    }
    
    func setUpCamera(sessionPreset: AVCaptureSession.Preset, completion: @escaping (_ success: Bool) -> Void) {
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: .back) else {
            
            print("Error: no video devices available")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Error: could not create AVCaptureDeviceInput")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.connection?.videoOrientation = .portrait
        self.previewLayer = previewLayer
        
        let settings: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        ]
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // We want the buffers to be in portrait orientation otherwise they are
        // rotated by 90 degrees. Need to set this _after_ addOutput()!
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        let success = true
        completion(success)
    }
    
    public func start() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async { [self] in
                // 백그라운드 스레드에서 호출
                captureSession.startRunning()
            }
        }
    }
    
    public func stop() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Because lowering the capture device's FPS looks ugly in the preview,
        // we capture at full speed but only call the delegate at its desired
        // framerate.
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimestamp
        if deltaTime >= CMTimeMake(value: 1, timescale: Int32(fps)) {
            lastTimestamp = timestamp
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            delegate?.videoCapture(self, didCaptureVideoFrame: imageBuffer, timestamp: timestamp)
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("dropped frame")
    }
}


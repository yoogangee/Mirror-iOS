//
//  FindObjectCamera.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/5/24.
//

import UIKit
import Vision
import CoreMedia
import AVFoundation

class FindObjectCameraVC: UIViewController {

    // MARK: - UI Properties
    var videoPreview: UIView!
    var boxesView: DrawingBoundingBoxView!
    
    var object: String!
    
    // MARK - Core ML model
    lazy var objectDectectionModel = { return try? yolov8s() }()
    
    // MARK: - Vision Properties
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    var isInferencing = false
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 1)
    var lastExecution = Date()
    
    // MARK: - TableView Data
    var predictions: [VNRecognizedObjectObservation] = []
    var previousPredictions: [VNRecognizedObjectObservation] = []
    
    var audioPlayer: AVAudioPlayer?

    
    lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "물건 찾기"
        navigationTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        navigationTitle.textColor = .black
        return navigationTitle
    }()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = navigationTitle
        
        // Setup UI
        setUpUI()
        // Setup the model
        setUpModel()
        
        // Setup camera
        setUpCamera()
        
        print("\(object!)을/를 찾습니다.")
    }
    
    // MARK: - Setup UI
    func setUpUI() {
        // Video Preview
        videoPreview = UIView(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height - 80))
        view.addSubview(videoPreview)
        
        // Boxes View
        boxesView = DrawingBoundingBoxView(frame: CGRect(x: 0, y: 140, width: view.frame.width, height: view.frame.height - 230))
        view.addSubview(boxesView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        guard let objectDectectionModel = objectDectectionModel else { fatalError("fail to load the model") }
        if let visionModel = try? VNCoreMLModel(for: objectDectectionModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("fail to create vision model")
        }
    }

    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .iFrame1280x720) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

// MARK: - VideoCaptureDelegate
extension FindObjectCameraVC: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension FindObjectCameraVC {
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Post-processing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            self.predictions = predictions
            DispatchQueue.main.async {
                self.boxesView.predictedObjects = predictions
                self.playAlertSoundIfNeeded(objects: predictions)
                self.previousPredictions = predictions
                self.isInferencing = false
            }
        } else {
            
            self.isInferencing = false
        }
        self.semaphore.signal()
    }
    
    func playAlertSoundIfNeeded(objects: [VNRecognizedObjectObservation]) {
        let desiredObject = object // Change this to your desired object's label
        
        let objectDetected = objects.contains { $0.labels.first?.identifier == desiredObject } &&
                                     !previousPredictions.contains { $0.labels.first?.identifier == desiredObject }

        if objectDetected {
            // Play alert sound
            //print(desiredObject)
            playAlertSound()
        }
        else {
            //print("not")
        }
    }
    
    func playAlertSound() {
        // Insert code to play your alert sound here
        // For example, you can use AVFoundation to play an audio file
        // Example:
        
        
        let path = Bundle.main.path(forResource: "beep1", ofType: "mp3") // Change "alert_sound" to your audio file name
        let url = URL(fileURLWithPath: path!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.3
            //audioPlayer?.numberOfLoops = 0
            audioPlayer?.play()
            print("playSound")
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

//
//  FindObjectVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import SnapKit
import AVFoundation
import Speech

class FindObjectVC: UIViewController, AVAudioRecorderDelegate, SFSpeechRecognizerDelegate {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    var recordingSession: AVAudioSession!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "물건 찾기"
        navigationTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        navigationTitle.textColor = .black
        return navigationTitle
    }()
    
    lazy var informLabel: UILabel = {
        let informLabel = UILabel()
        informLabel.text = "찾고싶은 물건을 말씀해주세요"
        informLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        informLabel.textColor = .black
        return informLabel
    }()
    
    lazy var recordImg: UIImageView = {
        let recordImg = UIImageView()
        recordImg.image = UIImage(named: "recordImage")
        return recordImg
    }()
    
    lazy var recordBtn: UIButton = {
        let recordBtn = UIButton()
        recordBtn.setImage(UIImage(named: "recordImage"), for: .normal)
        return recordBtn
    }()
    
    lazy var speechLabel: UILabel = {
        let speechLabel = UILabel()
        speechLabel.text = "테스트"
        speechLabel.textColor = .black
        return speechLabel
    }()
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
        
        configureUI()
        addview()
        layout()
        
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            // 오디오 세션의 카테고리와 모드를 설정한다.
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            // 음성 녹음 권한을 요청한다.
            recordingSession.requestRecordPermission() { allowed in
                if allowed {
                    print("음성 녹음 허용")
                } else {
                    print("음성 녹음 비허용")
                }
            }
        } catch {
            print("음성 녹음 실패")
        }
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .notDetermined: print("Not determined")
            case .restricted: print("Restricted")
            case .denied: print("Denied")
            case .authorized: print("Mic: 권한 허용")
            @unknown default: print("Unknown case")
            }
        }
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    func configureUI() {
        self.navigationItem.titleView = navigationTitle
        
        let nextBtn = UIBarButtonItem(title: "다음", style: .done, target: self, action: #selector(openCamera))
        self.navigationItem.rightBarButtonItem = nextBtn
        
        recordBtn.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        //recordBtn.addTarget(self, action: #selector(speechRecognizer.stopTranscribing), for: .touchUpInside)
    }
    
    func addview() {
        view.addSubview(informLabel)
        view.addSubview(recordBtn)
        view.addSubview(speechLabel)
    }
    
    func layout() {
        informLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        recordBtn.snp.makeConstraints { make in
            make.width.height.equalTo(170)
            make.centerX.equalToSuperview()
            make.top.equalTo(informLabel.snp.bottom).offset(130)
        }
        speechLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(recordBtn.snp.bottom).offset(100)
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
    @objc func openCamera() {
        let findObjectCameraVC = FindObjectCameraVC()
        //findObjectCameraVC.hidesBottomBarWhenPushed = true
        findObjectCameraVC.object = speechLabel.text?.lowercased()
        navigationController?.pushViewController(findObjectCameraVC, animated: true)
    }
    
    @objc func recordButtonTapped() {
        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면
            print("녹음 종료")
            audioEngine.stop() // 오디오 입력을 중단한다.
            recognitionRequest?.endAudio()// 음성인식 역시 중단
            configureAudioSessionForPlayback()
            openCamera()
        }
        else {
            print("녹음 시작")
            startRecording()
        }
    }
    
    func startRecording() {
       
       if recognitionTask != nil {
           recognitionTask?.cancel()
           recognitionTask = nil
       }
       
       let audioSession = AVAudioSession.sharedInstance()
       do {
           try audioSession.setCategory(AVAudioSession.Category.record)
           try audioSession.setMode(AVAudioSession.Mode.measurement)
           try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
       }
       catch {}
     
       recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
       
       let inputNode = audioEngine.inputNode
          
       guard let recognitionRequest = recognitionRequest else {
           fatalError("")
       }
       
       recognitionRequest.shouldReportPartialResults = true
       
       recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
           
           var isFinal = false
           
           if result != nil {
               print("변환된 음성 : ", result?.bestTranscription.formattedString)
               self.speechLabel.text = result?.bestTranscription.formattedString
               isFinal = (result?.isFinal)!
           }
           
           if isFinal {
               self.audioEngine.stop()
               inputNode.removeTap(onBus: 0)
               
               self.recognitionRequest = nil
               self.recognitionTask = nil
           }
       })
       
       let recordingFormat = inputNode.outputFormat(forBus: 0)
       inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
           self.recognitionRequest?.append(buffer)
       }
       
       audioEngine.prepare()
       
       do {
           try audioEngine.start()
       }
       catch {}
   }
    
    func configureAudioSessionForPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }
}

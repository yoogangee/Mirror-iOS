//
//  DescribingVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import AVFoundation
import SnapKit

class DescribingVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    
    // 슬라이드 애니메이션에 사용될 값
    var isExistSummary: Bool = false // summaryView
    
    // AVCaptureSession: 카메라와 마이크의 비디오 및 오디오 데이터를 캡처하는 데 사용되는 객체
    var captureSession = AVCaptureSession()
    
    // AVCapturePhotoOutput: 이미지를 캡처하는 데 사용되는 객체
    var photoOutput = AVCapturePhotoOutput()
    
    // 카메라 미리보기를 위한 레이어
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // 블러 효과 적용된 뷰
    let blurredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        
        view.alpha = 0.7
        
        return view
    }()
    
    let shutterButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        button.setImage(UIImage.shutterIcon, for: .normal)
        button.addTarget(self, action: #selector(clickedShutter), for: .touchUpInside)
        
        return button
    }()
    
    let explainTextLabel: ScrollPaddingLabel = {
        let view = ScrollPaddingLabel(padding: UIEdgeInsets(top: 19, left: 20, bottom: 19, right: 20))
        
        view.setText(SharedData.shared.explainText)
        
        return view
    }()
    
    let arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.upArrow)
        
        return imageView
    }()
    
    lazy var arrowView: UIView = {
        let view = UIView()
        
        view.addSubview(arrowImage)
        view.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        return view
    }()
    
    lazy var summaryVStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [explainTextLabel, arrowView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 8
        
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var explainView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.customWhite
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        return view
    }()
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slideUpGesture = UIPanGestureRecognizer(target: self, action: #selector(slideHandle(_:)))
        explainView.addGestureRecognizer(slideUpGesture)
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        view.backgroundColor = UIColor.customWhite
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "이미지 설명"
    }
    
    override func addview() {
        // 카메라 뷰
        checkCameraPermission()
        setupCaptureSession()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        // 블러뷰와 촬영버튼
        view.addSubview(blurredView)
        view.addSubview(shutterButton)
        
        view.addSubview(explainView)
        explainView.addSubview(summaryVStackView)
    }
    
    override func layout() {
        blurredView.snp.makeConstraints {
            $0.width.centerX.bottom.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        shutterButton.snp.makeConstraints {
            $0.centerX.centerY.equalTo(blurredView)
        }
        
        explainView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(summaryVStackView).offset(12)
        }
        explainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        summaryVStackView.snp.makeConstraints {
            $0.top.equalTo(explainView.snp.top).offset(12)
            $0.width.equalTo(explainView).offset(-36)
            $0.centerX.equalTo(explainView)
        }
        
        explainTextLabel.snp.makeConstraints {
            $0.width.equalTo(explainView).offset(-36)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
        
        arrowView.snp.makeConstraints{
            $0.width.equalTo(explainView).offset(-36)
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerX.equalTo(arrowView)
            $0.centerY.equalTo(arrowView)
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
    func setupCaptureSession() {
        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            // 카메라 장치를 입력으로 사용하여 세션을 설정합니다.
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
        } catch let error {
            print("Error setting up capture session:", error.localizedDescription)
        }
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    func startRunningCaptureSession() {
        DispatchQueue.global(qos: .background).async {
            // 백그라운드 스레드에서 호출
            self.captureSession.startRunning()
        }
    }
    
    @objc func clickedShutter() {
        print("카메라 셔터 클릭")
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setExplainView() {
        
        if isExistSummary {
            
            DispatchQueue.main.async { [self] in
                slideAnimation(explainView, slideDistance: explainView.frame.height, duration: 0.3)
            }
            
        } else {
            
            print("ExplainView 내리기")
            DispatchQueue.main.async { [self] in
                slideAnimation(explainView, slideDistance: explainView.frame.height, duration: 0.3)
                isExistSummary = true
            }
        }
    }
    
    func getPhotoExplain() {
        // 서버에 사진 보내고 설명 받기
        
        SharedData.shared.explainText = "서버에서 보내온 텍스트" // TODO: 서버에서 받아온 사진에 대한 설명 설정
        DispatchQueue.main.async { [self] in
            explainTextLabel.setText(SharedData.shared.explainText)
            isExistSummary = true
        }
        
        setExplainView()
        
    }
    
    @objc func slideHandle(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: explainView)
        
        if recognizer.state == .ended { // 움직임 끝남
            //going down
            if velocity.y>0 {
                print("요약화면 아래로 움직임")
                slideAnimation(explainView, slideDistance: explainView.frame.height, duration: 0.3)
                print(explainView.frame.maxY)
                arrowImage.image = UIImage.upArrow
            }
            //going up
            else {
                print("요약화면 위로 움직임")
                slideAnimation(explainView, slideDistance: 25, duration: 0.3)
                print(explainView.frame.maxY)
                arrowImage.image = UIImage.downArrow
            }
        } else { // 움직이는 중
        }
    }
    
    // MARK: - animations
    func slideAnimation(_ view: UIView, slideDistance: CGFloat, duration: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            
            view.transform = CGAffineTransform(translationX: 0, y: slideDistance)
        }, completion: nil)
    }

}

extension DescribingVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 카메라 접근 권한
    @objc func checkCameraPermission(){
       AVCaptureDevice.requestAccess(for: .video, completionHandler: { (isAuthorized: Bool) in
           if isAuthorized {
               print("Camera: 권한 허용")
               
           } else {
               print("Camera: 권한 거부")
           }
           
           guard isAuthorized else {
               self.showAlertGoToSetting() // 밑에서 계속 구현
               return
           }
       })
    }
           
    // 권한 거부 알림창 띄우기
    func showAlertGoToSetting() {
        
        let alertController = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > {앱 이름}탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true) // must be used from main thread only
        }
        
    }
    
    
}

extension DescribingVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error!.localizedDescription)")
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            print("Failed to convert photo to data")
            return
        }

        let capturedImage = UIImage(data: imageData)
        // Captured image is available here, you can use it as needed
        // TODO: - 이미지에서 텍스트 추출
        print("나는 이미지 묘사 페이지")
        
        getPhotoExplain()
        
    }
}



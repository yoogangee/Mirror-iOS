//
//  TextReadingVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import VisionKit
import AVFoundation

class TextReadingVC: BaseController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    
    // 슬라이드 애니메이션에 사용될 값
    var slidingDistance: CGFloat = 0
    var slideingFlag: Bool = false // false : 올리기 활성화
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

    // 결과 요약 뷰
    let gptImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.gptIcon)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let gptLabel: UILabel = {
       let label = UILabel()
        
        label.text = "chatGPT로 해당 문서 내용을 요약했어요."
        label.textColor = UIColor.customBlack
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    lazy var gptHStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [gptImage, gptLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = 8
        
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 19, left: 20, bottom: 19, right: 20))
        
        label.text = "GPT가 요약해준 문서 내용\n호호호"
        label.textColor = UIColor.customBlack
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.lineBreakMode = .byCharWrapping
        label.setLineSpacing(spacing: 4)
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.customGray2.cgColor
        
        return label
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        
        label.text = "전문이 궁금하시다면 하단 파란색 버튼을 클릭하세요."
        label.textColor = UIColor.customBlack
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    let emptyView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 17))
        
        return view
    }()
    
    let showAllBtn: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 8
        button.setTitle("문서 전문 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(clickedShowAllBtn), for: .touchUpInside)
        
        return button
    }()

    
    let arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.upArrow)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var arrowView: UIView = {
        let view = UIView()
        
        view.addSubview(arrowImage)
        
        return view
    }()
    
    lazy var summaryVStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [gptHStackView, summaryLabel, infoLabel, emptyView, showAllBtn, emptyView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 12
        
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var summaryView: UIView = {
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
        summaryView.addGestureRecognizer(slideUpGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slidingDistance = summaryVStackView.frame.height + 7
        print("slidingDistance:", slidingDistance)
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    override func configureUI() {
        view.backgroundColor = UIColor.customWhite
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "문서 읽기"
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

    }
    
    override func layout() {
        blurredView.snp.makeConstraints {
            $0.width.centerX.bottom.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        shutterButton.snp.makeConstraints {
            $0.centerX.centerY.equalTo(blurredView)
        }
    }
    
    func setSummaryView(text: String) {
        if isExistSummary {
            // TODO: - 로딩 이미지 삽입
            
            // 내용 변경
            summaryLabel.text = text
        } else {
            // 내용 삽입
            summaryLabel.text = text
            
            // 요약 뷰 추가
            view.addSubview(summaryView)
            summaryView.addSubview(summaryVStackView)
            summaryView.addSubview(arrowView)
            
            // 요약 뷰 레이아웃 설정
            summaryLabel.snp.makeConstraints {
                $0.width.equalTo(summaryVStackView)
            }
            
            showAllBtn.snp.makeConstraints {
                $0.width.equalTo(summaryVStackView)
                $0.height.equalTo(55)
            }
            
            summaryView.snp.makeConstraints {
                $0.centerX.width.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.height.equalTo(summaryVStackView).offset(20 + 6.8)
            }
            
            summaryVStackView.snp.makeConstraints {
                $0.centerX.centerY.equalTo(summaryView)
            }
            
            arrowView.snp.makeConstraints{
                $0.top.equalTo(summaryVStackView.snp.bottom)
                $0.width.equalTo(summaryView)
                $0.height.equalTo(6.8)
            }
            
            arrowImage.snp.makeConstraints {
                $0.centerX.equalTo(arrowView)
                $0.width.equalTo(17.45)
                $0.height.equalTo(6.8)
            }
            
            DispatchQueue.main.async { [self] in
                slideAnimation(summaryView, slideDistance: summaryView.frame.height, duration: 0.6)
                slideingFlag = true
            }
        }
    }
    
    func removeSummaryView() {
        summaryView.removeFromSuperview()
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
    
    @objc func clickedShowAllBtn() {
        print("문서 전문 보기")
        
        let vc = FullTextVC()
        vc.textReadingDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func slideHandle(_ recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation (in: summaryView)
        let velocity = recognizer.velocity(in: summaryView)
//        let height = summaryView.frame.maxY
        
        if recognizer.state == .ended { // 움직임 끝남
            slideingFlag = !slideingFlag
            //going down
            if velocity.y>0 {
                print("요약화면 아래로 움직임")
                slideAnimation(summaryView, slideDistance: summaryView.frame.height, duration: 0.5)
                print(summaryView.frame.maxY)
                arrowImage.image = UIImage.upArrow
            }
            //going up
            else {
                print("요약화면 위로 움직임")
                slideAnimation(summaryView, slideDistance: summaryView.frame.height-slidingDistance, duration: 0.5)
                print(summaryView.frame.maxY)
                arrowImage.image = UIImage.downArrow
            }
        } else { // 움직이는 중
//            if height+translation.y <= 367.33333333333337 && height+translation.y >= 117.33333333333331 {
//                summaryView.frame.origin.y = height+translation.y - summaryView.frame.height
//                UIView.animate (withDuration: 0, animations: {
//                    self.summaryView.layoutIfNeeded()
//                })
//            }
//            
//            // 제스처 초기화
//            recognizer.setTranslation(.zero, in: summaryView)
        }
    }
    
    // MARK: - animations
    func slideAnimation(_ view: UIView, slideDistance: CGFloat, duration: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            
            view.transform = CGAffineTransform(translationX: 0, y: slideDistance)
        }, completion: nil)
    }

}

extension TextReadingVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension TextReadingVC: AVCapturePhotoCaptureDelegate {
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
        SharedData.shared.recognizedFullText = "인식된 전문" // TODO: - fullTextLabel에 전문 내용 할당
        
        // TODO: - GPT로 텍스트 요약및 내용 할당
        setSummaryView(text: "GPT가 새로 요약해준 내용이지요~!")
    }
}

extension TextReadingVC: TextReadingDelegate {
    func upDateisExistSummary(_ isExist: Bool) {
        isExistSummary = isExist
        removeSummaryView()
    }
}

//
//  ViewController.swift
//  Mirror
//
//  Created by 장윤정 on 2023/11/02.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    
    lazy var findButton : UIButton = {
        let button = UIButton()
        
        button.setDimensions(height: 120, width: 120)
        if let buttonImage = UIImage(named: "find") {
            let scaledImage = buttonImage.resized(to: CGSize(width: 90, height: 90))
            let tintedImage = scaledImage?.withRenderingMode(.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
        }
        
        button.backgroundColor = UIColor(named: "main00")
        button.tintColor = UIColor(named: "white00")
        button.layer.cornerRadius = 5
        
        button.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        button.addGestureRecognizer(tapGesture)
        
        return button
    }()
    
    let Button: UIButton = {
        let button = UIButton()
        
        
        
        return button
    }()
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        checkCameraPermission()
//        checkAlbumPermission()
    }
    
    // MARK: - Actions
    // IBAction 및 사용자 인터랙션과 관련된 메서드 정의
    func configureUI() {
        view.backgroundColor = UIColor(named: "bg00")
        view.addSubview(findButton)
        
        findButton.centerX(inView: view)
        findButton.centerY(inView: view)
    }
    
    @objc func openCamera() {
      // Privacy - Camera Usage Description
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard isAuthorized else {
                self?.showAlertGoToSetting() // 밑에서 계속 구현
                return
            }
            
            // TODO - 카메라 열기
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController() // must be used from main thread only
                pickerController.sourceType = .camera
                pickerController.allowsEditing = false
                pickerController.mediaTypes = ["public.image"]
                // 만약 비디오가 필요한 경우,
//                imagePicker.mediaTypes = ["public.movie"]
//                imagePicker.videoQuality = .typeHigh
                pickerController.delegate = self
                self?.present(pickerController, animated: true)
            }
        }
    }
    
    // MARK: - Helpers
    // 설정, 데이터처리 등 액션 외의 메서드를 정의
}


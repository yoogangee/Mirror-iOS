//
//  PermissionExtension.swift
//  Mirror
//
//  Created by 장윤정 on 2023/11/02.
//

import UIKit
import Photos
import AVFoundation

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // 카메라 접근 권한
    @objc func checkCameraPermission(){
       AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
               
           } else {
               print("Camera: 권한 거부")
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
    
//    @objc private func openCamera() {
//      #if targetEnvironment(simulator)
//      fatalError()
//      #endif
//      
//      // Privacy - Camera Usage Description
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
//            guard isAuthorized else {
//                self?.showAlertGoToSetting() // 밑에서 계속 구현
//                return
//            }
//            
//            // TODO - 카메라 열기
//            DispatchQueue.main.async {
//                let pickerController = UIImagePickerController() // must be used from main thread only
//                pickerController.sourceType = .camera
//                pickerController.allowsEditing = false
//                pickerController.mediaTypes = ["public.image"]
//                // 만약 비디오가 필요한 경우,
//                //      imagePicker.mediaTypes = ["public.movie"]
//                //      imagePicker.videoQuality = .typeHigh
//                pickerController.delegate = self
//                self?.present(pickerController, animated: true)
//            }
//        }
//    }
        
    
    // 사진첩 접근 권한
//    notDetermined : 아직 접근 여부를 결정하지 않은 상태
//    restricted : 앨범에 접근 불가능하고, 권한 변경이 불가능한 상태
//    denied : 앨범 접근 불가능한 상태. 권한 변경이 가능함.
//    authorized : 앨범 접근이 승인된 상태.
//    func checkAlbumPermission(){
//        PHPhotoLibrary.requestAuthorization( { status in
//            switch status{
//            case .authorized:
//                print("Album: 권한 허용")
//            case .denied:
//                print("Album: 권한 거부")
//            case .restricted, .notDetermined:
//                print("Album: 선택하지 않음")
//            default:
//                break
//            }
//        })
//    }

    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
      ) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
              picker.dismiss(animated: true)
              return
            }

        picker.dismiss(animated: true, completion: nil)
        // 비디오인 경우 - url로 받는 형태
    //    guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
    //      picker.dismiss(animated: true, completion: nil)
    //      return
    //    }
    //    let video = AVAsset(url: url)
      }
}

//
//  HomeVC.swift
//  Mirror
//
//  Created by 경유진 on 2/25/24.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mainLogo")
        return image
    }()
}

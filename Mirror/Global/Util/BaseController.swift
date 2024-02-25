//
//  BaseController.swift
//  Mirror
//
//  Created by 장윤정 on 2024/01/27.
//

import UIKit

class BaseController: UIViewController {
        
    func configureUI(){}
    func addview(){}
    func layout(){}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.addview()
        self.layout()
    }
    
}

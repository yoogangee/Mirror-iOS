//
//  BaseController.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

//BaseController
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

//
//  ViewController.swift
//  ISSLive
//
//  Created by Alex on 2/2/22.
//

import UIKit
import os.log

final class ISSViewController: UIViewController {
    
    private var positionViewModel: PositionViewModel?
    private var crewViewModel: CrewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModels()
        // Do any additional setup after loading the view.
    }
    
    private func initViewModels() {
        positionViewModel = PositionViewModel()
        crewViewModel = CrewViewModel()
    }
}


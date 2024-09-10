//
//  ViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 10.07.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
    }
    
    //MARK: - Private - 
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Omni_Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var homeTotalView: HomeAllResultsView  = {
        let view = HomeAllResultsView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var homeReportsView: HomeReportsView = {
        let view = HomeReportsView()
        view.backgroundColor = .clear
        return view
    }()
    
    private func prepareViews() {
        self.view.backgroundColor = .clear
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.homeTotalView)
        self.view.addSubview(self.homeReportsView)
        
        self.logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(60)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        self.homeTotalView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(14)
        }
        
        self.homeReportsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(self.homeTotalView.snp.bottom).offset(12)
        }
    }

}


//
//  AboutViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

class AboutViewController: UIViewController {
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
    }
    
    //MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.appDescView,
                                                       self.legalNoticeView,
                                                       self.versionView,
                                                       self.webSiteView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var appDescView: AboutItemView = {
        let view = AboutItemView()
        view.configure(title: "Omni",
                       description: "Pos Çözümlerinde Lider")
        return view
    }()
    
    private lazy var legalNoticeView: AboutItemView = {
        let view = AboutItemView()
        view.configure(title: NSLocalizedString("Legal_Notice", comment: "Yasal Uyarı"),
                       description: NSLocalizedString("Legal_Notice_Statement", comment: "Uyarı"))
        return view
    }()
    
    private lazy var versionView: AboutItemView = {
        let view = AboutItemView()
        view.configure(title: NSLocalizedString("Version", comment: "Versiyon"),
                       description: "1.2")
        return view
    }()
    
    private lazy var webSiteView: AboutItemView = {
        let view = AboutItemView()
        view.configure(title: NSLocalizedString("Website", comment: "Web Site"),
                       description: "www.omni.com.tr")
        return view
    }()
    
    private func prepareViews() {
        self.view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        backButton.tintColor = .systemBlue
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = NSLocalizedString("About", comment: "Hakkında")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.view.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

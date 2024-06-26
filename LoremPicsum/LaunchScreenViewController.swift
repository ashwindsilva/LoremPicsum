//
//  LaunchScreenViewController.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import UIKit

protocol LaunchScreenViewControllerDelegate: AnyObject {
    func timeout()
}

class LaunchScreenViewController: UIViewController {

    // MARK: - Properties
    
    weak var delegate: LaunchScreenViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTimer()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logo)
        view.backgroundColor = .primaryBackground
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.delegate?.timeout()
        }
    }
}

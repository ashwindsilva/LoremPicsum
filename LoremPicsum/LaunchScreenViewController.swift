//
//  LaunchScreenViewController.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // TODO: navigate 
        }
    }
    
    private func setupView() {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 1)
        ])
    }
}

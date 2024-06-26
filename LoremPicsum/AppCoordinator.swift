//
//  AppCoordinator.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import UIKit

class AppCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
    func start() {
        let launchScreenController: LaunchScreenViewController = .init()
        window.rootViewController = launchScreenController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.window.rootViewController = PhotosListViewController()
        }
    }
}

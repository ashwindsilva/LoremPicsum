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
        
        // Set PhotosListViewController as the root view controller after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            let viewModel: PhotosListViewController.ViewModel = .init(
                photosService: RemotePhotosService(),
                imageLoader: RemoteImageLoader()
            )
            self?.window.rootViewController = PhotosListViewController(viewModel: viewModel)
        }
    }
}

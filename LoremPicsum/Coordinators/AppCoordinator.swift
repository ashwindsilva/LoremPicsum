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
    private let photoService: PhotosService
    private let imageLoader: ImageLoader
    
    // MARK: - Init
    
    init(window: UIWindow, photoService: PhotosService, imageLoader: ImageLoader) {
        self.window = window
        self.photoService = photoService
        self.imageLoader = imageLoader
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
    func start() {
        let launchScreenController: LaunchScreenViewController = .init()
        window.rootViewController = launchScreenController
        
        // Set PhotosListViewController as the root view controller after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            
            let viewModel: PhotosListViewController.ViewModel = .init(
                photosService: self.photoService,
                imageLoader: self.imageLoader
            )
            self.window.rootViewController = PhotosListViewController(viewModel: viewModel)
        }
    }
}

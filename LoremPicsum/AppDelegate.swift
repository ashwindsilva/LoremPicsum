//
//  AppDelegate.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let photoService: RemotePhotosService = .init()
    private let imageLoader: RemoteImageLoader = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window
        
        appCoordinator = AppCoordinator(
            window: window,
            photoService: photoService,
            imageLoader: imageLoader
        )
        appCoordinator.start()
        
        return true
    }
}


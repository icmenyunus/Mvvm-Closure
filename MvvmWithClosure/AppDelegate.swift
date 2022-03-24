//
//  AppDelegate.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setRootViewControllerWithWindow()

        return true
    }

    private func setRootViewControllerWithWindow() {
        let booksViewModel = BooksViewModel(apiService: BaseApiClient())
        let viewController = BooksViewController(with: booksViewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

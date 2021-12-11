//
//  HomeScreenNavigator.swift
//  DemoClassifieds
//
//  Created by Aravind on 10/12/2021.
//

import UIKit

final class HomeScreenNavigator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeScreenViewController = storyboard.instantiateViewController(identifier: "HomeScreenViewController") as! HomeScreenViewController
        let homeScreenViewModel = HomeScreenViewModel()
        homeScreenViewController.viewModel = homeScreenViewModel
        navigationController.viewControllers = [homeScreenViewController]
    }
    
}

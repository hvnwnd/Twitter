//
//  AppCoordinator.swift
//  Twitter
//
//  Created by Bin CHEN on 15/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    fileprivate var viewController : UINavigationController?
    var childCoordinators: [Coordinator] = []

    init(viewController : UINavigationController) {
        self.viewController = viewController
    }
    
    func start(){
        let networkService = NetworkService()
        let listCoordinator = ListCoordinator(viewController: viewController!.topViewController as! ListViewController, networkService: networkService)
        childCoordinators.append(listCoordinator)
        listCoordinator.start()
    }
}

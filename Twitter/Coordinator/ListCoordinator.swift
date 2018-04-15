//
//  ListCoordinator.swift
//  Twitter
//
//  Created by Bin CHEN on 15/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ListCoordinator : Coordinator {
    var networkService : NetworkService
    var viewController : ListViewController
    var childCoordinators: [Coordinator] = []

    let disposeBag = DisposeBag()
    
    init(viewController: ListViewController, networkService: NetworkService) {
        self.viewController = viewController
        self.networkService = networkService
        self.viewController.delegate = self
    }
    
    func start() {
        networkService.fetchTweets()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tweets in
            self.viewController.tweets = tweets
            self.viewController.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension ListCoordinator : ListViewControllerProtocol{
    func listViewControllerDidChoose(viewController: ListViewController, destViewController: UIViewController, tweet: Tweet) {
        let detailCoordinator = DetailCoordinator(viewController: destViewController as! DetailViewController, tweet: tweet)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}



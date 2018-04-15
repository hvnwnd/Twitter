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

class ListCoordinator : NSObject, Coordinator {
    fileprivate var networkService : NetworkService
    fileprivate var viewController : ListViewController
    var childCoordinators: [Coordinator] = []
    fileprivate var tweets : [Tweet]?
    fileprivate let disposeBag = DisposeBag()
    
    init(viewController: ListViewController, networkService: NetworkService) {
        self.viewController = viewController
        self.networkService = networkService
    }
    
    func start() {
        networkService.fetchTweets()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tweets in
                self.viewController.delegate = self
                self.viewController.tableView.dataSource = self
                self.tweets = tweets
                self.viewController.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension ListCoordinator : ListViewControllerProtocol{
    func listViewControllerDidChoose(viewController: ListViewController, destViewController: UIViewController, row: Int){
        if let t = tweets {
            let detailCoordinator = DetailCoordinator(viewController: destViewController as! DetailViewController, tweet: t[row])
            childCoordinators.append(detailCoordinator)
            detailCoordinator.start()
        }
    }
}

extension ListCoordinator : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let t = tweets {
            return t.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        if let t = tweets {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = t[indexPath.row].text
        }
        return cell
    }
}




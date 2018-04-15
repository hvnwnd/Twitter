//
//  DetailCoordinator.swift
//  Twitter
//
//  Created by Bin CHEN on 15/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class DetailCoordinator : Coordinator {
    fileprivate var viewController : DetailViewController
    var childCoordinators: [Coordinator] = []
    fileprivate var tweet : Tweet

    init(viewController: DetailViewController, tweet: Tweet) {
        self.viewController = viewController
        self.tweet = tweet
        self.viewController.delegate = self
    }

    func start(){
    }
}

extension DetailCoordinator : DetailViewControllerProtocol {
    func detailViewControllerShouldUpdateContent() {
        viewController.textLabel.text = tweet.text
        if let date = tweet.date{
            viewController.dateLabel.text = "Created at: \(DateFormatter.displayFormat.string(from: date))"
        }
        
        if let count = tweet.retweetCount {
            viewController.retweetLabel.text = "Retweeted: \(count) times"
        }
        
        if let tags = tweet.entity?.hashTags, tags.count > 0 {
            viewController.hashtagLabel.text = "Hash tags : \(tags.compactMap{ $0.text! }.joined(separator: ", "))"
        }
    }
    
    func retweetButtonClicked() {
        if let msg = tweet.sharedText()?.urlEncoding(), UIApplication.shared.canOpenURL(URL(string: "twitter://")!){
            let encodedUrl = "twitter://post?message=\(msg)"
            UIApplication.shared.open(URL(string: encodedUrl)!, options: [:], completionHandler: nil)
        }else{
            print("Twitter scheme not allowed")
        }
    }
}

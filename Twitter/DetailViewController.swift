//
//  DetailViewController.swift
//  Twitter
//
//  Created by Bin CHEN on 15/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import UIKit

protocol DetailViewControllerProtocol : class {
    func detailViewControllerShouldUpdateContent()
    func retweetButtonClicked()
}

class DetailViewController: UIViewController {
    weak var delegate : DetailViewControllerProtocol?
    
    @IBOutlet weak var textLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var retweetLabel : UILabel!
    @IBOutlet weak var hashtagLabel : UILabel!
    @IBOutlet weak var retweetButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.detailViewControllerShouldUpdateContent()
    }
    
    @IBAction func shareTweet() {
        delegate?.retweetButtonClicked()
    }
}

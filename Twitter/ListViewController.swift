//
//  ViewController.swift
//  Twitter
//
//  Created by Bin CHEN on 13/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import UIKit
import RxSwift

protocol ListViewControllerProtocol : class {
    func listViewControllerDidChoose(viewController: ListViewController, destViewController: UIViewController, tweet: Tweet)
}

class ListViewController: UIViewController {
    var tweets : [Tweet]?
    public weak var delegate : ListViewControllerProtocol?
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let t = tweets, let row = tableView.indexPathForSelectedRow?.row {
            delegate?.listViewControllerDidChoose(viewController: self, destViewController: segue.destination, tweet: t[row])
        }
    }
}

extension ListViewController : UITableViewDelegate, UITableViewDataSource {
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



//
//  ViewController.swift
//  Twitter
//
//  Created by Bin CHEN on 13/04/2018.
//  Copyright © 2018 Bin CHEN. All rights reserved.
//

import UIKit

protocol ListViewControllerProtocol : class {
    func listViewControllerDidChoose(viewController: ListViewController, destViewController: UIViewController, row: Int)
}

class ListViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    public weak var delegate : ListViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row {
            delegate?.listViewControllerDidChoose(viewController: self, destViewController: segue.destination, row: row)
        }
    }
}

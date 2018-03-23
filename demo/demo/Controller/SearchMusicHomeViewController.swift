//
//  SearchMusicHomeViewController.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class SearchMusicHomeViewController: UIViewController {

    @IBOutlet weak var titleItem: UITabBarItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var searchResultArray = NSMutableArray();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - initUI
    func initUI() {
        self.titleItem.title = "搜索";
        self.title = "搜索";
        self.tableview.tableFooterView = UIView();
    }
    
    // MARK: - Navigation

}

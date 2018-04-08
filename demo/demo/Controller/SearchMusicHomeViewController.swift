//
//  SearchMusicHomeViewController.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class SearchMusicHomeViewController: UIViewController,UITableViewDelegate,UISearchBarDelegate {

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
        self.searchBar.delegate = self;
        self.tableview.delegate = self;

        let gesture = UITapGestureRecognizer(target:self ,action: #selector(SearchMusicHomeViewController.handleTap));
        self.view.addGestureRecognizer(gesture)
        
    }
    
    
    @objc func handleTap() {
        self.searchBar.resignFirstResponder();
    }
    // MARK: - SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchBar.text!);
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var page = 1;
        var num = 20;
        let text = searchBar.text!
        print(text);
//        print (NetworkManager().searchSongFromQQMusic(keyword:text as NSString, page: &page, number: &num));
        print(NetworkManager().searchSongFrom163Music(keyword:text as NSString));
        searchBar.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.resignFirstResponder();
    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.searchBar.resignFirstResponder()
//    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.resignFirstResponder();
    }
}

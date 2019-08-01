//
//  SearchMusicHomeViewController.swift
//  demo
//
//  Created by U-NAS on 2018/3/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class SearchMusicHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var titleItem: UITabBarItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var searchResultArray = NSMutableArray();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        
//        DownloadManager().downloadFromQQMusic(mid: "001Qu4I30eVFYb", name: "abc", suc: {
//            print("--------+-+-------");
//        }) { (error) in
//            print(error);
//        }
//        DownloadManager().downloadFrom163Music(id: "574921549", name: "怪咖", suc: {
//            print("--------+-+-------");
//        }) { (error) in
//            print(error);
//        }
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
        self.tableview.dataSource = self;
        self.tableview.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
//        let gesture = UITapGestureRecognizer(target:self ,action: #selector(SearchMusicHomeViewController.handleTap));
//        self.view.addGestureRecognizer(gesture)
        
    }
    
    
    @objc func handleTap() {
        self.searchBar.resignFirstResponder();
    }
    // MARK: - SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchBar.text!);
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = searchBar.text!
        print(text);
        NetworkManager().searchSong(keyword:text, suc: { (listMusic) in
            self.searchResultArray = listMusic;
            self.tableview.reloadData();
        }) { (error) in
            NSLog("%@",error);
        }
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
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath);
        let music = self.searchResultArray[indexPath.row] as! Music;
    
        var singerString = [String]();
        for singer in music.singer! {
            singerString.append(singer.name!);
        }
        let temp = singerString.joined(separator: "/");
    
        (cell as! TableViewCell).setInfo(title: music.name!, author: temp);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayMuiscViewController();
        vc.music = self.searchResultArray[indexPath.row] as? Music;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
//    self.performSegue(withIdentifier: "musicPlayer", sender: self.searchResultArray[indexPath.row]);
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "musicPlayer"{
//            let vc = segue.destination as! PlayMuiscViewController;
//            vc.music = sender as? Music;
//
//        }
//    }
}

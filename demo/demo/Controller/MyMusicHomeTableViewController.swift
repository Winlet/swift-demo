//
//  MyMusicHomeTableViewController.swift
//  demo
//
//  Created by U-NAS on 2018/3/22.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class MyMusicHomeTableViewController: UITableViewController {

    @IBOutlet weak var titleItem: UITabBarItem!
    
    var topShowArray : [NSString] = ["本地歌单","循环列表"];
    var bottomShowArray = NSMutableArray();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    // MARK: - initUI
    func initUI() {
        self.tableView.tableFooterView = UIView();
        self.titleItem.title = "我的音乐";
        self.title = "我的音乐";
        bottomShowArray.add("test");
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return self.topShowArray.count;
        }else{
            return self.bottomShowArray.count;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.topShowArray[indexPath.row] as String;
        }else{
            cell.textLabel?.text = (self.bottomShowArray[indexPath.row] as AnyObject).description;
        }
        

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//       return UIView();
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "歌单";
        }else{
            return "";
        }
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "localDetail", sender: nil);
            }else{
                NSLog("asd");
            }
        case 1:
            NSLog("asd");
        default:
            break;
        }
    }
   
    
}

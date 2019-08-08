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
        bottomShowArray.add("敬请期待...");
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 40));
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: 50, height: 20));
        label.font = UIFont.init(name: "Helvetica-Bold", size: 16.0);
        label.text = "歌单";
        view.addSubview(label);

        let button = UIButton.init(frame: CGRect.init(x: tableView.frame.size.width-30, y: 10, width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "加"), for: UIControlState.normal);
        button.addTarget(self, action: #selector(addMusicOrder), for: UIControlEvents.touchUpInside);
        view.addSubview(button);
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1);
       return view;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0;
        }else{
            return 40;
        }
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "localMVC") as! LocalMusicViewController;
            vc.fromType = indexPath.row + 1;
             self.navigationController?.pushViewController(vc, animated: true);
        case 1:
            NSLog("asd");
        default:
            break;
        }
    }
   
    @objc func addMusicOrder(){
        
    }
}

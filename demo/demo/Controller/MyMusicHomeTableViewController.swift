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
    var bottomShowArray = Array<String>();
    
    
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
//        bottomShowArray.add("敬请期待...");
        bottomShowArray = LocalFileManager.readSongList();
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "localMVC") as! LocalMusicViewController;
            vc.fromType = 3;
            vc.songListName = self.bottomShowArray[indexPath.row];
             self.navigationController?.pushViewController(vc, animated: true);
        default:
            break;
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.section==1 {
                return true
        }else{
            return false
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let str = self.bottomShowArray[indexPath.row];
            LocalFileManager.deleteSongList(name:str);
            self.bottomShowArray.remove(at: indexPath.row);
            //刷新tableview
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
    }
    @objc func addMusicOrder(){
        let alert = UIAlertController.init(title: "新建歌单", message: nil, preferredStyle: .alert);
        alert.addTextField { (textField) in
            textField.placeholder = "歌单标题";
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let enter = UIAlertAction.init(title: "确定", style: .default) { (action) in
            let name = alert.textFields?.first?.text;
            LocalFileManager.createSongList(name: name!);
            self.bottomShowArray = LocalFileManager.readSongList()
            self.tableView.reloadData();
        }
        alert.addAction(cancel);
        alert.addAction(enter);
        self.present(alert, animated: true, completion: nil);
    }
}

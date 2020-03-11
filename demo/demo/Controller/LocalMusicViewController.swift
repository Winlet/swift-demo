//
//  LocalMusicViewController.swift
//  demo
//
//  Created by U-NAS on 2018/7/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit
import SnapKit

class LocalMusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //    var musicShowArray = NSMutableArray();
    var fromType = 1;
    var lazyClear = true;
    var songListName:String = "loop";
    
    lazy var allTableView : UITableView = {
        let temp = UITableView.init(frame: CGRect.init(x: 0, y:0, width: 100, height: 100));
        temp.delegate = self;
        temp.dataSource = self;
        temp.tableFooterView = UIView.init();
        temp.register(UINib.init(nibName: "BehindLittleTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "listMusicCell")
        temp.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        temp.layer.borderWidth = 0.5;
        temp.layer.cornerRadius = 12;
        return temp;
    }()
    
    
    lazy var musicShowArray : Array<Music> = {
        if fromType == 1 {
            self.headView.isHidden = true;
            self.tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(0);
            })
            return StoreManager.getAllMusic();
        }else{
            self.headView.isHidden = false;
            self.allTableView.isHidden = true;
                return StoreManager.getListMusic(name: self.songListName);
            
        }
        
    }()
    
    var allMusicATemp : Array<Music>!
    var  allMusicArray : Array<Music> {
        get{
            if lazyClear {
                lazyClear = false;
                allMusicATemp = StoreManager.getLastListMusic(name: self.songListName);
                return allMusicATemp;
            }else{
                return allMusicATemp;
            }
        }set{
            allMusicATemp = newValue;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//            self.tabBar.hidden = true;
    }
    func initUI() {
        self.title = "歌单列表";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView.init();
        self.tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "showCell")
       if fromType != 1 {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(respondsFirst));
        tap.delegate = self;
        self.view.addGestureRecognizer(tap);
        }
    }
    //MARK: -delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return  self.musicShowArray.count;
        }else{
            return  self.allMusicArray.count;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath)
            let music = self.musicShowArray[indexPath.row];
            var singerString = [String]();
            for singer in music.singer {
                singerString.append(singer.name!);
            }
            let temp = singerString.joined(separator: "/");
            
            (cell as! TableViewCell).setInfo(title: music.name!, author:temp);
            return cell;
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "listMusicCell", for: indexPath)
            let music = self.allMusicArray[indexPath.row];
            var singerString = [String]();
            for singer in music.singer {
                singerString.append(singer.name!);
            }
            let temp = singerString.joined(separator: "/");
            
            (cell as! BehindLittleTitleTableViewCell).setInfo(title: music.name!, author:temp);
            return cell;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true);
        if tableView == self.tableView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "playVC") as! PlayMuiscViewController;
            let music = self.musicShowArray[indexPath.row];
            vc.music = music;
            vc.originList = self.musicShowArray;
            self.navigationController?.pushViewController(vc, animated: true);
        }else{
            let music = self.allMusicArray[indexPath.row];
            self.allMusicArray.remove(at: indexPath.row);
            self.musicShowArray.append(music);
            self.tableView.reloadData();
            self.allTableView.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let music = self.musicShowArray[indexPath.row];
            StoreManager.deleteMusic(by: music);
            self.musicShowArray.remove(at: indexPath.row);
            //刷新tableview
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
 
    //MARK: Action
    @objc func respondsFirst(){
        if fromType != 1 {
            if self.allTableView.isHidden == false {
                self.allTableView.isHidden = true;
                   _ = StoreManager.writeToListMusic(name:self.songListName, list: self.musicShowArray);
            }
        }
    }
    
    @IBAction func clearAllAction(_ sender: UIButton) {
        self.musicShowArray.removeAll();
        self.tableView.reloadData();
        
        lazyClear = true;
            StoreManager.clearListMusic(name: self.songListName);
        
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.addSubview(self.allTableView);
            self.allTableView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0);
                make.height.equalTo(400);
            })
            self.allTableView.isHidden = false;
            self.allTableView.reloadData();
        }, completion: nil);
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
//  LocalMusicViewController.swift
//  demo
//
//  Created by U-NAS on 2018/7/23.
//  Copyright © 2018年 U-NAS. All rights reserved.
//

import UIKit

class LocalMusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var tableView: UITableView!
//    var musicShowArray = NSMutableArray();
    
    lazy var musicShowArray : NSMutableArray = {
        let array = NSMutableArray();
        let ducumentPath = NSHomeDirectory() + "/Documents"
        let localPath = ducumentPath + "/Downloads"
        let fileManager = FileManager.default
        var files = fileManager.subpaths(atPath: localPath)
        for index in files!{
         let music = Music().initMusic(name:index, singer:"123");
            array.add(music);
        }
        return array;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI();
        // Do any additional setup after loading the view.
    }

    func initUI() {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    //MARK: -delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.musicShowArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localSongCell", for: indexPath)
        let music = self.musicShowArray[indexPath.row] as! Music;
        cell.textLabel?.text = music.name! as String;
        return cell;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

  

}

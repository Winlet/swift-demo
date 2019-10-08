//
//  IMOSuspendedBallView.swift
//  wuwei
//
//  Created by uinpay on 2019/9/17.
//  Copyright © 2019 U-NAS. All rights reserved
//

import UIKit

private let ScreenHeight = UIScreen.main.bounds.size.height
private let ScreenWidth = UIScreen.main.bounds.size.width
private let cornerRadio:CGFloat = 30.0
private let placeWidth = 5.0
private let centerX:CGFloat = 30.0  //x半径
private let centerY:CGFloat = 30.0  //y半径

class IMOSuspendedBallView: UIView,UIGestureRecognizerDelegate{
    
    enum SuspendedBallLocation:Int {
        case SuspendedBallLocation_LeftTop = 0
        case SuspendedBallLocation_Top
        case SuspendedBallLocation_RightTop
        case SuspendedBallLocation_Right
        case SuspendedBallLocation_RightBottom
        case SuspendedBallLocation_Bottom
        case SuspendedBallLocation_LeftBottom
        case SuspendedBallLocation_Left
    }
    static let instance = IMOSuspendedBallView()
    
    private var ballBtn:UIButton?
    private var timeLable:UILabel?
    private var currentCenter:CGPoint?
    private var panEndCenter:CGPoint = CGPoint(x: 0, y: 0)
    private var currentLocation:SuspendedBallLocation?
    private var mTimer:Timer?
    
    lazy private var firstShapeLayer = CAShapeLayer();
    lazy private var sencondShapeLayer = CAShapeLayer();
    lazy private var waveDisplayLink = CADisplayLink();
    /** 波动速度 */
    var waveSpeed : CGFloat = 0.1
    /** 水波振幅 */
    var waveAmplitude: CGFloat = 8
    /** 水波的高度 */
    var waveHeight : CGFloat = 0
    /** 水波颜色 */
    var waveColor : UIColor? {
        didSet {
            firstShapeLayer.fillColor = waveColor?.cgColor;
            sencondShapeLayer.fillColor = waveColor?.cgColor;
        }
    }
    private var waveWidth: CGFloat = 0
    private var offsetX: CGFloat = 0
    
    private var totalCount : Int = 0;
    private var currentNumber : Int = 0;

    
    public func addNum(){
        if (self.isHidden) {
            self.isHidden = false;
            self.totalCount = 0;
            self.currentNumber = 0;
            self.wave();
        }
        self.totalCount += 1;
        self.timeLable?.text = String.init(format: "%d/%d",self.currentNumber,self.totalCount);
    }
    
    public func progress(p:Double){
        self.waveHeight = CGFloat(p)*self.frame.size.height;
    }
//MARK:- init method
    private override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(2 * centerX), height: CGFloat(2 * centerY)))
        self.tag = 999;
        self.backgroundColor = UIColor.clear;
        self.layer.cornerRadius = cornerRadio;
        self.layer.borderWidth = 0.1;
        self.layer.masksToBounds = true
        self.currentCenter = CGPoint.init(x: 30, y: 200) //初始位置
        self.calculateShowCenter(point: self.currentCenter!)
        self.configLocation(point: self.currentCenter!)
        //跟随手指拖动
        let moveGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragBallView))
        self.addGestureRecognizer(moveGes)
  
        //添加到window上
        self.ww_getKeyWindow().addSubview(self)
        //显示在视图的最上层
        self.ww_getKeyWindow().bringSubview(toFront: self)
        self.wave();
        self.addSubview(self.getBallBtn())
        self.getBallBtn().addSubview(self.getTimeLable())
        
//        self.addNum();
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
   deinit{
        NSLog("IMOSuspendedBallView deinit")
    }
    public static var shared: IMOSuspendedBallView {
        return self.instance
    }
 //MARK:- other method
    
    //跟随手指拖动
    @objc func dragBallView(panGes:UIPanGestureRecognizer) {
        let translation:CGPoint = panGes.translation(in: self.ww_getKeyWindow())
        let center:CGPoint = self.center
        self.center = CGPoint(x: center.x+translation.x, y: center.y+translation.y)
        panGes .setTranslation(CGPoint(x: 0, y: 0), in: self.ww_getKeyWindow())
        if panGes.state == UIGestureRecognizerState.ended{
            self.panEndCenter = self.center
            self.caculateBallCenter()
        }
    }
    func wave() {
        // 初始化值
        
        self.waveWidth =  1.0 * CGFloat(Double.pi) / self.bounds.size.width;
        self.waveHeight = 0//self.frame.size.height / 2;
        
        firstShapeLayer.fillColor = UIColor.init(red: 0 / 255.0, green: 255 / 255.0, blue: 0 / 255.0, alpha: 0.5).cgColor
        sencondShapeLayer.fillColor = UIColor.init(red: 0 / 255.0, green: 255 / 255.0, blue: 0 / 255.0, alpha: 0.5).cgColor
        layer.addSublayer(firstShapeLayer)
        layer.addSublayer(sencondShapeLayer)
        
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(currentWave))
        waveDisplayLink.add(to: RunLoop.current, forMode: .commonModes)
        return ;
    }
    @objc func currentWave()  {
        offsetX += waveSpeed
        if self.waveHeight<self.frame.size.height{
//            self.waveHeight += 0.1;
        }else{
            if self.currentNumber<self.totalCount-1 {
                self.waveHeight = 0;
                self.currentNumber += 1;
                self.timeLable?.text = String.init(format: "%d/%d",self.currentNumber,self.totalCount);
            }else{
                self.destroyView();
            }
        }
        // 第一条线
        let firstPath = CGMutablePath()
        var firstY = bounds.size.width / 2
        firstPath.move(to: CGPoint(x: 0, y: firstY))
        for i in 0...Int(bounds.size.width) {
            firstY = waveAmplitude * sin(waveWidth * CGFloat(i) + offsetX) - waveHeight+2*centerX
            firstPath.addLine(to: CGPoint(x: CGFloat(i), y: firstY))
        }
        
        firstPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        firstPath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        firstPath.closeSubpath()
        firstShapeLayer.path = firstPath
        
        // 第二条线
        let secondPath = CGMutablePath()
        var secondY = bounds.size.width / 2
        secondPath.move(to: CGPoint(x: 0, y: secondY))
        
        for i in 0...Int(bounds.size.width) {
            secondY = waveAmplitude * sin(waveWidth * CGFloat(i) + offsetX - bounds.size.width / 2 ) - waveHeight+2*centerX
            secondPath.addLine(to: CGPoint(x: CGFloat(i), y: secondY))
        }
        secondPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        secondPath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        secondPath.closeSubpath()
        sencondShapeLayer.path = secondPath
    }
    public func destroyView() {
        waveDisplayLink.invalidate()
        self.isHidden = true;
    }
    //计算中心位置
    func caculateBallCenter() {
        if (self.panEndCenter.x>centerX && self.panEndCenter.x < ScreenWidth-centerX && self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY) {
            if (self.panEndCenter.y<3*centerY) {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x, y: centerY))
            }
            else if (self.panEndCenter.y>ScreenHeight-3*centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x, y: ScreenHeight-centerY))
            }
            else
            {
                if (self.panEndCenter.x<=ScreenWidth/2) {
                    self.calculateBallNewCenter(point: CGPoint(x: centerX, y: self.panEndCenter.y))
                }
                else{
                    self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX, y: self.panEndCenter.y))
                }
            }
        }
        else
        {
            if (self.panEndCenter.x<=centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX, y: centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX, y: centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX, y: ScreenHeight-centerY))
            }
            else if(self.panEndCenter.x<=centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX, y: ScreenHeight-centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y<centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x, y: centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y>ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(point: CGPoint(x: self.panEndCenter.x, y: ScreenHeight-centerY))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x<centerX)
            {
                self.calculateBallNewCenter(point: CGPoint(x: centerX,y: self.panEndCenter.y))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x>ScreenWidth-centerX)
            {
                self.calculateBallNewCenter(point: CGPoint(x: ScreenWidth-centerX,y: self.panEndCenter.y))
            }
        }

    }
    
    //
    func calculateBallNewCenter(point:CGPoint) {
        self.currentCenter = point
        self.configLocation(point: point)
        unowned let weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf.center = CGPoint(x: point.x, y: point.y)
        }
    }

    func calculateShowCenter(point:CGPoint) {
        unowned let weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf.center = CGPoint(x: point.x, y: point.y)
        }
    }
    
    //当前方位
    func configLocation(point:CGPoint) {
        if (point.x <= centerX*3 && point.y <= centerY*3) {
            self.currentLocation = .SuspendedBallLocation_LeftTop;
        }
        else if (point.x>centerX*3 && point.x<ScreenWidth-centerX*3 && point.y == centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Top;
        }
        else if (point.x >= ScreenWidth-centerX*3 && point.y <= 3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightTop;
        }
        else if (point.x == ScreenWidth-centerX && point.y>3*centerY && point.y<ScreenHeight-centerY*3)
        {
            self.currentLocation = .SuspendedBallLocation_Right;
        }
        else if (point.x >= ScreenWidth-3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightBottom;
        }
        else if (point.y == ScreenHeight-centerY && point.x > 3*centerX && point.x<ScreenWidth-3*centerX)
        {
            self.currentLocation = .SuspendedBallLocation_Bottom;
        }
        else if (point.x <= 3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_LeftBottom;
        }
        else if (point.x == centerX && point.y > 3*centerY && point.y<ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Left;
        }
    }
    
    //单列获取悬浮起按钮
    func getBallBtn() -> UIButton {
        if ballBtn == nil {
            ballBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: CGFloat(2 * centerX), height: CGFloat(2 * centerY)))
//            ballBtn?.layer.cornerRadius = cornerRadio
//            ballBtn?.backgroundColor = UIColor.green;
            ballBtn?.layer.masksToBounds = true
            ballBtn?.addTarget(self, action: #selector(clickBallViewAction), for: .touchUpInside)
        }
        return ballBtn!
    }
    
    //时间lable
    func getTimeLable() -> UILabel {
        if timeLable == nil{
            timeLable = UILabel.init(frame: CGRect(x: 0, y: centerY, width: 2 * centerX, height: centerY - 2))
            timeLable?.textColor = UIColor.black
            timeLable?.textAlignment = .center
            timeLable?.font = UIFont.init(name: "Helvetica", size: 13)
        }
        return timeLable!
    }
    
//MARK:- action
    @objc func clickBallViewAction() {
        
    }
    
//MARK:- private utility
    func ww_getKeyWindow() -> UIWindow {
        if UIApplication.shared.keyWindow == nil {
            return ((UIApplication.shared.delegate?.window)!)!
        }else{
            return UIApplication.shared.keyWindow!
        }
    }
    
}

//
//  ChartView.swift
//  ChartExample
//
//  Created by 陳鈞廷 on 2018/8/28.
//  Copyright © 2018年 陳鈞廷. All rights reserved.
//

import UIKit

class ChartView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var viewHeight, viewWidth: CGFloat!
    let ChartLine = UIBezierPath()
    let ChartLineLayer = CAShapeLayer()
    
    let maskLayer = CAShapeLayer() // mask for VisibleColorLayer
    let VisibleColorLayer = CAGradientLayer()
    let rainBowColors:[CGColor] = [ UIColor.black.cgColor,
                                    UIColor.purple.cgColor,
                                    UIColor.blue.cgColor,
                                    UIColor.green.cgColor,
                                    UIColor.yellow.cgColor,
                                    UIColor.orange.cgColor,
                                    UIColor.red.cgColor,
                                    UIColor.black.cgColor]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
        
        VisibleColorLayer.colors = rainBowColors
        VisibleColorLayer.startPoint = CGPoint(x: 0, y: 0)
        VisibleColorLayer.endPoint = CGPoint(x: 1, y: 0)
        VisibleColorLayer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
    }
    
    func ChartPlot(dataArray: Array<CGFloat>, specStart: Int, specEnd: Int) {
        VisibleColorLayer.locations = [ 0, 0.2, 0.3, 0.4 , 0.5, 0.7, 0.8] // need to be edit
        self.layer.addSublayer(VisibleColorLayer)
        
        // draw chart line
        let pointNum: Int = dataArray.count
        let pointWidth: CGFloat = viewWidth / CGFloat(pointNum + 1)
        ChartLine.move(to: CGPoint(x: 0, y: viewHeight))
        for i in 0...pointNum-1 {
            ChartLine.addLine(to: CGPoint(x: pointWidth * CGFloat(i+1), y: viewHeight - dataArray[i]))
        }
        ChartLine.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        ChartLineLayer.path = ChartLine.cgPath
        ChartLineLayer.fillColor = UIColor.clear.cgColor
        ChartLineLayer.strokeColor = UIColor.black.cgColor
        ChartLineLayer.lineWidth = 0.1
        self.layer.addSublayer(ChartLineLayer)
        
        // mask for VisibleColorLayer
        ChartLine.close()
        maskLayer.path = ChartLine.cgPath
        VisibleColorLayer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

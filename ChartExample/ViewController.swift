//
//  ViewController.swift
//  ChartExample
//
//  Created by 陳鈞廷 on 2018/8/26.
//  Copyright © 2018年 陳鈞廷. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var screenHeight:CGFloat = 0, screenWidth:CGFloat = 0
    var chartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // For 4.7 inch screen, ex. iPhone 8
        // screenHeight = 667.0 , screenWidth = 375.0
        screenHeight = self.view.frame.height
        screenWidth = self.view.frame.width
        let chartViewFrame = CGRect(x: screenWidth * 0.05, y: screenHeight * 0.35, width: screenWidth * 0.9, height: screenHeight * 0.3)
        
        chartView = ChartView(frame: chartViewFrame)
        
        let dataArray = randomArray(Length: 1920)
        chartView.ChartPlot(dataArray: dataArray, specStart: 0, specEnd: 0)
        self.view.addSubview(chartView)
        
    }
    
    func randomArray(Length: Int) -> Array<CGFloat>{
        let randomRange = UInt32(screenHeight * 0.2)
        var newArray = [CGFloat](repeating: 0, count: Length)
        
        for i in 0...Length-1 {
            newArray[i] = CGFloat(arc4random() % randomRange) + CGFloat(screenHeight * 0.1)
        }
        
        return newArray
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


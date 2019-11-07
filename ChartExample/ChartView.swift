//
//  ChartView.swift
//  ChartExample
//
//  Created by 陳鈞廷 on 2018/8/28.
//  Copyright © 2018年 陳鈞廷. All rights reserved.
//

import UIKit
import Foundation

private class AxisPointLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = NSTextAlignment.right
        self.baselineAdjustment = UIBaselineAdjustment.alignCenters
        // self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: 10)
    }
    
    public func setText(text: String) {
        self.text = "".padding(toLength: 3 - text.count, withPad: " ", startingAt: 0) + text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ChartView: UIView {
    var viewHeight, viewWidth, viewX, viewY: CGFloat!
    var chartPlaceUIView: UIView!
    
    let boundLayer = CAShapeLayer()            // Layer to place chart boundary
    let ChartBound = UIBezierPath()            // Line for chart boundary
    var XAxisIndices: Array<UILabel> = []      // X-Axis index
    var YAxisIndices: Array<UILabel> = []      // Y-Axis index
    let axisLabelWidth: CGFloat = 20
    let axisLabelHeight: CGFloat = 12
    
    let ChartLine = UIBezierPath()             // Line for chart plotting
    var ChartLineLayer = CAShapeLayer()        // Layer to place the chart line
    
    let maskLayer = CAShapeLayer()             // Mask for VisibleColorLayer
    let VisibleColorLayer = CAGradientLayer()
    let rainBowColors:[CGColor] = [ UIColor.black.cgColor,
                                    UIColor.purple.cgColor,
                                    UIColor.blue.cgColor,
                                    UIColor.green.cgColor,
                                    UIColor.yellow.cgColor,
                                    UIColor.orange.cgColor,
                                    UIColor.red.cgColor,
                                    UIColor.black.cgColor ]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewX      = 30
        viewWidth  = frame.width - viewX
        viewHeight = frame.height - 20
        
        chartPlaceUIView = UIView(frame: CGRect(x: viewX,
                                                y: 0,
                                                width: viewWidth,
                                                height: viewHeight))
        
        VisibleColorLayer.colors = rainBowColors
        VisibleColorLayer.startPoint = CGPoint(x: 0, y: 0) //
        VisibleColorLayer.endPoint = CGPoint(x: 1, y: 0) //
        VisibleColorLayer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        // self.backgroundColor = UIColor.gray
        self.addSubview(chartPlaceUIView)
    }
    
    /**
     Enable visible color layer.
     */
    public func enableVisibleColorLayer(enable: Bool){
        if enable{
            // self.layer.addSublayer(VisibleColorLayer)
            chartPlaceUIView.layer.addSublayer(VisibleColorLayer)
        }else{
            VisibleColorLayer.removeFromSuperlayer()
        }
    }
    
    public func ChartPlot(dataArray: [CGFloat], specStart: Int, specEnd: Int) {
        // remove previous chart
        removePreviousChart()
        
        // draw bound of chart
        drawChartBound(specStart: specStart, specEnd: specEnd, labelLine: 5)
        
        // add color layer
        let location = GradientLayerLocation(specStart: specStart, specEnd: specEnd)
        VisibleColorLayer.locations = location
        chartPlaceUIView.layer.addSublayer(VisibleColorLayer)
        
        // draw chart line
        let pointNum: Int = dataArray.count
        let pointWidth: CGFloat = viewWidth / CGFloat(pointNum + 1)
        ChartLine.move(to: CGPoint(x: 0, y: viewHeight))
        // need to add a new path for mask for VisibleColorLayer
        // TODO: skip start and end code
        for i in 4...pointNum-5 {
            ChartLine.addLine(to: CGPoint(x: pointWidth * CGFloat(i+1),
                                          y: viewHeight*(1 - dataArray[i] / 255)))
        }
        ChartLine.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        
        // mask for VisibleColorLayer
        ChartLine.close()
        maskLayer.path = ChartLine.cgPath
        VisibleColorLayer.mask = maskLayer
        
        ChartLineLayer.path = ChartLine.cgPath
        ChartLineLayer.fillColor = UIColor.clear.cgColor
        ChartLineLayer.strokeColor = UIColor.black.cgColor
        ChartLineLayer.lineWidth = 0.3
        
        chartPlaceUIView.layer.addSublayer(ChartLineLayer)
        // self.addSubview(chartPlaceUIView)
    }
    
    
    /**
     Clean the previous chart.
     */
    private func removePreviousChart() {
        VisibleColorLayer.removeFromSuperlayer()
        ChartLine.removeAllPoints()
        ChartLineLayer.removeFromSuperlayer()
        ChartLineLayer = CAShapeLayer()
    }
    
    private func drawChartBound(specStart: Int, specEnd: Int, labelLine: CGFloat){
        // Bound line
        ChartBound.move(to: CGPoint(x: 0, y: 0))
        ChartBound.addLine(to: CGPoint(x: viewWidth, y: 0))
        ChartBound.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        ChartBound.addLine(to: CGPoint(x: 0, y: viewHeight))
        ChartBound.addLine(to: CGPoint(x: 0, y: 0))
        
        // Y-axis label
        var labelY: CGFloat
        for yValue in stride(from: 0, to: 256, by: 20) {
            labelY = CGFloat(256 - yValue) / 256 * viewHeight
            ChartBound.move(to: CGPoint(x: 0, y: labelY))
            ChartBound.addLine(to: CGPoint(x: -labelLine, y: labelY))
            
            // Place y-axis label
            let yPointLabel = AxisPointLabel(frame: CGRect(x: -viewX,
                                                           y: labelY - axisLabelHeight / 2,
                                                           width: axisLabelWidth,
                                                           height: axisLabelHeight))
            
            // yPointLabel.setText(text: String(yValue))
            yPointLabel.text = "\(yValue)"
            YAxisIndices.append(yPointLabel)
            
            chartPlaceUIView.addSubview(yPointLabel)
        }
        
        // 高度要拉長 這樣才放得下 label
        // X-axis label
        var labelX: CGFloat
        for i in (specStart / 50) ... (specEnd / 50){
            labelX = CGFloat(50 * i - specStart) / CGFloat(specEnd - specStart) * viewWidth
            ChartBound.move(to: CGPoint(x: labelX, y: viewHeight))
            ChartBound.addLine(to: CGPoint(x: labelX, y: viewHeight + labelLine))
            
            // Place x-axis label
            let xPointLabel = AxisPointLabel(frame: CGRect(x: labelX - axisLabelWidth / 2,
                                                           y: viewHeight + labelLine,
                                                           width: axisLabelWidth,
                                                           height: axisLabelHeight))
            xPointLabel.text = "\(50 * i)"
            XAxisIndices.append(xPointLabel)
            chartPlaceUIView.addSubview(xPointLabel)
        }
        // ChartBound.move(to: CGPoint(x: viewWidth, y: viewHeight))
        // ChartBound.addLine(to: CGPoint(x: viewWidth, y: viewHeight + labelLine))
        ChartBound.lineWidth = 1
        
        boundLayer.path = ChartBound.cgPath
        boundLayer.fillColor = UIColor.clear.cgColor
        boundLayer.strokeColor = UIColor.black.cgColor
        chartPlaceUIView.layer.addSublayer(boundLayer)
    }
    
    func GradientLayerLocation(specStart: Int, specEnd: Int) -> Array<NSNumber>{
        var LocationArray: Array<Float> = [ 0, 0, 0, 0, 0, 0, 0]
        let GradSpec: Array<Int> = [300, 450, 495, 570, 590, 620, 750]
        for i in 0...GradSpec.count-1 {
            LocationArray[i] = Float(GradSpec[i] - specStart) / Float(specEnd - specStart)
        }
        return LocationArray as [NSNumber]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

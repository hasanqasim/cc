//
//  SinView.swift
//  TechnicalChallengeCC
//
//  Created by Hasan Qasim on 11/1/21.
//

import UIKit

class SinView: UIView {
    
    var graphWidth: CGFloat = 0.075
    var amplitude: CGFloat = 0.35
    var frequency: CGFloat = 1
    var periods: CGFloat = 0 {didSet {setNeedsDisplay()}}
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let origin = CGPoint(x: (width * 0.1) - 16, y: height/2 + 16)
      
        let path = UIBezierPath()
        path.move(to: origin)
        
        for degree in stride(from: 0, through: 360.0 * periods, by: 1) {
            let radians = Double(degree) * Double.pi / 180
            let x = origin.x + (CGFloat(degree/(360.0*frequency)) * width * graphWidth)
            let y = origin.y - CGFloat(sin(radians - Double.pi/2)) * amplitude * height
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.lineWidth = 2
        UIColor.systemGreen.setStroke()
        path.stroke()
        
        drawYAxis(rect)
        drawXAxis(rect)
        drawAllHourlyAxis(rect)
    }
    
}

//MARK: Drawing axis code
extension SinView {
    
    func drawYAxis(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 64, y: 64))
        path.addLine(to: CGPoint(x: 64, y: rect.height - 36))
        path.lineWidth = 2
        UIColor.white.setStroke()
        path.stroke()
    }
    
    func drawXAxis(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 64, y: rect.height - 36))
        path.addLine(to: CGPoint(x: rect.width - 16, y: rect.height - 36))
        path.lineWidth = 2
        UIColor.white.setStroke()
        path.stroke()
    }
    
    func drawHourlyAxis(_ rect: CGRect, xCoordinate: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xCoordinate, y: 64))
        path.addLine(to: CGPoint(x: xCoordinate, y: rect.height - 30))
        path.lineWidth = 0.4
        UIColor.white.setStroke()
        path.stroke()
    }
    
    func drawAllHourlyAxis(_ rect: CGRect) {
        var xC: CGFloat = 124
        for _ in 1...12 {
            drawHourlyAxis(rect, xCoordinate: xC)
            xC += 60
        }
    }
}

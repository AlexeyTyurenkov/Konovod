//
//  ChessView.swift
//  Konovod
//
//  Created by Aleksey Tyurenkov on 12/25/16.
//  Copyright © 2016 com.ovt. All rights reserved.
//

import Cocoa

class ChessView: NSView {

    var knight:NSView = NSImageView(image: #imageLiteral(resourceName: "normal_white_knight"))
    var currentKnightPosition: Int? = 4
    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let less = width < height ? width : height
        let side = less / 8
        let context = NSGraphicsContext.current()?.cgContext
        knight.removeFromSuperview()
        for i in 0..<64
        {
            let row = i / 8
            let col = i % 8
            let lastCol = col == 7
            let currentWidth = lastCol ? side - 2 : side
            let currentHeight = row == 7 ? side - 2 : side
            let x = 1.0 + CGFloat(col) * side
            let y = 1.0 + CGFloat(row) * side
            let rect = NSRect(x: x, y: y, width: currentWidth, height: currentHeight)
            let path = CGMutablePath()
            path.addRect(rect)
            let borderColor = NSColor.red.cgColor
            var fillColorUI = NSColor.blue
            if (row + col) % 2 == 0
            {
                fillColorUI = fillColorUI.withAlphaComponent(0.3)
            }
            let fillColor = fillColorUI.cgColor
            context?.setStrokeColor(borderColor)
            context?.setFillColor(fillColor)
            context?.addPath(path)
            context?.drawPath(using: .fillStroke)
        }
        if let knightPosition = currentKnightPosition
        {
            knight.frame = rectForIndex(index: knightPosition)
            self.addSubview(knight)
        }
    }
    
    override func mouseDown(with event: NSEvent)
    {
        let location = event.locationInWindow
        let point = convert(location, from: nil)
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let less = width < height ? width : height
        let side = less / 8
        let x = Int(point.x / side)
        let y = Int(point.y / side)
        
        let index = y * 8 + x
        NSLog("Log %i", index)
        
    }
    
    func rectForIndex(index i:Int) -> CGRect
    {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let less = width < height ? width : height
        let side = less / 8
        let row = i / 8
        let col = i % 8
        let x = 1.0 + CGFloat(col) * side
        let y = 1.0 + CGFloat(row) * side
        let rect = NSRect(x: x, y: y, width: side, height: side)
        return rect
    }
    
    
    
}

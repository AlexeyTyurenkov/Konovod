//
//  ChessMoverViewController.swift
//  Konovod
//
//  Created by Aleksey Tyurenkov on 12/25/16.
//  Copyright © 2016 com.ovt. All rights reserved.
//

import Cocoa

class ChessMoverViewController: NSViewController {

    @IBOutlet weak var chessView: ChessView!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear()
    {
        showKnight(indexes: [1,2,3,4])
    }
    
    
    func showKnight(indexes: [Int])
    {
        guard let first = indexes.first else { return }
        var frame = chessView.rectForIndex(index: first)
        frame.origin.x += chessView.frame.origin.x
        frame.origin.y += chessView.frame.origin.y
        let knight = NSImageView(frame: frame)
        
        knight.image = #imageLiteral(resourceName: "normal_white_knight")
        chessView.addSubview(knight)
        animateMoves(knight: knight, indicies: Array(indexes.dropFirst()))
    }
    
    func animateMoves(knight: NSView, indicies: [Int])
    {
        guard let move = indicies.first else { return }
        chessView.wantsLayer = true;
        
        // Set the layer redraw policy. This would be better done in the initialization method of a NSView subclass instead of here.
        chessView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 1
            var frame = chessView.rectForIndex(index: move)
            frame.origin.x += chessView.frame.origin.x
            frame.origin.y += chessView.frame.origin.y
            knight.frame = frame
            chessView.setNeedsDisplay(chessView.frame)
        }, completionHandler: {
            self.animateMoves(knight: knight, indicies: Array(indicies.dropFirst()))
        }
        )
    }
    
}

//
//  ChessMoverViewController.swift
//  Konovod
//
//  Created by Aleksey Tyurenkov on 12/25/16.
//  Copyright © 2016 com.ovt. All rights reserved.
//

import Cocoa

class ChessMoverViewController: NSViewController, KnightSolverDelegate {

    @IBOutlet weak var chessView: ChessView!
    
    @IBOutlet weak var fitnessLabel: NSTextField!
    @IBOutlet weak var generation: NSTextField!
    @IBOutlet weak var final: NSTextField!
    var solver: KnightMoveSolver = GeneticSearch()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear()
    {
        solver.delegate = self
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
        {
            self.solver.run()
        }
    }
    
    
    func showSolution(solution: [Int], final: Bool, generation: Int, fitness: String)
    {
        DispatchQueue.main.async {
            self.chessView.showMoves(moves: solution)
            self.final.isHidden = !final
            self.generation.stringValue = "\(generation)"
            self.fitnessLabel.stringValue = fitness
        }
        
    }

    
}

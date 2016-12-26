//
//  GeneticSearch.swift
//  Konovod
//
//  Created by Aleksey Tyurenkov on 12/25/16.
//  Copyright © 2016 com.ovt. All rights reserved.
//

import Foundation

protocol KnightSolverDelegate: class
{
    func showSolution(solution:[Int], final: Bool, generation: Int, fitness: String)
    
}

protocol KnightMoveSolver
{
    func run()
    weak var delegate: KnightSolverDelegate? { get set }
}


class Solution
{
    private var moves:[Int] = []
    private var fitness: UInt = 0
    
    func calculateFittnessWith(function: ([Int])->(UInt))
    {
        fitness = function(moves)
    }
    
    static var `default`: Solution
    {
        let solution = Solution()
        for i in 0..<64
        {
            solution.moves.insert(i, at: i)
        }
        return solution
    }
    
    func fitter(other: Solution) -> Bool
    {
        return self.fitness > other.fitness
    }
    
    var reproduced: Solution
    {
        let solution = Solution()
        for (index, move) in moves.enumerated()
        {
            solution.moves.insert(move, at: index)
        }
        if arc4random_uniform(20) == 0
        {
            let fisrt = Int(arc4random_uniform(UInt32(moves.count)))
            let second = Int(arc4random_uniform(UInt32(moves.count)))
            let temp = moves[fisrt]
            moves[fisrt] = moves[second]
            moves[second] = temp
        }
        return solution
    }
    
    var solution: [Int]
    {
        return Array(moves.dropLast(moves.count - Int(fitness)))
    }
    
    var fitnessNormalized: String
    {
        return "\(fitness)"
    }
    
    var matrix: [Set<Int>]
    {
        var result:[Set<Int>] = []
        for i in 0..<64
        {
            let index = moves.index(of: i)!
            var prevIndex = index - 1
            if prevIndex == -1
            {
                prevIndex = 63
            }
            var nextIndex = index + 1
            if nextIndex == 64
            {
                nextIndex = 0
            }
            result.insert([prevIndex, nextIndex], at: i)
        }
        return result
    }
    
    
    func crossover(other: Solution) -> Solution
    {
        let result = Solution()
        let matrix1 = self.matrix
        let matrix2 = other.matrix
        var compaundMatrix:[Set<Int>] = []
        for i in 0..<64
        {
            compaundMatrix.append(matrix1[i].union(matrix2[i]))
        }
        var choosen = self.moves.first!
        var i = 0
        repeat
        {
            result.moves.insert(choosen, at: i)
            compaundMatrix = compaundMatrix.map { var m = $0; m.remove(choosen); return m }
            if !compaundMatrix[choosen].isEmpty
            {
                var minSize = Int.max
                var minList = choosen
                for item in compaundMatrix[choosen]
                {
                        if compaundMatrix[item].count < minSize
                        {
                            minSize = compaundMatrix[item].count
                            minList = item
                        }
                }
                choosen = minList
            }
            else
            {
                repeat
                {
                    choosen = Int(arc4random_uniform(64))
                }
                while(result.moves.contains(choosen))
            }
            i += 1
        }
        while i < 64
        
        return result
    }
}


class GeneticSearch: KnightMoveSolver
{
    weak var delegate: KnightSolverDelegate?
    var generation = 0
    var solutions: [Solution] = []
    var fitnessCalculator = ChessFitnessFunction().calculation
    
    func canExit() -> Bool
    {
        return generation > 10000
    }
    
    func run()
    {
        solutions.append(Solution.default)
        var best = solutions.first!
        
        repeat
        {
            generation += 1
            //CalcFittness
            solutions.forEach{ $0.calculateFittnessWith(function: fitnessCalculator)}
            //Selection
            var elite = solutions.sorted(by: { $0.0.fitter(other: $0.1)})
            if elite.count > 50
            {
                elite = Array(elite.dropLast(elite.count - 50))
            }
            var eliteChilds:[Solution] = []
            //Crossing over
            for solution in elite {
                let index = Int(arc4random_uniform(UInt32(solutions.count)))
               // eliteChilds.append(solution.crossover(other: solutions[index]))
            }
            solutions = elite
            //Reproduction
            for solution in elite
            {
                solutions.append(solution.reproduced)
            }
            solutions.append(contentsOf: eliteChilds)
            best = elite.first!
            if generation%10 == 0
            {
                delegate?.showSolution(solution: best.solution, final: false, generation: generation, fitness: best.fitnessNormalized)
            }
        }
        while(!canExit())
        
        delegate?.showSolution(solution: best.solution, final: true, generation: generation, fitness: best.fitnessNormalized)
    }
}

class ChessFitnessFunction
{
    func calculation(moves: [Int]) -> UInt
    {
        guard moves.count == 64 else { return 0 }
        var fitness: UInt = 0
        for i in 0..<63
        {
            let j = i + 1
            let (xI,yI) = (moves[i]%8, moves[i]/8)
            let (xJ,yJ) = (moves[j]%8, moves[j]/8)
            let absX = abs(xI - xJ)
            let absY = abs(yI - yJ)
            guard (absX != 0) else { break }
            guard (absY != 0) else { break }
            guard (absX + absY == 3) else { break }
            fitness += 1
        }
        return fitness
    }
}



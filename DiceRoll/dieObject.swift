//
//  die.swift
//  DiceRoll
//
//  Created by Andrew Almasi on 8/17/22.
//

import Foundation
import Combine

class die: ObservableObject {
    // Dice attributes
    @Published var leftDice = 1
    @Published var rightDice = 1
    @Published var res = 2 // Result of dice rolls combined (left + right)
    
    // TIMER
    @Published var counter = 0 // Used to keep track of timer and reset animation
    @Published var timer: Timer.TimerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
    @Published var connectedTimer: Cancellable? = nil // Combine necessary
    
    @Published var rollType = "Four" // Changes with picker
    @Published var ogl = 1 // OG VALUES
    @Published var ogr = 1 // OG VALUES
    let typesOfRolls = ["Four", "Six"] // Array of sided dice
    
    // Decides which sided dice to use
    func rollType(type: String) -> Int {
        var t = 5
        switch type {
        case "Four": t = 5;
        case "Six": t = 7;
        default:
            t = 5
        }
        return t
    }
    
    // Initializing timer at first roll
    func instantiateTimer() {
        self.timer = Timer.publish(every: 0.3, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }
    
    // Cancelling timer
    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
    
    // Restarting timer for every time after 0th
    func restartTimer() {
        self.counter = 0
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
}


//
//  DiceViews.swift
//  DiceRoll
//
//  Created by Andrew Almasi on 8/17/22.
//

import SwiftUI

// Dice Image View
// Handles recieving timer input and changing dice images from assets
struct DiceView: View {
    @ObservedObject var dice: die

    var body: some View {
        HStack(spacing: 30){
            Group{
            Image("\(dice.leftDice)")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
            Image("\(dice.rightDice)")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
            }
            .onReceive(dice.timer) { _ in
                if dice.counter == 2 {
                    dice.cancelTimer()
                    dice.leftDice = dice.ogl // Using OG Values
                    dice.rightDice = dice.ogr // Using OG Values
                } else {
                    // Dice rolling animation
                    dice.leftDice = Int.random(in: 1..<dice.rollType(type: dice.rollType))
                    dice.rightDice = Int.random(in: 1..<dice.rollType(type: dice.rollType))
                    dice.counter += 1
                }
            }
        }
    }
}

// Dice Picker
// Handles the number of sides the dice has
struct DicePicker: View {
    
    @ObservedObject var dice: die
    
    var body: some View {
        Picker("Type of dice", selection: $dice.rollType) {
            ForEach(dice.typesOfRolls, id: \.self) {
                Text($0) // Text from typesOfRolls array ("Four", "Six")
            }
        }
        .pickerStyle(.segmented)
    }
}


// Roll Dice Button
// Adds newRoll instance to moc, handles haptics, timer, final result, and saving moc
struct RollDiceButton: View {

    @Environment(\.managedObjectContext) var moc
    @ObservedObject var dice: die
    @State private var hasInst = false // Has instantiated? (timer)
    
    var body: some View {
            Button("Roll"){
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred() // Haptic (no warmup)
                let newRoll = Dice(context: moc) // Establishing instance
                newRoll.type = dice.rollType
                dice.leftDice = Int.random(in: 1..<dice.rollType(type: newRoll.type!))
                dice.ogl = dice.leftDice // OG Left Dice to set after animation
                dice.rightDice = Int.random(in: 1..<dice.rollType(type: newRoll.type!))
                dice.ogr = dice.rightDice // OG Right Dice to set after animation
                dice.res = dice.leftDice + dice.rightDice
                newRoll.result = Int16(dice.res)
                newRoll.date = Date.now // DD / MM
                print("result: \(dice.res)") // For Testing purposes
                try? moc.save() // Save instance
                if !hasInst {
                    dice.instantiateTimer()
                    hasInst = true
                } else {
                    dice.restartTimer()
                }
            }
            .buttonStyle(.bordered)
    }
}


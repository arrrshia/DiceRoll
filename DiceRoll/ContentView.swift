//
//  ContentView.swift
//  DiceRoll
//
//  Created by Andrew Almasi on 8/16/22.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var diceRolls: FetchedResults<Dice>
    
    @StateObject var dice = die()
        
    var body: some View {
        NavigationView{
            ZStack {
                    VStack(spacing: 50){
                        DiceView(dice: dice)
                            .padding()
                        VStack(spacing: 20){
                            HStack(spacing: 40){
                                DicePicker(dice: dice)
                                RollDiceButton(dice: dice)
                            }
                            .padding(.horizontal)
                        List{
                            ForEach(diceRolls) {roll in
                                HStack{
                                Text("\(roll.result)")
                                    Spacer()
                                Text(roll.type!)
                                    Spacer()
                                    Text((roll.date?.formatted(.dateTime.day().month())) ?? "\(Date.distantPast)") // DD / MM
                                }
                            }
                            .onDelete(perform: deleteRolls) // at offset
                        }
                    }
                }
            }
            .navigationTitle("Dice")
        }
    }
    
    func deleteRolls(at offsets: IndexSet){
        for offset in offsets{
            let roll = diceRolls[offset]
            moc.delete(roll)
        }
        try? moc.save()
    }
}

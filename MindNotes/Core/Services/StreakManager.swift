//
//  StreakManager.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 27/08/25.
//

import Foundation

class StreakManager {
    static let shared = StreakManager()
    private let defaults = UserDefaults(suiteName: "group.mindnotes")!
    
    private let lastDateKey = "lastEntryDate"
    private let streakKey = "streakCount"
    
    func registerEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = defaults.object(forKey: lastDateKey) as? Date {
            
            // Se o streak é 0, já coloca
            if currentStreak() == 0 {
                let newStreak = currentStreak() + 1
                defaults.set(newStreak, forKey: streakKey)

            }
            
            let daysDiff = Calendar.current.dateComponents([.day], from: lastDate, to: today).day ?? 0
            
            if daysDiff == 1 {
                // aumentou streak
                let newStreak = currentStreak() + 1
                defaults.set(newStreak, forKey: streakKey)
            } else if daysDiff > 1 {
                // quebrou streak
                defaults.set(1, forKey: streakKey)
            }
        } else {
            defaults.set(1, forKey: streakKey)
        }
        
        defaults.set(today, forKey: lastDateKey)
    }
    
    func currentStreak() -> Int {
        return defaults.integer(forKey: streakKey)
    }
}

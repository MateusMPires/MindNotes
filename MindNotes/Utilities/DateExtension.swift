//
//  DateExtension.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 04/09/25.
//

import Foundation

private func dayTitle(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    
    if Calendar.current.isDateInToday(date) {
        return "Hoje"
    } else if Calendar.current.isDateInYesterday(date) {
        return "Ontem"
    } else {
        formatter.dateFormat = "E, dd MMM"
        return formatter.string(from: date)
    }
}

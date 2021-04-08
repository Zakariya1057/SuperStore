//
//  DateWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class DateWorker {
    func formatDate(date: String) -> Date {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.date(from: date) ?? Date()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM y"
        return dateFormatter.string(from: date)
    }
}

extension DateWorker {
    func dateDiff(date: Date) -> Int {
        let calendar = Calendar.current

        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day!
    }
}

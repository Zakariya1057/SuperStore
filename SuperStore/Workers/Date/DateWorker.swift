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
        return dateFormat.date(from: date)!
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        return dateFormatter.string(from: date)
    }
}

extension DateWorker {
    func dateDiff(date: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
}

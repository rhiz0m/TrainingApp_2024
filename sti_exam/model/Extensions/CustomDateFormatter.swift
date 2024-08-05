//
//  DateFormatter.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-05-08.
//

import Foundation

struct CustomDateFormatter {
   func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

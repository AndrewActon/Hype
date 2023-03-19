//
//  DateExtension.swift
//  Hype
//
//  Created by Andrew Acton on 3/18/23.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}

//
//  DateFormatter+Extras.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/3/23.
//

import Foundation


extension DateFormatter {
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

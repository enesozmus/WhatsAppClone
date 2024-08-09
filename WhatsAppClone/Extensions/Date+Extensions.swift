//
//  Date+Extensions.swift
//  WhatsAppClone
//
//  Created by enesozmus on 9.08.2024.
//

import Foundation

extension Date {
    
    /// if today: 3:30 PM
    /// if yesterday returns Yesterday
    /// 02/15/24
    var dayOrTimeRepresentation: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
            
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    /// 3:30 PM
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: self)
        return formattedTime
    }
}

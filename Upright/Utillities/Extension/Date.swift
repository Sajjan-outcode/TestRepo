import Foundation

extension Date {
    
    static func getDate(from stringDate: String, having format: String) -> Date? {
         let formatter = DateFormatter()
         formatter.dateFormat = format
         return formatter.date(from: stringDate)
     }
     
     func formattedDate(with format: String) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = format
         formatter.timeZone = .current
         return formatter.string(from: self)
     }
    
     static func getDateTimeString(from stringDate: String, with format: String, to outputFormat: String) -> String? {
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en_US_POSIX")
         formatter.timeZone = .current
         formatter.dateFormat = format
         guard let date = formatter.date(from: stringDate) else { return nil }
         formatter.dateFormat = outputFormat
         return formatter.string(from: date)
     }
    
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year,
                                             value: years, to: self)!
    }
    
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute,
                                             value: minutes, to: self)!
    }
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    func snap() -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let minutes =  calendar.component(.minute, from: self)
        var newDate = self
        if minutes <= 15 {
            newDate = self.addingMinutes(-minutes)
        } else if minutes > 15 && minutes <= 30 {
            newDate = self.addingMinutes(30-minutes)
        } else if minutes > 30 && minutes <= 45 {
            newDate = self.addingMinutes(30 - minutes)
        } else {
            newDate = self.addingMinutes(60 - minutes)
        }
        return newDate
    }
    
}

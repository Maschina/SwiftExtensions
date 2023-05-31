import Foundation

public extension Date {
	init(month: Int, day: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
		var dateComponents = DateComponents()
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.year = year
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		dateComponents.timeZone = .current
		dateComponents.calendar = .current
		self = Calendar.current.date(from: dateComponents) ?? Date()
	}
	
	func localDate() -> Date {
		let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
		guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {
			return self
		}
		return localDate
	}
	
	var firstDayOfWeek: Date {
		var beginningOfWeek = Date()
		var interval = TimeInterval()
		
		_ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)
		return beginningOfWeek
	}
	
	func addWeeks(_ numWeeks: Int) -> Date {
		var components = DateComponents()
		components.weekOfYear = numWeeks
		
		return Calendar.current.date(byAdding: components, to: self)!
	}
	
	func weeksAgo(_ numWeeks: Int) -> Date {
		return addWeeks(-numWeeks)
	}
	
	func addDays(_ numDays: Int) -> Date {
		var components = DateComponents()
		components.day = numDays
		
		return Calendar.current.date(byAdding: components, to: self)!
	}
	
	func daysAgo(_ numDays: Int) -> Date {
		return addDays(-numDays)
	}
	
	func addHours(_ numHours: Int) -> Date {
		var components = DateComponents()
		components.hour = numHours
		
		return Calendar.current.date(byAdding: components, to: self)!
	}
	
	func hoursAgo(_ numHours: Int) -> Date {
		return addHours(-numHours)
	}
	
	func addMinutes(_ numMinutes: Double) -> Date {
		return self.addingTimeInterval(60 * numMinutes)
	}
	
	func minutesAgo(_ numMinutes: Double) -> Date {
		return addMinutes(-numMinutes)
	}
	
	var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}
	
	var endOfDay: Date {
		let cal = Calendar.current
		var components = DateComponents()
		components.day = 1
		return cal.date(byAdding: components, to: self.startOfDay)!.addingTimeInterval(-1)
	}
	
	var zeroBasedDayOfWeek: Int? {
		let comp = Calendar.current.component(.weekday, from: self)
		return comp - 1
	}
	
	func hoursFrom(_ date: Date) -> Double {
		return Double(Calendar.current.dateComponents([.hour], from: date, to: self).hour!)
	}
	
	func daysBetween(_ date: Date) -> Int {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
		
		return components.day!
	}
	
	var percentageOfDay: Double {
		let totalSeconds = self.endOfDay.timeIntervalSince(self.startOfDay) + 1
		let seconds = self.timeIntervalSince(self.startOfDay)
		let percentage = seconds / totalSeconds
		return max(min(percentage, 1.0), 0.0)
	}
	
	var numberOfWeeksInMonth: Int {
		let calendar = Calendar.current
		let weekRange = (calendar as NSCalendar).range(of: NSCalendar.Unit.weekOfYear, in: NSCalendar.Unit.month, for: self)
		
		return weekRange.length
	}
}

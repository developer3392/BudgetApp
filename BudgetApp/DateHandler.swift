//
//  DateHandler.swift
//  This is a helper class used to help manage/handle the date component information
//  stored within the UserDefaults class. It is an interface for getting a date
//  object from components, calculating end/new start dates, and anything else 
//  regarding the period date.
//
//  Created by Charles Bucher on 6/23/17.
//  Copyright © 2017 Chary. All rights reserved.
//

import Foundation

class DateHandler
{
    
    //MARK: Properties
    private var dayComponent: Int
    private var monthComponent: Int
    private var yearComponent: Int
    
    //MARK: Initialization
    init()
    {
        // Initialize properties with values from User Defaults
        self.monthComponent = UserDefaults.standard.integer(forKey: "startDateMonth")
        self.dayComponent = UserDefaults.standard.integer(forKey: "startDateDay")
        self.yearComponent = UserDefaults.standard.integer(forKey: "startDateYear")
    }
    
    //MARK: Methods
    // Returns the startDate as a Date type from the class components
    func determineStartDateFromComponents() -> Date
    {
        var dateComponents = DateComponents()
        
        // Determine components
        dateComponents.month = UserDefaults.standard.integer(forKey: "startDateMonth")
        dateComponents.day = UserDefaults.standard.integer(forKey: "startDateDay")
        dateComponents.year = UserDefaults.standard.integer(forKey: "startDateYear")
        
        // Create date from components
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        let returnDate = gregorianCalendar.date(from: dateComponents)
        _ = DateFormatter()
        
        return returnDate!
    }
    
    // Returns a Date type object based on components passed in
    func determineComponentsFromDate(dateToParse: Date) -> (month: Int, day: Int, year: Int)
    {
        // Find componenets from date
        let myCalendar = Calendar(identifier: .gregorian)
        let month = myCalendar.component(.month, from: dateToParse)
        let day = myCalendar.component(.day, from: dateToParse)
        let year = myCalendar.component(.year, from: dateToParse)
        
        return (month, day, year)
    }
    
    // Parses out a passed in Date type into its 3 componenets
    func determineDateFromComponents(month: Int, day: Int, year: Int) -> Date
    {
        var dateComponents = DateComponents()
        
        // Determine components
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        
        // Create date from components
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        let returnDate = gregorianCalendar.date(from: dateComponents)
        _ = DateFormatter()
        
        return returnDate!
    }
    
    // Returns either the end period date, or the new period's start date
    func calculateNewDate(periodType pType: String, periodEnd pEnd: Bool) -> Date
    {
        // Components of the new calculate end date
        var newMonth: Int = self.monthComponent
        var newDay: Int = self.dayComponent
        var newYear: Int = self.yearComponent
        
        // If the periodEnd flag was set, this integer will be 1
        var isPeriodEnd: Int = 0
        
        if pEnd
        {
            isPeriodEnd = 1
        }
        
        switch (pType)
        {
        case "Weekly":
            // Add 7 to the current day
            newDay = (newDay + 7 - isPeriodEnd) % self.monthDays(month: self.monthComponent)
            // Mod = 0 means end of month. Set accordingly
            if newDay == 0
            {
                newDay = self.monthDays(month: self.monthComponent)
            }
            // Mod < 0 means entered new month. Increment month
            else if newDay - 7 < 0
            {
                newMonth = (newMonth + 1) % 12
                // Check to make sure month didn't overflow. If it did, increase year by 1, and wrap month
                // Mod = 0 means end of year. Set accordingly
                if newMonth == 0
                {
                    newMonth = 12
                }
                // Mod = 1 means new year
                else if newMonth == 1
                {
                    newYear += 1
                }
            }
            
            break
        
        case "Biweekly":
            // Same logic as above
            newDay = (newDay + 14 - isPeriodEnd) % self.monthDays(month: self.monthComponent)

            if newDay == 0
            {
                newDay = self.monthDays(month: self.monthComponent)
            }
            else if newDay - 14 < 0
            {
                newMonth = (newMonth + 1) % 12

                if newMonth == 0
                {
                    newMonth = 12
                }
                else if newMonth == 1
                {
                    newYear += 1
                }
            }

            break
            
        case "Monthly":
            
            // Calculate the new month start
            if !pEnd
            {
                newMonth = (newMonth + 1) % 12
                
                if newMonth == 0
                {
                    newMonth = 12
                }
                else if newMonth == 1
                {
                    newYear += 1
                }
            }
            // Calculate the end of the month period
            else
            {
                // If the period starts on the 1st, it will end on the end of the month
                if newDay == 1
                {
                    // Calculate the end of the month
                    newDay = monthDays(month: self.monthComponent)
                }
                else
                {
                    // End of month will be one day previous & one month foward
                    newDay -= 1
                    // Calculate what the new month would be
                    newMonth = (newMonth + 1) % 12
                    
                    if newMonth == 0
                    {
                        newMonth = 12
                    }
                    else if newMonth == 1
                    {
                        newYear += 1
                    }
                }
            }
            
            break
            
        default:
            print("This should never happen, as the only values passed in are from periodTypeList")
            break
            
        }
        
        // Return the generated date
        return self.determineDateFromComponents(month: newMonth, day: newDay, year: newYear)
    }
    
    // Updates the start date
    func updateStartDate()
    {
        // Find new start date date. Note the periodEnd flag is false
        let newStartDate = self.calculateNewDate(periodType: UserDefaults.standard.string(forKey: "periodType")!, periodEnd: false)
        
        // Parse out the new start date components
        let newStartDateComponents = self.determineComponentsFromDate(dateToParse: newStartDate)
        
        // Set the start date componenets based off the new start date componenets
        UserDefaults.standard.set(newStartDateComponents.month, forKey: "startDateMonth")
        UserDefaults.standard.set(newStartDateComponents.day, forKey: "startDateDay")
        UserDefaults.standard.set(newStartDateComponents.year, forKey: "startDateYear")
    }
    
    // Returns the number of days in each month
    func monthDays(month: Int) -> Int
    {
        switch (month)
        {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 2:
            return 28
        case 4, 6, 9, 11:
            return 30
        default:
            print("This should never happen, as there are only 12 months")
            return 0
        }
    }
}

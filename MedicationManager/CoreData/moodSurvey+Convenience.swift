//
//  moodSurvey+Convenience.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/5/23.
//

import CoreData

extension MoodSurvey {
    
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}

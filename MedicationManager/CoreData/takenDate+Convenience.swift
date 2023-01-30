//
//  takenDate+Convenience.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/5/23.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}

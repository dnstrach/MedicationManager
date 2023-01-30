//
//  moodSurveyController.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/5/23.
//

import CoreData

class MoodSurveyController {
    
    static let shared = MoodSurveyController()
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: Strings.moodSurveyEntityType)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        let afterPredicate = NSPredicate(format: "date > %@", startOfDay as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", startOfDay as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        return request
    }()
    
    var todaysMoodSurvey: MoodSurvey?
    
    // CRUD
    
    func createMoodSurvey(mentalState: String) {
        let moodSurvey = MoodSurvey(mentalState: mentalState, date: Date())
        todaysMoodSurvey = moodSurvey
        CoreDataStack.saveContext()
    }
    
    func fetchTodaysSurveys() -> MoodSurvey? {
        guard let todaysMoodSurvey = try? CoreDataStack.context.fetch(fetchRequest).first
        else { return nil }
        
        self.todaysMoodSurvey = todaysMoodSurvey
        return todaysMoodSurvey
    }
    
    private func update(newMentalState: String) {
        guard let todayMoodSurvey = todaysMoodSurvey
        else { return }
        
        todayMoodSurvey.mentalState = newMentalState
        CoreDataStack.saveContext()
    }
    
    func didTapMoodEmoji(_ emoji: String) {
        if todaysMoodSurvey != nil {
            update(newMentalState: emoji)
        } else {
            createMoodSurvey(mentalState: emoji)
        }
    }
}

//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/3/23.
//

import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    let notificationScheduler = NotificationScheduler()
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityType)
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    //sections is an array of two arrays
    var sections: [[Medication]] { [notTakenMeds, takenMeds] }
    private var notTakenMeds: [Medication] = []
    private var takenMeds: [Medication] = []
    //var medications: [Medication] = []
    
    //CRUD
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        
        //schedule notifications
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func fetchMedications() {
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        
        //filter is looping through array
        takenMeds = medications.filter { $0.wasTakenToday() }
        //! for opposite
        notTakenMeds = medications.filter { !$0.wasTakenToday() }
        //self.medications = medications
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        
        //clear notification to change time
        notificationScheduler.cancelNotifications(for: medication)
        //add new time
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func markMedicationTaken(medication: Medication, wasTaken: Bool) {
        //moving taken med into correct array
        if wasTaken {
            //TakenDate is from creating TakenDate entity and its parameters/properties
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            //mutable or else cannot remove date
            let mutableTakenDates = medication.mutableSetValue(forKey: Strings.takenDatesKey)
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { takenDate in
                guard let date = takenDate.date
                else { return false }
                
                //find date by day rather than precise date including seconds
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    //inserts not taken at bottom of list
                    notTakenMeds.append(medication)
                }
            }
        }
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(withID id: String) {
        //capturing taken med
        guard let medication = notTakenMeds.first(where: { $0.id == id })
        else { return }
        
//        TakenDate(date: Date(), medication: medication)
//        CoreDataStack.saveContext()
        
        markMedicationTaken(medication: medication, wasTaken: true)
    }
    
    func deleteMedication(_ medication: Medication) {
        //delete medication from array
        //checking both arrays
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        } else if let index = takenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        }
        //delete medication from CoreData
        CoreDataStack.context.delete(medication)
        //save new data or else med will still show when stopping and reentering app
        CoreDataStack.saveContext()
        //cancel notification
        notificationScheduler.cancelNotifications(for: medication)
    }
}

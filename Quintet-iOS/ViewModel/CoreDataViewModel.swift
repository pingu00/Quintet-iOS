//
//  DataController.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/28.
//

import Foundation
import CoreData

class CoreDataViewModel : ObservableObject {
    let container : NSPersistentContainer
    @Published var savedEntity : [QuintetData] = []
    
    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Failed to load the core data \(error.localizedDescription)")
            }
        }
        fetchQuintetData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchQuintetData()
            print ("Data saved")
        } catch {
            print ("Failed saved Data")
        }
    }
    func fetchQuintetData() {
        let request = NSFetchRequest<QuintetData>(entityName: "QuintetData")
        do {
            savedEntity = try container.viewContext.fetch(request)
        }
        catch let error {
            print("Error Fetching,. \(error)")
        }
    }
    func addOnlyPoint(_ workPoint: Int,_ healthPoint : Int ,_ familyPoint: Int,_ relationshipPoint : Int,_  assetPoint : Int ) {
        let quintetData = QuintetData(context: container.viewContext)
        quintetData.date = Date()
        quintetData.workPoint = Int64(workPoint)
        quintetData.healthPoint = Int64(healthPoint)
        quintetData.familyPoint = Int64(familyPoint)
        quintetData.relationshipPoint = Int64(relationshipPoint)
        quintetData.assetPoint = Int64(assetPoint)
        
        saveData()
    }
    func addPointWithNote(_ workPoint: Int,_ healthPoint : Int ,_ familyPoint: Int,_ relationshipPoint : Int,_  assetPoint : Int,_ workNote: String,_ healthNote : String , _ familyNote: String,_ relationshipNote : String,_ assetNote : String ) {
        let quintetData = QuintetData(context: container.viewContext)
        quintetData.date = Date()
        quintetData.workPoint = Int64(workPoint)
        quintetData.healthPoint = Int64(healthPoint)
        quintetData.familyPoint = Int64(familyPoint)
        quintetData.relationshipPoint = Int64(relationshipPoint)
        quintetData.assetPoint = Int64(assetPoint)
        quintetData.workNote = workNote
        quintetData.healthNote = healthNote
        quintetData.familyNote = familyNote
        quintetData.relationshipNote = relationshipNote
        quintetData.assetNote = assetNote
       
        saveData()
    }

}

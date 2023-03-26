//
//  HypeController.swift
//  Hype
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation
import CloudKit

class HypeController {
    //Shared Instances
    static let shared = HypeController()
    
    //Source of Truth
    var hypes: [Hype] = []
    
    //Constant to store our publicCloudDatabase
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { completion(false) ; return }
        
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .none)
        
        let newHype = Hype(body: text, timestamp: Date(), userReference: reference)
        
        let hypeRecord = CKRecord(hype: newHype)
        
        publicDB.save(hypeRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                  let savedHype = Hype(ckRecord: record)
            else { completion(false) ; return }
            
            print("Saved Hype succesfully")
            self.hypes.insert(savedHype, at: 0)
            completion(true)
        }
    }
    
    func fetchHypes(completion: @escaping (Bool) -> Void ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            print("Fetched all hypes")
            
            let fetchedHypes = records.compactMap { Hype(ckRecord: $0) }
            self.hypes = fetchedHypes
            
            completion(true)
        }
    }
    
    func update(_ hype: Hype, completion: @escaping (Bool) -> Void) {
        
        guard hype.userReference?.recordID == UserController.shared.currentUser?.recordID  else { completion(false) ; return }
        //Step 3 - Define the records to be updated
        let recordToUpdate = CKRecord(hype: hype)
        //Step 2 - Create the requisite operation
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        //Step 4 - Set the properties for the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            //Handle the error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            //Ensure records were returned and updated
            guard let record = records?.first else { completion(false); return }
            print("Updated \(record.recordID.recordName) successfully in CloudKit")
            completion(true)
        }
        
        //Step 1 - Add operation to the database
        publicDB.add(operation)
    }
    
    func delete(_ hype: Hype, completion: @escaping (Bool) -> Void) {
        guard hype.userReference?.recordID == UserController.shared.currentUser?.recordID else { completion(false) ; return }
        
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [hype.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let recordIDs = recordIDs else  { completion(false); return }
                print("\(recordIDs) were removed successfully")
                completion(true)
        }
        
        publicDB.add(operation)
    }
        
    func subscribeForRemoteNotifications(completion: @escaping (Error?) -> Void) {
        //Step 3: -Declare the requisite predicate
        let predicate = NSPredicate(value: true)
        //Step 2: - Declare the subscription
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        //Step 4: - Setting the subscription properties
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "CHOO CHOO"
        notificationInfo.alertBody = "Can't stop the Hype train!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        //Step 1: - Call the save(subscription) function on the database
        publicDB.save(subscription) { _, error in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
}

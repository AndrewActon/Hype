//
//  UserController.swift
//  Hype
//
//  Created by Andrew Acton on 3/25/23.
//

import UIKit
import CloudKit

class UserController {
    //Shared Instance
    static let shared = UserController()
    //Source Of Truth
    var currentUser: User?
    //Database Constant
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    func createUser(with userName: String, bio: String, profilePhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        //Fethcing the CKUserIdentity recordID, creating a reference to use with our user object
        fetchAppleUserReference { reference in
            //Ensure that we can unwrap the reference
            guard let reference = reference else { completion(false) ; return }
            //init a newUser with the reference
            let newUser = User(userName: userName, bio: bio, profilePhoto: profilePhoto, appleUserReference: reference)
            //Crete the CKRecord to be save from the newUser
            let record = CKRecord(user: newUser)
            //Call the .save method to save the newly created CKRecord
            self.publicDB.save(record) { record, error in
                //Handle the error
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                    completion(false)
                    return
                }
                //Unwrap the record that was saved, ensure that we can init a user from that record
                guard let record = record,
                      let savedUser = User(ckRecord: record)
                else { completion(false) ; return }
                //Set the current User and complete true
                self.currentUser = savedUser
                print("Created user: \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        //Step 4 - Fetch and unwrap the appleUserRef to use in our predicate
        fetchAppleUserReference { reference in
            guard let reference = reference else { completion(false) ; return }
            //Step 3 - Define the predicate
            //Takes an array of arguments and passes them into the format, the first item in the array is being passed to the %K(Key) and the second itme in the array is being passed into the %@(value)
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserReferenceKey, reference])
            //Step 2 - init the query
            let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
            //Step 1 - perform the query
            self.publicDB.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                    completion(false)
                    return
                }
                
                guard let records = records?.first,
                      let foundUser = User(ckRecord: records)
                else { completion(false) ; return }
                
                self.currentUser = foundUser
                print("Fetched User: \(records.recordID.recordName) successfully")
                completion(true)
            }
        }
        
    }
    
    private func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(nil)
                return
            }
            
            guard let recordID = recordID else { completion(nil) ; return }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(reference)
        }
    }
    
    func updateUser(_ user: User) {
        
    }
    
    func deleteUser(_ user: User) {
        
    }
    
}//End Of Class

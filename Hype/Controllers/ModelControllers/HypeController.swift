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
    //Create
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        let newHype = Hype(body: text, timestamp: Date())
        
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
    
    //Fetch
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
        
        
//        publicDB.fetch(withQuery: query) { result in
//
//            switch result {
//            case .success(let records):
//                let recordsArray = records.matchResults
//                for results in recordsArray {
//                    switch results.1 {
//                    case .success(let record):
//                        guard let hype = Hype(ckRecord: record) else { return }
//                        self.hypes.append(hype)
//                    case .failure(let error):
//                        print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
//                    }
//                    completion(true)
//                    return
//                }
//            case .failure(let error):
//                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
//                completion(false)
//                return
//            }
//        }
    
    }
}

//
//  CloudKitManager.swift
//  Hype
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func save(records: [CKRecord], completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        modify(records: records, completion: completion)
    }
    
    func modify(records: [CKRecord], completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
//        operation.perRecordCompletionBlock   deprecated
//        operation.modifyRecordsCompletionBlock deprecated
        
        publicDB.add(operation)
    }
}

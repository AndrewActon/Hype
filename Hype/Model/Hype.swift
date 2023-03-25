//
//  Hype.swift
//  Hype
//
//  Created by Andrew Acton on 3/16/23.
//

import Foundation
import CloudKit

struct HypeStrings {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}//End Of Struct

class Hype {
    
    var body: String
    var timestamp: Date
    var recordID:  CKRecord.ID
    
    init(body: String, timestamp: Date, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
    
}//End Of Class

extension Hype {
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
              let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
        else { return nil }
        
        self.init(body: body, timestamp: timestamp, recordID: ckRecord.recordID)
    }
}//End Of Extension

extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//End Of Extension

extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
        
        //Alternative method:
        /*
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
        ])
         */
    }
}//End of Extension

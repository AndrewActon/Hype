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
    
    init(body: String, timestamp: Date) {
        self.body = body
        self.timestamp = timestamp
    }
    
}//End Of Class

extension Hype {
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
              let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
        else { return nil }
        
        self.init(body: body, timestamp: timestamp)
    }
}//End Of Extension

extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey)
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

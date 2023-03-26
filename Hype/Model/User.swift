//
//  User.swift
//  Hype
//
//  Created by Andrew Acton on 3/25/23.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let userNameKey = "userName"
    fileprivate static let bioKey = "bio"
    static let appleUserReferenceKey = "appleUserReference"
}//End Of Struct

class User {
    
    var userName: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    init(userName: String, bio: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.userName = userName
        self.bio = bio
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
    
}//End Of Class

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.userNameKey] as? String,
              let appleUserReference = ckRecord[UserStrings.appleUserReferenceKey] as? CKRecord.Reference,
              let bio = ckRecord[UserStrings.bioKey] as? String
        else { return nil }
        
        self.init(userName: username, bio: bio, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
    }
}//End Of Extensions

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//End Of Extension

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        self.setValuesForKeys([
            UserStrings.userNameKey: user.userName,
            UserStrings.bioKey: user.bio,
            UserStrings.appleUserReferenceKey: user.appleUserReference
        ])
    }
}//End Of Extension

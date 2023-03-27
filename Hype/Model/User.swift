//
//  User.swift
//  Hype
//
//  Created by Andrew Acton on 3/25/23.
//

import UIKit
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let userNameKey = "userName"
    fileprivate static let bioKey = "bio"
    static let appleUserReferenceKey = "appleUserReference"
    fileprivate static let photoAssetKey = "photoAsset"
}//End Of Struct

class User {
    //Class Properties
    var userName: String
    var bio: String
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            self.photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    //CloudKit Properties
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    var photoAsset: CKAsset {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
            
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(userName: String, bio: String = "", profilePhoto: UIImage?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.userName = userName
        self.bio = bio
        self.recordID = recordID
        self.appleUserReference = appleUserReference
        self.profilePhoto = profilePhoto
    }
    
}//End Of Class

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.userNameKey] as? String,
              let appleUserReference = ckRecord[UserStrings.appleUserReferenceKey] as? CKRecord.Reference,
              let bio = ckRecord[UserStrings.bioKey] as? String
        else { return nil }
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform the asset to data")
            }
        }
        
        self.init(userName: username, bio: bio, profilePhoto: foundPhoto, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
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
            UserStrings.appleUserReferenceKey: user.appleUserReference,
            UserStrings.photoAssetKey: user.photoAsset
        ])
    }
}//End Of Extension

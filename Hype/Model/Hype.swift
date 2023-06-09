//
//  Hype.swift
//  Hype
//
//  Created by Andrew Acton on 3/16/23.
//

import UIKit
import CloudKit

struct HypeStrings {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let userReferenceKey = "userReference"
    fileprivate static let photoAssetKey = "photoAsset"
}//End Of Struct

class Hype {
    //Class Properties
    var body: String
    var timestamp: Date
    var hypePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    //CloudKit Properties
    var recordID:  CKRecord.ID
    var userReference: CKRecord.Reference?
    var photoAsset: CKAsset? {
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
    
    init(body: String, timestamp: Date, hypePhoto: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        self.hypePhoto = hypePhoto
    }
    
}//End Of Class

extension Hype {
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
              let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
        else { return nil }
        
        let userReference = ckRecord[HypeStrings.userReferenceKey] as? CKRecord.Reference
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[HypeStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }
        
        self.init(body: body, timestamp: timestamp, hypePhoto: foundPhoto, recordID: ckRecord.recordID, userReference: userReference)
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
        self.setValue(hype.userReference, forKey: HypeStrings.userReferenceKey)
        self.setValue(hype.photoAsset, forKey: HypeStrings.photoAssetKey)
        
        //Alternative method:
        /*
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
            HypeStrings.userReferenceKey : hype.userReference
        ])
         */
    }
}//End of Extension

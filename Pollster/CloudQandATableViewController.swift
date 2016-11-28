//
//  CloudQandATableViewController.swift
//  Pollster
//
//  Created by Chen Cen on 11/27/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit
import CloudKit

class CloudQandATableViewController: QandATableViewController {
    var ckQandARecord : CKRecord {
        get {
            if _ckQandARecord == nil {
                _ckQandARecord = CKRecord(recordType: Cloud.Entry.QandA)
            }
            return _ckQandARecord!
        }
        set {
            _ckQandARecord = newValue
        }
    }
    
    // if not defined as an optional, we would need a initializer to make sure it's never nil
    private var _ckQandARecord: CKRecord? {
        didSet {
            // CKRecord would act like a dictionary record
            let question = ckQandARecord[Cloud.Attribute.Question] as? String ?? ""
            let answers = ckQandARecord[Cloud.Attribute.Answers] as? [String] ?? []
            qanda = QandA(question: question, answers: answers)
//            asking = ckQandARecord.wasCreatedByThisUser
            asking = true
        }
    }
    
    // access the container from cloud
    private let iCloudDatabase = CKContainer.default().publicCloudDatabase
    
    @objc private func iCloudUpdate() {
        if !qanda.question.isEmpty && !qanda.answers.isEmpty {
            ckQandARecord[Cloud.Attribute.Question] = qanda.question as CKRecordValue?
            ckQandARecord[Cloud.Attribute.Answers] = qanda.answers as CKRecordValue?
            iCloudSaveRecord(ckQandARecord)
        }
    }
    
    private func iCloudSaveRecord(_ recordToSave: CKRecord) {
        iCloudDatabase.save(recordToSave) { (savedRecord, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.retryAfterError(error, withSelector: #selector(self.iCloudUpdate))
                }
            }
        }
    }
    
    private func retryAfterError(_ error: Error?, withSelector selector: Selector) {
        if let nsError = error as? NSError {
            if let retryInterval = nsError.userInfo[CKErrorRetryAfterKey] as? TimeInterval {
                Timer.scheduledTimer(
                    timeInterval: retryInterval,
                    target: self,
                    selector: selector,
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    // save to iCloud when user ended editing
//    override func textViewDidEndEditing(textView: UITextView) {
//        super.textViewDidEndEditing(textView: textView)
//        iCloudUpdate()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ckQandARecord = CKRecord(recordType: Cloud.Entry.QandA)
    }
}

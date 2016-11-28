//
//  CloudKitExtensions.swift
//  Pollster
//
//  Created by Chen Cen on 11/27/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import CloudKit

struct CloudKitNotifications {
    static let NotificationReceived = "iCloudRemoteNotificationReceived"
    static let Notificationkey = "Notification"
}

struct Cloud {
    struct Entry {
        static let QandA = "QandA"
        static let Response = "Response"
    }
    struct Attribute {
        static let Question = "question"
        static let Answers = "answers"
        static let ChoosenAnswer = "choosenanswer"
        static let QandA = "qanda"
    }
}

extension CKRecord {
    var wasCreatedByThisUser: Bool {
        return (creatorUserRecordID != nil) || (creatorUserRecordID?.recordName == "__defaultOwner__")
    }
}

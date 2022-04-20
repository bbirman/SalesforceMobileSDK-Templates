/*
 ViewController.swift
 MobileSyncExplorerSwift
 
 Created by Raj Rao on 05/16/18.
 
 Copyright (c) 2018-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import Foundation
import MobileSync.SFMobileSyncConstants

enum ContactConstants {
    static let kContactFirstNameField    = "FirstName"
    static let kContactLastNameField     = "LastName"
    static let kContactTitleField        = "Title"
    static let kContactMobilePhoneField  = "MobilePhone"
    static let kContactEmailField        = "Email"
    static let kContactDepartmentField   = "Department"
    static let kContactHomePhoneField    = "HomePhone"
    static let kContactAccountIdField    = "AccountId"
}

enum AccountConstants {
    static let kAccountNameField        = "Name"
    static let kAccountIndustryField    = "Industry"
    static let kAccountPhoneField       = "Phone"
    static let kAccountWebsiteField     = "Website"
//    static let kAccountOpportunityIdField = "OpportunityId"
}

enum OpportunityConstants {
    static let kOpportunityNameField        = "Name"
    static let kOpportunityDescriptionField     = "Description"
    static let kOpportunityAmountField    = "Amount"
    static let kOpportunityCloseDateField       = "CloseDate"
    static let kOpportunityAccountIdField    = "AccountId"

}

class OpportunitySObjectData: SObjectData, Identifiable {
    var name: String? {
        get {
            return super.nonNullFieldValue(OpportunityConstants.kOpportunityNameField) as? String
        }
        set {
            super.updateSoup(forFieldName: OpportunityConstants.kOpportunityNameField, fieldValue: newValue)
        }
    }
    
    var description: String? {
        get {
            return super.nonNullFieldValue(OpportunityConstants.kOpportunityDescriptionField) as? String
        }
        set {
            super.updateSoup(forFieldName: OpportunityConstants.kOpportunityDescriptionField, fieldValue: newValue)
        }
    }
    
    var amount: String? {
        get {
            return super.nonNullFieldValue(OpportunityConstants.kOpportunityAmountField ) as? String
        }
        set {
            super.updateSoup(forFieldName: OpportunityConstants.kOpportunityAmountField, fieldValue: newValue)
        }
    }
    
    var closeDate: String? {
        get {
            return super.nonNullFieldValue(OpportunityConstants.kOpportunityCloseDateField) as? String
        }
        set {
            super.updateSoup(forFieldName: OpportunityConstants.kOpportunityCloseDateField, fieldValue: newValue)
        }
    }
    
    
    var lastModifiedDate: String? {
        get {
            return super.nonNullFieldValue(kLastModifiedDate) as? String
        }
        set {
            super.updateSoup(forFieldName: kLastModifiedDate, fieldValue: newValue)
        }
    }
    
    var accountId: String? {
        get {
            return super.nonNullFieldValue(OpportunityConstants.kOpportunityAccountIdField) as? String
        }
    }
    
    
    var id: NSNumber {
        return super.nonNullFieldValue("_soupEntryId") as! NSNumber
    }
    
    override init(soupDict: [String: Any]?) {
        super.init(soupDict: soupDict)
    }
    
    override init() {
        super.init()
    }
    
    override class func dataSpec() -> SObjectDataSpec? {
        var sDataSpec: OpportunitySObjectDataSpec? = nil
        if sDataSpec == nil {
            sDataSpec = OpportunitySObjectDataSpec()
        }
        return sDataSpec
    }
}


class AccountSObjectData: SObjectData, Identifiable {
    var name: String? {
        get {
            return super.nonNullFieldValue(AccountConstants.kAccountNameField) as? String
        }
        set {
            super.updateSoup(forFieldName: AccountConstants.kAccountNameField, fieldValue: newValue)
        }
    }
    
    var industry: String? {
        get {
            return super.nonNullFieldValue(AccountConstants.kAccountIndustryField) as? String
        }
        set {
            super.updateSoup(forFieldName: AccountConstants.kAccountIndustryField, fieldValue: newValue)
        }
    }
    
    var phone: String? {
        get {
            return super.nonNullFieldValue(AccountConstants.kAccountPhoneField ) as? String
        }
        set {
            super.updateSoup(forFieldName: AccountConstants.kAccountPhoneField, fieldValue: newValue)
        }
    }
    
    var website: String? {
        get {
            return super.nonNullFieldValue(AccountConstants.kAccountWebsiteField) as? String
        }
        set {
            super.updateSoup(forFieldName: AccountConstants.kAccountWebsiteField, fieldValue: newValue)
        }
    }
    
//    var opportunityId: String? {
//        get {
//            return super.nonNullFieldValue(AccountConstants.kAccountOpportunityIdField) as? String
//        }
//    }
    
    var lastModifiedDate: String? {
        get {
            return super.nonNullFieldValue(kLastModifiedDate) as? String
        }
        set {
            super.updateSoup(forFieldName: kLastModifiedDate, fieldValue: newValue)
        }
    }
    
    var id: NSNumber {
        return super.nonNullFieldValue("_soupEntryId") as! NSNumber
    }
    
    var externalId: String? {
        return super.nonNullFieldValue("Id") as? String
    }
    
    override init(soupDict: [String: Any]?) {
        super.init(soupDict: soupDict)
    }
    
    override init() {
        super.init()
    }
    
    override class func dataSpec() -> SObjectDataSpec? {
        var sDataSpec: AccountSObjectDataSpec? = nil
        if sDataSpec == nil {
            sDataSpec = AccountSObjectDataSpec()
        }
        return sDataSpec
    }
}

class ContactSObjectData: SObjectData, Identifiable {
    var firstName: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactFirstNameField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactFirstNameField, fieldValue: newValue)
        }
    }
    
    var lastName: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactLastNameField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactLastNameField, fieldValue: newValue)
        }
    }
    
    var title: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactTitleField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactTitleField, fieldValue: newValue)
        }
    }
    
    var mobilePhone: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactMobilePhoneField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactMobilePhoneField, fieldValue: newValue)
        }
    }
    
    var email: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactEmailField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactEmailField, fieldValue: newValue)
        }
    }
    
    var department: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactDepartmentField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactDepartmentField, fieldValue: newValue)
        }
    }
    
    var homePhone: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactHomePhoneField) as? String
        }
        set {
            super.updateSoup(forFieldName: ContactConstants.kContactHomePhoneField, fieldValue: newValue)
        }
    }
    
    var lastModifiedDate: String? {
        get {
            return super.nonNullFieldValue(kLastModifiedDate) as? String
        }
        set {
            super.updateSoup(forFieldName: kLastModifiedDate, fieldValue: newValue)
        }
    }
    
    var accountId: String? {
        get {
            return super.nonNullFieldValue(ContactConstants.kContactAccountIdField) as? String
        }
    }
    
    var id: NSNumber {
        return super.nonNullFieldValue("_soupEntryId") as! NSNumber
    }
    
    override init(soupDict: [String: Any]?) {
        super.init(soupDict: soupDict)
    }
    
    override init() {
        super.init()
    }
    
    override class func dataSpec() -> SObjectDataSpec? {
        var sDataSpec: ContactSObjectDataSpec? = nil
        if sDataSpec == nil {
            sDataSpec = ContactSObjectDataSpec()
        }
        return sDataSpec
    }
}

class ContactSObjectDataSpec: SObjectDataSpec {
    
    convenience init() {
        let objectType = "Contact"
        let objectFieldSpecs = [
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactFirstNameField, searchable: true),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactLastNameField, searchable: true),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactTitleField, searchable: true),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactMobilePhoneField, searchable: false),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactEmailField, searchable: false),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactDepartmentField, searchable: false),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactHomePhoneField, searchable: false),
            SObjectDataFieldSpec(fieldName: ContactConstants.kContactAccountIdField, searchable: false)
        ]
        let soupName = "contacts"
        let orderByFieldName: String  = ContactConstants.kContactLastNameField
        self.init(objectType: objectType, objectFieldSpecs: objectFieldSpecs, soupName: soupName, orderByFieldName: orderByFieldName)
    }
    
    override class func createSObjectData(_ soupDict: [String : Any]?) throws -> SObjectData? {
        return ContactSObjectData(soupDict: soupDict)
    }
}


class AccountSObjectDataSpec: SObjectDataSpec {
    
    convenience init() {
        let objectType = "Account"
        let objectFieldSpecs = [
            SObjectDataFieldSpec(fieldName: AccountConstants.kAccountNameField, searchable: true),
            SObjectDataFieldSpec(fieldName: AccountConstants.kAccountIndustryField, searchable: true),
            SObjectDataFieldSpec(fieldName: AccountConstants.kAccountPhoneField, searchable: false),
            SObjectDataFieldSpec(fieldName: AccountConstants.kAccountWebsiteField, searchable: true)
            

        ]
        let soupName = "accounts"
        let orderByFieldName: String = AccountConstants.kAccountNameField
        self.init(objectType: objectType, objectFieldSpecs: objectFieldSpecs, soupName: soupName, orderByFieldName: orderByFieldName)
    }
    
    override class func createSObjectData(_ soupDict: [String : Any]?) throws -> SObjectData? {
        return AccountSObjectData(soupDict: soupDict)
    }
}

class OpportunitySObjectDataSpec: SObjectDataSpec {
    
    convenience init() {
        let objectType = "Opportunity"
        let objectFieldSpecs = [
            SObjectDataFieldSpec(fieldName: OpportunityConstants.kOpportunityNameField, searchable: true),
            SObjectDataFieldSpec(fieldName: OpportunityConstants.kOpportunityDescriptionField, searchable: true),
            SObjectDataFieldSpec(fieldName: OpportunityConstants.kOpportunityCloseDateField, searchable: false),
            SObjectDataFieldSpec(fieldName: OpportunityConstants.kOpportunityAmountField, searchable: true)
            

        ]
        let soupName = "opportunities"
        let orderByFieldName: String = OpportunityConstants.kOpportunityNameField
        self.init(objectType: objectType, objectFieldSpecs: objectFieldSpecs, soupName: soupName, orderByFieldName: orderByFieldName)
    }
    
    override class func createSObjectData(_ soupDict: [String : Any]?) throws -> SObjectData? {
        return OpportunitySObjectData(soupDict: soupDict)
    }
}

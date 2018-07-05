/*
  AccountStore.swift
  Consumer

  Created by Nicholas McDonald on 3/1/18.

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
import SalesforceSwiftSDK
import SmartStore
import SmartSync

public class AccountStore: Store<Account> {
    public static let instance = AccountStore()
    
    public func myAccount() -> Account? {
        let identity = SFUserAccountManager.sharedInstance().currentUserIdentity
        guard let userId = identity?.userId else {return nil}
        return self.account(userId)
    }
    
    public func account(_ forUserId:String) -> Account? {
        // todo only sync down users record
        let query = SFQuerySpec.newAllQuerySpec(Account.objectName, withOrderPath: Account.orderPath, with: .descending, withPageSize: 100)
        var error: NSError? = nil
        let results: [Any] = store.query(with: query, pageIndex: 0, error: &error)
        guard error == nil else {
            SalesforceSwiftLogger.log(type(of:self), level:.error, message:"fetch \(Account.objectName) failed: \(error!.localizedDescription)")
            return nil
        }
        let accounts: [Account] = Account.from(results)
        let filteredAccounts = accounts.filter { (account) -> Bool in
            guard let id = account.accountNumber else {return false}
            return id == forUserId
        }
        return filteredAccounts.first
        
    }
    
    public func account(forAccountId:String) -> Account? {
        let query = SFQuerySpec.newExactQuerySpec(Account.objectName, withPath: Account.Field.accountId.rawValue, withMatchKey: forAccountId, withOrderPath: Account.orderPath, with: .ascending, withPageSize: 1)
        var error: NSError? = nil
        let results: [Any] = store.query(with: query, pageIndex: 0, error: &error)
        guard error == nil else {
            SalesforceSwiftLogger.log(type(of:self), level:.error, message:"fetch \(Account.objectName) failed: \(error!.localizedDescription)")
            return nil
        }
        return Account.from(results)
    }
    
    public func create(_ account:Account, completion:SyncCompletion) {
        self.createEntry(entry: account, completion: completion)
    }
}
//
//  AuthenticationWorker.swift
//  AuthenticationWorker
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Domains
import DataService
import CoreData
public class AuthenticationWorker: AuthenticationWorkerProtocol {
    public weak var userListDelegate: FetchUserListProtocol?
    public weak var topupDelegate: TopupAmountProtocol?
    public weak var userDataDelegate: UserDataProtocol?
    public weak var loginDelegate: UserLoginProtocol?
    
    public init() {}
    public func doLogin(with user: Client) {
        if let userName = user.userName {
            let managedContext =
                DataService.shared.persistentContainer.viewContext
            let predicate = NSPredicate(format: "\(DBC.nameKey) == %@", userName.lowercased())
            
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
            fetchRequest.predicate = predicate
            do {
                let fetchedResults = try managedContext.fetch(fetchRequest)
                if fetchedResults.first != nil {
                    loginDelegate?.didSuccessLogin()
                } else {
                    let entity =
                        NSEntityDescription.entity(forEntityName: DBConstants.userTable,
                                                   in: managedContext)!
                    
                    let client = NSManagedObject(entity: entity,
                                               insertInto: managedContext)
                    client.setValue(userName, forKey: DBC.nameKey)
                    client.setValue(user.balance ?? 0, forKeyPath: DBC.balanceKey)
                    do {
                        try managedContext.save()
                        loginDelegate?.didSuccessLogin()
                    } catch let error as NSError {
                        loginDelegate?.didFailLogin()
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                loginDelegate?.didFailLogin()
            }
        } else {
            loginDelegate?.didFailLogin()
        }
        
    }
    
    public func getUserData(from userName: String) {
        let managedContext =
            DataService.shared.persistentContainer.viewContext
        let predicate = NSPredicate(format: "\(DBC.nameKey) == %@", userName.lowercased())
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.first != nil {
                let result = fetchedResults.first
                var user:Client = Client()
                user.userName = result?.value(forKeyPath: DBC.nameKey) as? String
                user.balance = result?.value(forKeyPath: DBC.balanceKey) as? Double
                userDataDelegate?.didFetchUserData(user: user)
            } else {
                userDataDelegate?.didFailtToFetchUserData()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            userDataDelegate?.didFailtToFetchUserData()
        }
    }
    
    public func topupAmount(amount: Double, for user: String) {
        let managedContext =
            DataService.shared.persistentContainer.viewContext
        let predicate = NSPredicate(format: "\(DBC.nameKey) == %@", user.lowercased())
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.first != nil {
                let result = fetchedResults.first
                let prevAmount = result?.value(forKeyPath: DBC.balanceKey) as? Double ?? 0
                let newAmount  = prevAmount + amount
                result?.setValue(newAmount, forKeyPath: DBC.balanceKey)
                try managedContext.save()
                topupDelegate?.didSuccessTopup()
            } else {
                topupDelegate?.didFailtTopup()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            userDataDelegate?.didFailtToFetchUserData()
        }
    }
    
    public func fetchUserList() {
        var userList:[Client] = []
        let managedContext =
            DataService.shared.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            fetchedResults.forEach { user in
                var client = Client()
                client.userName = user.value(forKeyPath: DBC.nameKey) as? String
                client.balance = user.value(forKeyPath: DBC.balanceKey) as? Double
                userList.append(client)
            }
            userListDelegate?.didSuccessFetchUserList(users: userList)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            userListDelegate?.didFailToFetchUserList()
        }
    }
    
}

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
    public weak var userStatusDelegate: UserBalanceStatusProtocol?
    public weak var paymentDelegate: PaymentProtocol?
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
                    client.setValue(userName.lowercased(), forKey: DBC.nameKey)
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
        var user:Client = Client()
        var debtClients:[DebtClient] = []
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.first != nil {
                let result = fetchedResults.first
                let name = result?.value(forKeyPath: DBC.nameKey) as? String
                user.userName = name?.capitalized
                user.balance = result?.value(forKeyPath: DBC.balanceKey) as? Double
                
                //Add reminder to another table
                let debtFetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: DBConstants.debtTable)
                let predicate = NSPredicate(format: "\(DBC.payerKey) == %@ || \(DBC.payeeKey) == %@", userName.lowercased(), userName.lowercased())
                debtFetchRequest.predicate = predicate
                let fetchedResults = try managedContext.fetch(debtFetchRequest)
                if fetchedResults.first != nil {
                    fetchedResults.forEach { result in
                        var debtClient = DebtClient()
                        let payer = result.value(forKeyPath: DBC.payerKey) as? String
                        let payee = result.value(forKeyPath: DBC.payeeKey) as? String
                        let dueAmount = result.value(forKeyPath: DBC.amountKey) as? Double
                        debtClient.dueAmount = dueAmount
                        if abs(dueAmount ?? 0) > 0 {
                            if userName == payer {
                                debtClient.status = .payer
                                debtClient.payerPayee = payee?.capitalized
                            } else if userName == payee {
                                debtClient.status = .payee
                                debtClient.payerPayee = payer?.capitalized
                            } else {
                                debtClient.status = .noDue
                            }
                        } else {
                            debtClient.status = .noDue
                        }
                        debtClients.append(debtClient)
                    }
                }
                user.debtClients = debtClients
                userDataDelegate?.didFetchUserData(user: user)
                
            } else {
                userDataDelegate?.didFailtToFetchUserData()
            }
        } catch let error as NSError {
            print("Could not get user data. \(error), \(error.userInfo)")
            userDataDelegate?.didFailtToFetchUserData()
        }
    }
    
    public func topupAmount(amount: Double, for user: String) {
        
        let managedContext =
            DataService.shared.persistentContainer.viewContext
        var amount = amount
        //check for debt
        //Add reminder to another table
        let debtFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.debtTable)
        var predicate = NSPredicate(format: "\(DBC.payerKey) == %@", user.lowercased())
        debtFetchRequest.predicate = predicate
        do {
            let fetchedResults = try managedContext.fetch(debtFetchRequest)
            if fetchedResults.first != nil {
                let result = fetchedResults.first
                var debt = result?.value(forKeyPath: DBC.amountKey) as? Double
                if (debt ?? 0) > 0 {
                    if debt ?? 0 >= amount {
                        debt = (debt ?? 0) - amount
                        result?.setValue(debt, forKeyPath: DBC.amountKey)
                        try managedContext.save()
                        //update payee balance
                        if let payee = result?.value(forKeyPath: DBC.payeeKey) as? String {
                            updateBalace(amount: amount, for: payee)
                        }
                        topupDelegate?.didSuccessTopup()
                        return
                    } else {
                        amount = amount - (debt ?? 0)
                        result?.setValue(0, forKeyPath: DBC.amountKey)
                        if let payee = result?.value(forKeyPath: DBC.payeeKey) as? String {
                            updateBalace(amount: (debt ?? 0), for: payee)
                        }
                        try managedContext.save()
                    }
                }
                
            } else {}
        } catch _ as NSError {}
        predicate = NSPredicate(format: "\(DBC.nameKey) == %@", user.lowercased())
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
            print("Could not topup. \(error), \(error.userInfo)")
            topupDelegate?.didFailtTopup()
        }
    }
    func updateBalace(amount: Double, for user: String) {
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
            }
        } catch _ as NSError {}
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
            print("Could not fetch list. \(error), \(error.userInfo)")
            userListDelegate?.didFailToFetchUserList()
        }
    }
    
    public func payAmount(amount: Double, fromUser: Client, toUser: Client) {
        if let fromUserName = fromUser.userName, let toUserName = toUser.userName {
            if fromUser.balance ?? 0 >= amount {
                let managedContext = DataService.shared.persistentContainer.viewContext
                let predicateFromUser = NSPredicate(format: "\(DBC.nameKey) == %@", fromUserName.lowercased())
                let fetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
                fetchRequest.predicate = predicateFromUser
                let predicateToUser = NSPredicate(format: "\(DBC.nameKey) == %@", toUserName.lowercased())
                var fromUserData:NSManagedObject?
                var toUserData: NSManagedObject?
                do {
                    var fetchedResults = try managedContext.fetch(fetchRequest)
                    if fetchedResults.first != nil {
                        fromUserData = fetchedResults.first
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                    fetchRequest.predicate = predicateToUser
                    fetchedResults = try managedContext.fetch(fetchRequest)
                    if fetchedResults.first != nil {
                        toUserData = fetchedResults.first
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                    if let payer = fromUserData , let payee = toUserData {
                        var amount = amount
                        //if payer has previous debts
                        if var debtBalance = getDebtBalance(fromUser: toUserName, toUser: fromUserName) {
                            if debtBalance >= amount {
                                //reduce the further debt
                                debtBalance = debtBalance - amount
                                let updateResult = updateReminderToDebtTable(fromUser: toUser, toUser: fromUser, remainderAmount: debtBalance)
                                if updateResult == true {
                                    paymentDelegate?.didSuccessPayment()
                                } else {
                                    paymentDelegate?.didFailPayment()
                                }
                            } else {
                                amount = amount - debtBalance
                                _ = updateReminderToDebtTable(fromUser: toUser, toUser: fromUser, remainderAmount: 0)
                                //pay remaining balance after debt
                                let payerBalance = payer.value(forKeyPath: DBC.balanceKey) as? Double
                                let payerNewBalance = (payerBalance ?? 0) - amount
                                payer.setValue(payerNewBalance, forKeyPath: DBC.balanceKey)
                                
                                let payeeBalance = payee.value(forKeyPath: DBC.balanceKey) as? Double
                                let payeeNewBalance = (payeeBalance ?? 0) + amount
                                payee.setValue(payeeNewBalance, forKeyPath: DBC.balanceKey)
                                try managedContext.save()
                                paymentDelegate?.didSuccessPayment()
                            }
                        } else {
                            let payerBalance = payer.value(forKeyPath: DBC.balanceKey) as? Double
                            let payerNewBalance = (payerBalance ?? 0) - amount
                            payer.setValue(payerNewBalance, forKeyPath: DBC.balanceKey)
                            
                            let payeeBalance = payee.value(forKeyPath: DBC.balanceKey) as? Double
                            let payeeNewBalance = (payeeBalance ?? 0) + amount
                            payee.setValue(payeeNewBalance, forKeyPath: DBC.balanceKey)
                            try managedContext.save()
                            paymentDelegate?.didSuccessPayment()
                        }
                        
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                    
                } catch let error as NSError {
                    print("Could not make payment. \(error), \(error.userInfo)")
                    paymentDelegate?.didFailPayment()
                }
            } else {
                let managedContext = DataService.shared.persistentContainer.viewContext
                let predicateFromUser = NSPredicate(format: "\(DBC.nameKey) == %@", fromUserName.lowercased())
                let fetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: DBConstants.userTable)
                fetchRequest.predicate = predicateFromUser
                let predicateToUser = NSPredicate(format: "\(DBC.nameKey) == %@", toUserName.lowercased())
                var fromUserData:NSManagedObject?
                var toUserData: NSManagedObject?
                do {
                    var fetchedResults = try managedContext.fetch(fetchRequest)
                    if fetchedResults.first != nil {
                        fromUserData = fetchedResults.first
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                    fetchRequest.predicate = predicateToUser
                    fetchedResults = try managedContext.fetch(fetchRequest)
                    if fetchedResults.first != nil {
                        toUserData = fetchedResults.first
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                   
                    if let payer = fromUserData , let payee = toUserData {
                        //if payer has previous debts
                        let balance = fromUserData?.value(forKeyPath: DBC.balanceKey) as? Double
                        if let debtBalance = getDebtBalance(fromUser: toUserName, toUser: fromUserName) {
                            let finalAmountToPay = abs((balance ?? 0) - (debtBalance - (amount - (balance ?? 0))))
                            if debtBalance >= amount {
                                //reduce the further debt
                                let updateResult = updateReminderToDebtTable(fromUser: toUser, toUser: fromUser, remainderAmount: finalAmountToPay)
                                if updateResult == true {
                                    paymentDelegate?.didSuccessPayment()
                                } else {
                                    paymentDelegate?.didFailPayment()
                                }
                            } else {
                                //set and update debt to 0
                                _ = updateReminderToDebtTable(fromUser: toUser, toUser: fromUser, remainderAmount: 0)
                                var payerBalance = payer.value(forKeyPath: DBC.balanceKey) as? Double
                                if finalAmountToPay < (balance ?? 0) {
                                    //update payer balance
                                    payerBalance = (payerBalance ?? 0) - finalAmountToPay
                                    payer.setValue(payerBalance, forKeyPath: DBC.balanceKey)
                                    //update the payee balance
                                    let payeeBalance = payee.value(forKeyPath: DBC.balanceKey) as? Double
                                    let payeeNewBalance = (payeeBalance ?? 0) + finalAmountToPay
                                    payee.setValue(payeeNewBalance, forKeyPath: DBC.balanceKey)
                                } else {
                                    let remainderAmount = finalAmountToPay - (balance ?? 0)
                                    //update payer balance
                                    payer.setValue(0, forKeyPath: DBC.balanceKey)
                                    //update the payee balance
                                    let payeeBalance = payee.value(forKeyPath: DBC.balanceKey) as? Double
                                    let payeeNewBalance = (payeeBalance ?? 0) + (payerBalance ?? 0)
                                    payee.setValue(payeeNewBalance, forKeyPath: DBC.balanceKey)
                                    _ = updateReminderToDebtTable(fromUser: fromUser, toUser: toUser, remainderAmount: remainderAmount, isAdd: true)
                                }
                                try managedContext.save()
                                paymentDelegate?.didSuccessPayment()
                            }
                        } else {
                            payer.setValue(0, forKeyPath: DBC.balanceKey)
                            let payeeBalance = payee.value(forKeyPath: DBC.balanceKey) as? Double
                            let payeeNewBalance = (fromUser.balance ?? 0) + (payeeBalance ?? 0)
                            payee.setValue(payeeNewBalance, forKeyPath: DBC.balanceKey)
                            try managedContext.save()
                            let remainingAmount = amount - (fromUser.balance  ?? 0)
                            let updateResult = updateReminderToDebtTable(fromUser: fromUser, toUser: toUser, remainderAmount: remainingAmount, isAdd: true)
                            if updateResult == true {
                                paymentDelegate?.didSuccessPayment()
                            } else {
                                paymentDelegate?.didFailPayment()
                            }
                        }
                        
                    } else {
                        paymentDelegate?.didFailPayment()
                    }
                    
                } catch let error as NSError {
                    print("Could not make payment. \(error), \(error.userInfo)")
                    paymentDelegate?.didFailPayment()
                }
            }
        } else {
            paymentDelegate?.didFailPayment()
        }
    }
    
    func updateReminderToDebtTable(fromUser: Client, toUser: Client, remainderAmount: Double, isAdd: Bool = false) -> Bool? {
        var transactionResult = true
        let managedContext = DataService.shared.persistentContainer.viewContext
        //Add reminder to another table
        let debtFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.debtTable)
        if let fromUserName = fromUser.userName, let toUserName = toUser.userName {
            let predicate = NSPredicate(format: "\(DBC.payerKey) == %@ && \(DBC.payeeKey) == %@", fromUserName.lowercased(), toUserName.lowercased())
            debtFetchRequest.predicate = predicate
            var remainderAmount = remainderAmount
            do {
                let fetchedResults = try managedContext.fetch(debtFetchRequest)
                if fetchedResults.first != nil {
                    let result = fetchedResults.first
                    if isAdd {
                        let balance = result?.value(forKeyPath: DBC.amountKey) as? Double
                        remainderAmount = remainderAmount + (balance ?? 0)
                    }
                    result?.setValue(remainderAmount, forKeyPath: DBC.amountKey)
                    try managedContext.save()
                    transactionResult = true
                } else {
                    let entity =
                        NSEntityDescription.entity(forEntityName: DBConstants.debtTable,
                                                   in: managedContext)!
                    
                    let debt = NSManagedObject(entity: entity,
                                               insertInto: managedContext)
                    debt.setValue(fromUserName.lowercased(), forKey: DBC.payerKey)
                    debt.setValue(toUserName.lowercased(), forKeyPath: DBC.payeeKey)
                    debt.setValue(remainderAmount, forKeyPath: DBC.amountKey)
                    do {
                        try managedContext.save()
                        transactionResult = true
                    } catch let error as NSError {
                        print("Could not update remainder. \(error), \(error.userInfo)")
                        transactionResult = false
                    }
                }
            } catch let error as NSError {
                print("Could not update remainder. \(error), \(error.userInfo)")
                transactionResult = false
            }
        }
        return transactionResult
    }
    
    public func getDebtBalance(fromUser: String, toUser: String) -> Double? {
        let managedContext = DataService.shared.persistentContainer.viewContext
        //Add reminder to another table
        let debtFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBConstants.debtTable)
        let predicate = NSPredicate(format: "\(DBC.payerKey) == %@ && \(DBC.payeeKey) == %@", fromUser.lowercased(), toUser.lowercased())
        debtFetchRequest.predicate = predicate
        do {
            let fetchedResults = try managedContext.fetch(debtFetchRequest)
            if fetchedResults.first != nil {
                let result = fetchedResults.first
                let balance = result?.value(forKeyPath: DBC.amountKey) as? Double
                return balance
                
            } else {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
    }
}

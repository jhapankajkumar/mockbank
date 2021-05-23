
import Domains
public struct HomeScreenViewModel {
    public var balance: Double?
    public var userName: String?
    public var debtClients: [DebtUser]?
    
    static func createFrom(client: Client) -> HomeScreenViewModel {
        var viewModel = HomeScreenViewModel()
        viewModel.balance = client.balance
        viewModel.userName = client.userName
        let debtClients = client.debtClients?.filter({$0.dueAmount ?? 0 > 0}).map({ client in
            return DebtUser.createFrom(debtClient: client)
        })
        viewModel.debtClients = debtClients
        return viewModel
    }
}

public struct DebtUser {
    public var dueAmount: Double?
    public var payerPayee: String?
    public var status: ClientStatus?
    
    static func createFrom(debtClient: DebtClient) -> DebtUser {
        var user = DebtUser()
        user.dueAmount = debtClient.dueAmount
        user.payerPayee = debtClient.payerPayee
        user.status = debtClient.status
        return user
    }
}

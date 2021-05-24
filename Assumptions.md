# Mockbank

## Requirements
1. Xcode 12.5
2. iOS 14.0 and above

## Frameworks
Mock Bank project build on modular architecture.
In banking we have many modules like `Payment` , `Transfer`, `Topup`, Its better approach to create the farmework for each module. 
All the feature module must be independent, we should not import `Payment`  module to `Transfer` module. It may lead to cyclic dependency.
To overcome this issue, we need to create the a framerowk which will act as Bridge between the modules. In Mock Bank application the Brige framework is `App Navigations`.
All communication between the modules will go throuh `App Navigation`.

There are some other support framework which can also be shared among other modules such as `Common`, `Data Service`, `Domain`

Each module can have their own `Feature Worker`. it depends on the requirement. also `Feature Worker` are not dependent on any modules, so they can be shared among
#ex- `Authentication Worker` is shared amoung all the feature `Payment` , `Dashboard`, `Topup`. Since we are not using any webservice, storing and retreaving data from DB hence we have used only one `Feature Worker`.


### Database 
I am using Core Data framework to for storing and retreaving data, to manage this, I have created the `Data Service` framework which have the DB

### Unit Testing
I am using Quick, Nimble framework for unit testing. 
[Detail](_https://medium.com/mobil-dev/quick-and-nimble-5c90aa6b3d48_). 


### Validations
1. User name must be between `3 - 16` characters.
2. Max digit for Topup and Payment is `10`.
3. Min digit for Topup or Payment is `2`.
4. User can not pay if balance is `0`, must do topup before payment.

# Mockbank
A Simple iOS Mock Banking application by modular approach with VIPER architecture.

## Achitecture
Mock Bank project build on modular architecture.
Application is using VIPER Protocol with clean architecture approach. Take a look on VIPER template [GitHub - dgwu/dg-viper-template](https://github.com/dgwu/dg-viper-template) and install on your machine properly.
Current Mock Bank frameworks consist of `Domains`, `Common`, `Data Service`, `Feature Workers`, `Features`, `App Navigations`.
Since we are using dynamic frameworks it will little bit slow whenever we build for first time of the applications.

### Dependencies Management
1. [Cocoapod](_https://guides.cocoapods.org/_). We are using *version 1.10.1*
    * If you define the target /Framework/ please carefully to take project location, for example: `Featues/Splash/Splash.project` 
    * Since *Test Target* must be buildable make sure you include the dependencies of the *parent target* have. Please take a look sample target here:

### Requirements
1. [XcodeGen](_https://github.com/yonaskolb/XcodeGen_) install by running `brew install xcodegen`

Each project contains *yml* files, the structure each *yml* files based on reference on [Spec](_https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md_). 

You can generate *pbxproj* whatever you want by running

 `xcodegen --spec filePath.yml`

for example you want to build the *MainApp* xcodeproj by running

`xcodegen --spec MainaApp/project_main.yml`

but if you want to build all xcodeproj you can running single shell script in your terminal

 `./setup_project.sh` 

XcodeGen will refresh indexing identifier for each files inside pbxproj, so you will need to run *Pod Install* again.

### How to Run this Project
1. Pull on Bitbucket repo
2. `./setup_project.sh`
3. pod install
4. Select scheme `MainApp` 
5. Run

### How to Run Test Cases
1. Select scheme `MainApp`
2. Select `Command` + `U` 


### How to Create Framework
1. `File -> New -> Project` choose a template *iOS* and go to *framework and library*. Select *Framework*
2. Fill the framework name, empty Organization name and write some identifier we will setting identifier later in the *xcconfig* files.
3. Dont forget to *Add To* `mockbank`.xcworkspace files
4. Select the correct of *Group*. You need place the framework inside the *Folder*.
5. Write some YML files if necessary. You can take a look some yml files that already included in each framework, except *CommonSecurity*.

### How to write YML files
Take a look on sample `project-splash.yml` also you can check project spec in XcodeGen [Project Spec](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md). Write yml file will help teams to resolve conflict between pbxproj. It’s like prof of concept content in our xcodeproj.

```yaml
name: AppNavigations
options:
  bundleIdPrefix: com.pankaj
  deploymentTarget:
    iOS: 14.0
targets:
  AppNavigations:
    type: framework
    platform: iOS
    sources:
      - AppNavigations
    dependencies:
     - framework: '${BUILT_PRODUCTS_DIR}/Payment.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Topup.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Dashboard.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Authentication.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Splash.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Common.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/Domains.framework'
       embed: false
       codeSign: false
     - framework: '${BUILT_PRODUCTS_DIR}/DataService.framework'
       embed: false
       codeSign: false
       
    scheme:
      testTargets:
      - AppNavigationsTests
  AppNavigationsTests:
    type: bundle.unit-test
    platform: iOS
    dependencies:
      - target: AppNavigations
    sources:
      - AppNavigationsTests
```

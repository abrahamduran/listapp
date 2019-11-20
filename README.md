![listapp-logo](https://github.com/abrahamduran/listapp/blob/master/ListApp/Assets.xcassets/logo-yellow.imageset/logo-yellow.png?raw=true)

## Simple Shopping List App

ListApp is a relatively simple app to manage your shopping list. The app was developed as part of an interview process.

The design's guidelines for the app can be reviewed in the file `listapp.pdf`. These guidelines were provided to me as part of the requirements.

### Requirements

* The app must use Back4App as the backend.
* The app must follow the guidelines.
* The app must allow users to manage their shopping list.

### Use cases

* An registered user should be able to log in.
* A new user should be able to sign up.
* A logged user should be able to see its shopping list.
* A logged user should be able to mark items in the list as completed.
* A logged user should be able to add new items to the shopping list.
* A logged user should be able to delete an item from the shopping list.
* A logged user should be able to update its profile.

## Running the project

The project requires some initial set-up. First, you need to create an account in [Back4App](https://www.back4app.com), or log in if you already have an account.

### Setting up Back4App

In the Back4App dashboard you need to do 3 things:

1. In the database browser, create a class named `ShoppingItem`.
2. Under the `ShoppingItem`'s class, create three columns:
    * `userId` of type `String`.
    * `name` of type `String`.
    * `isCompleted` of type `Boolean`.
3. Under the `User`'s class, create a column named `fullName` of type `String`.

### Setting up the app

One crucial step to set up the project is to install its dependencies. I used Cocoapods to manage them. In case you need help installing Cocoapods, please refer to their [documentation](https://cocoapods.org).

To install the project dependencies, please run the following:

``` bash
pod install
```

And proceed to open the workspace:

``` bash
open ListApp.xcworkspace
```

After having done that, go to Back4App and gather your keys from the API Reference. These keys are:

* Application ID
* Client key
* Server Url

> For the time being, the `Server Url` is a constant value, `https://parseapi.back4app.com`, in case this were to be changed in the future, refer to the Back4App documentation.

With your keys in hand, open the `AppDelegate.swift` and set the keys accordingly.

And, you are done!

P.S.: don't forget to set the development team before running the app.

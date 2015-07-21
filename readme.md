[TOC]
#Dependencies
This code requires the `Just` module from swift. You can find it [here](https://github.com/JustHTTP/Just)

# Setup
This is a whole xcode project with a sample application, the relevant module is `L2pAccess.swift`

If you wish to use it, just copy the file into your project and set `var clientID` at the beginning of the file to your client id.


# Workflow

The OAuth workflow is the following:

1. Obtaining a user code
2. Obtaining an OAuth access token
3. Calling the API

and optionally

* Refreshing the token
* validating the token
* invalidating the token

## Obtaining a user code

The first thing you will have to do is to let the user authorize your application.
For that you have to provide him with a web page to login and authorize. To do that 
call the `obtainUserCode(callback)` function. Example:

 ```swift
userCodeReturn = obtainUserCode()
 ```

The `userCodeReturn` object stores the information sent back by the server and stores the following fields:

* `device_code` : The code of the current device, will be used in later processes
* `user_code` : The user code for verification
* `verification_url` : An URL to pass to the user, so that he can authorize the app
* `expires_in` : Time when the codes will expire
* `interval` : Polling interval to get Auth token
* `error` : Boolean set to true if something went wrong

These are accessed in a normal swift fashion, that is for example `response.device_code`.

## Obtaining OAuth tokens

After the user has authorize the app you are ready to request an OAuth token. This is done using the
`getTokens(userCodeReturn)` function. The userCodeReturn is the one returned from the previous step. 

There are two distinct errors "error: authorization pending", when the user has not yet authorized the app or "error: slow down" when the polling was done too fast.


If there was no error the returned object has the following fields:

* `access_token` : The access token used for the API
* `token_type` : The type of the token (unused here but will always be "bearer")
* `expires_in` : When the token will expire
* `refresh_token` : The refresh token to request an new access token

Example:

```swift
userToken = getUserToken(userCodeReturn)
println("access Token: " + userToken.access_token)
```

## Accessing the API
Accessing the API is done via the userToken. There is a general method that takes a url as input called `callAPI(url,userToken)`. 

The response is dependent on the call, please refer to the L2P API documentation for further information.

## Refreshing a token
If the access token timed out, it is possible to request a new one using the refresh token, this is done via `refreshToken(userToken)`.

The method does not return anything, the access_token field if the `userToken` gets updated to the new value


If the refresh token expired (after 6 month) you will get `"error": "authorization invalid."`

## Token validation

If you wish to see if a token is valid, call the `tokenIsValid(accessToken)` function. This method will return `true` or `false`.

## Token invalidation
If you are sure that you no longer want to use the API for this user, you can destroy the access and refresh token using the function `invalidateToken(userToken)`. This method does not return anything

# Example
Here is an example of the workflow:

```swift

    @IBAction func showUrlButtonClicked() {
            println("request userCode")
            //obtain userCode
            userCodeReturn = obtainUserCode()
        
            //accessing fields
            println("device code: " + userCodeReturn.device_code)
            println("user code: " + userCodeReturn.user_code)
            println("url: " + userCodeReturn.verification_url) //show this url to your user
            println("expires in: \(userCodeReturn.expires_in)")
      
        
        
        
    }
    
    
    @IBAction func authUserClicked() {
        println("request OAuth Token with device code: " + userCodeReturn.device_code)
        userToken = getUserToken(userCodeReturn)
        println("")
        println("access Token: " + userToken.access_token)
        println("status: " + userToken.status)
        println("expires in: \(userToken.expires_in)")
    }

```

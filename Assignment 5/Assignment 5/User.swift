//
//  User.swift
//  Assignment 5
//
//  Created by Aashay Pawar on 18/02/24.
//

import Foundation
struct User {
    let username: String
    let password: String
}

func login() -> Bool {
    print("############ Welcome to Music Player! ############")
    print("Username:")
    guard let username = readLine(), !username.isEmpty else {
        print("Username cannot be empty.")
        return false
    }
    print("Password:")
    guard let password = readLine(), !password.isEmpty else {
        print("Password cannot be empty.")
        return false
    }
    
    if username == validUser.username && password == validUser.password {
        return true
    } else {
        print("Invalid username or password.")
        return false
    }
}

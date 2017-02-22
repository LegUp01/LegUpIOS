//
//  ViewController.swift
//  LegUp
//
//  Created by Ayanna Kosoko on 2/7/17.
//  Copyright © 2017 Ayanna Kosoko. All rights reserved.
//

import UIKit
import AWSCore
import FacebookCore
import FacebookLogin

class ViewController: UIViewController, LoginButtonDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check if there is a token, if not, put in login button
        if let token = AccessToken.current
        {
            // Fetch Profile and put user's name into welcome screen dialogue
            print("You're already logged in! Fetching profile...")
            fetchProfile()
        }
        else
        {
            let loginButton = LoginButton(readPermissions:[.publicProfile, .email, .userFriends])
            loginButton.delegate = self
            loginButton.center = self.view.center
            
            view.addSubview(loginButton)
        }
    }
    
    /*!
     Uses FB API's GraphRequest to request user info
     @return Returns String of user's name
     */
    func fetchProfile()
    {
        let params = ["fields" : "email, picture.type(large), id, name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult
            {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue
                {
                    print("Response Dictionary: ", responseDictionary)
                    
                    print("NAME: ", responseDictionary["name"])
                    print("EMAIL: ", responseDictionary["email"])
                    // Safely unwrapping picture url.
                    if let picture = responseDictionary["picture"] as? Dictionary<String,Any>, let data = picture["data"] as? Dictionary<String,Any>, let url = data["url"] as? String
                    {
                        print("URL: ", url)
                    }
                }
                break
            }
        }
    }
    
    // Function needed for ViewController to be a LoginButtonDelegate
    func loginButton(_ loginButton: LoginButton!,
                     didCompleteWith result: LoginResult!,
                     error: Error!)
    {
        if error != nil
        {
            print(error.localizedDescription)
        }
    }
    
    // Function needed for ViewController to be a LoginButtonDelegate
    func loginButtonWillLogin(_ loginButton: LoginButton!) -> Bool {
        return true
    }
    
    // Function needed for ViewController to be a LoginButtonDelegate
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton,
                                     result: LoginResult)
    {
        print("Logged In")
        print("Fetching Profile...")
        fetchProfile()
    }
    
    // Function needed for ViewController to be a LoginButtonDelegate
    func loginButtonDidLogOut(_ loginButton: LoginButton)
    {
        print("Logged Out")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

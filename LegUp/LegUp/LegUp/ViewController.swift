//
//  ViewController.swift
//  LegUp
//
//  Created by Ayanna Kosoko on 2/7/17.
//  Copyright © 2017 Ayanna Kosoko. All rights reserved.
//

import UIKit
import AWSDynamoDB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dynamoTest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dynamoTest() {
        let dynamodb = AWSDynamoDB.default()
        let listTableInput = AWSDynamoDBListTablesInput()
        dynamodb.listTables(listTableInput!).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error occurred: \(error)")
                return nil
            }
            let listTablesOutput = task.result!
            
            for tableName in listTablesOutput.tableNames! {
                //fetch each table name
                print("\(tableName)")
            }
            return nil
        }
    }
    


}


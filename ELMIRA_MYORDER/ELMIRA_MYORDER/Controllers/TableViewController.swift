//
//  TableViewController.swift
//  ELMIRA_MYORDER
//
//  Created by Elmira Sarrafi on 2022-05-16.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    private var orderList : [Orders] = [Orders]()
    private let dbHelper = DBHelper.getInstance()
    
    // MARK: Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fetchAllOrders()
        self.tableView.rowHeight = 60
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        
        if indexPath.row < orderList.count{
            
            let currentTask = self.orderList[indexPath.row]
            
            cell.lblSize.text = currentTask.coffee_size
            cell.lblType.text = currentTask.coffee_type
            cell.lblQuantity.text = "Quantity: \(currentTask.quantity)"

        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //delete the task
        
        if (editingStyle == UITableViewCell.EditingStyle.delete && indexPath.row < self.orderList.count){
            self.deleteOrderFromList(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if indexPath.row < self.orderList.count{
            let order = self.orderList[indexPath.row]
            customAlert(indexPath: indexPath, title: "Change the quantity of order", message: "Enter new quantity")
            self.dbHelper.updateOrder(updatedOrder: self.orderList[indexPath.row])
            self.fetchAllOrders()
        }
    }
    
    // MARK: Helper functions
    
    private func fetchAllOrders(){
        let data = self.dbHelper.getAllOrders()
        
        if ( data != nil){
            self.orderList = data!
            self.tableView.reloadData()
        }else{
            print(#function, "No data received from DB")
        }
    }
    
    private func deleteOrderFromList(indexPath: IndexPath){
        self.dbHelper.deleteOrder(id: self.orderList[indexPath.row].id!)
        self.fetchAllOrders()
    }
    
    private func updateOrderInList(indexPath: IndexPath, quantity: Int16){//, size: String, type: String){
        self.orderList[indexPath.row].quantity = quantity
//        self.orderList[indexPath.row].coffee_size = size
//        self.orderList[indexPath.row].coffee_type = type

        self.dbHelper.updateOrder(updatedOrder: self.orderList[indexPath.row])
        self.fetchAllOrders()
    }
    private func customAlert(indexPath: IndexPath?, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "New quantity"
                textField.keyboardType = .numberPad
            }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self]_ in
            if let quantityText: Int16 = Int16((alert.textFields?[0].text)!){
                if(quantityText != 0){
                    updateOrderInList(indexPath: indexPath!, quantity: quantityText)

                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

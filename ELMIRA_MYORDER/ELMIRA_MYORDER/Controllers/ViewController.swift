//
//  ViewController.swift
//  ELMIRA_MYORDER
//
//  Created by Elmira Sarrafi on 2022-05-16.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate {
    
    private let dbHelper = DBHelper.getInstance()

    // MARK: Outlets
    
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var pickerSize: UIPickerView!
    
    
    
    let coffeeTypes = ["Dark Roast","Original Blend","Valilla","Latte", "Moca"]
    let coffeeSize = ["Small", "Medium", "Larg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerType.dataSource = self
        self.pickerType.delegate = self

        self.pickerSize.dataSource = self
        self.pickerSize.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Orders ", style: .plain, target: self, action: #selector(ordersList))    }


    @objc func ordersList() {
            guard let ordersList = storyboard?.instantiateViewController(withIdentifier: "OrderList") as? TableViewController else {
                print("Cannot Find Next Screen")
                return
            }
            navigationController?.pushViewController(ordersList, animated: true)
        }
   
    // MARK: - Pickers data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            //number of columns
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            //number of rows of data
            if pickerView.tag == 0 {
                return coffeeTypes.count
            } else {
                return coffeeSize.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 0 {
                return coffeeTypes[row]
            } else {
                return coffeeSize[row]
            }
           }
    
    // MARK: Actions
    
    @IBAction func confirmOrderPushed(_ sender: Any) {
        
        let type = coffeeTypes[self.pickerType.selectedRow(inComponent: 0)]
        let size = coffeeSize[self.pickerSize.selectedRow(inComponent: 0)]
        if (txtQuantity.text == ""){
            self.displayCustomAlert(indexPath: nil, title: "ERORR", message: "Enter quantity", type: size, size: size, quantity: 0)
            txtQuantity.text = ""
            return
        }
        let quantity = txtQuantity.text
        self.displayCustomAlert(indexPath: nil, title: "New Order", message: "Add the order to the list?", type: type, size: size, quantity: Int16(quantity!)!)
        txtQuantity.text = ""
    }
    
    
    // MARK: Helper functions
    
    private func addOrderToList(type: String, size: String, quantity: Int16){
        self.dbHelper.insertOrder(type: type, size: size, quantity: quantity)
    }
    private func displayCustomAlert(indexPath: IndexPath?, title: String, message: String, type: String, size: String, quantity: Int16){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(quantity == 0){
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
        }else {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.addOrderToList(type: type, size: size, quantity: quantity)
                
            }))
        }
        
        
        self.present(alert, animated: true, completion: nil)
    }
}


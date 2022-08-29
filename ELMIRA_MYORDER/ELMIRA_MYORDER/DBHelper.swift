//
//  DBHelper.swift
//  ELMIRA_MYORDER
//
//  Created by Elmira Sarrafi on 2022-05-16.
//

import Foundation
import CoreData
import UIKit

class DBHelper{
    
    private static var shared : DBHelper?
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "Orders"
    
    static func getInstance() -> DBHelper{
        
        if shared == nil{
            //initialize the object
            shared = DBHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
        
        return shared!
    }
    private init(context : NSManagedObjectContext){
        self.moc = context
    }
    
    func getAllOrders() -> [Orders]?{
        let fetchRequest = NSFetchRequest<Orders>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched Data : \(result as [Orders])")
            
            return result as [Orders]
            
        }catch let error as NSError{
            print(#function, "Could not fetch the data \(error)")
        }
        
        return nil
    }
    func insertOrder(type: String, size: String, quantity: Int16){
        do{
            
            let orderToBeInserted = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! Orders
            
            orderToBeInserted.coffee_type = type
            orderToBeInserted.coffee_size = size
            orderToBeInserted.date = Date()
            orderToBeInserted.quantity = quantity
            orderToBeInserted.id = UUID()
            
            if self.moc.hasChanges{
                try self.moc.save()
                
                print(#function, "Data is saved successfully in CoreData")
            }
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    func searchOrder(id : UUID) -> Orders?{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                print(#function, "Matching object found")
                return result.first as? Orders
            }
            
        }catch let error as NSError{
            print(#function, "Unable to search for order \(error)")
        }
        
        return nil
    }
    func deleteOrder(id : UUID){
        //search for order using id to obtain the object
        let searchResult = self.searchOrder(id: id)
        
        //perform delete operation using object, if found
        if (searchResult != nil){
            //matching order found
            do{
                
                self.moc.delete(searchResult!)
                try self.moc.save()
                
                print(#function, "Order deleted successfully")
                
            }catch let error as NSError{
                print(#function, "Could not delete the Order \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
    func updateOrder(updatedOrder: Orders){
        let searchResult = self.searchOrder(id: updatedOrder.id! as UUID)
        
        if (searchResult != nil){
            do{
                
                let OrderToUpdate = searchResult!
                
//                OrderToUpdate.coffee_type = updatedOrder.coffee_type
//                OrderToUpdate.coffee_size = updatedOrder.coffee_size
                OrderToUpdate.quantity = updatedOrder.quantity
                
                try self.moc.save()
                
                print(#function, "Order updated successfully")
                
            }catch let error as NSError{
                print(#function, "Could not update the order \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
}

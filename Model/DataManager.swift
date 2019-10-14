//
//  MarketManager.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/11.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

enum APIString: String {
    case getMarketingHotsAPI = "https://api.appworks-school.tw/api/1.0/marketing/hots"
    case getProductLisAPI = "https://api.appworks-school.tw/api/1.0/products/"
    case postUserSignin = "https://api.appworks-school.tw/api/1.0/user/signin"
    case postOrderCheckOut = "https://api.appworks-school.tw/api/1.0/order/checkout"
}

enum GetDataErrorType: Error {
    case httpError
    case apiResponseError
    case decodeError
}

enum ProductTpye: String {
    case women
    case men
    case accessories
}

protocol MarketManagerDelegate: class {
    func manager(_ manager: MarketManager, didGet marketingHots: [HotProductData])
    
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    weak var delegate: MarketManagerDelegate?
    
    func getMarketingHots() {
        let urlObject = URL(string: APIString.getMarketingHotsAPI.rawValue)
        if let url = urlObject {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let resultsData = try decoder.decode(HotResultsData.self, from: data)
                        if let delegate = self.delegate {
                            delegate.manager(self, didGet: resultsData.data)
                        }
                    } catch {
                        if let delegate = self.delegate {
                            delegate.manager(self, didFailWith: error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

class ProductManager {
    struct DataPassHelper {
        var handler: ((ProductListResultsData) -> Void)?
    }
    
    var dataPassHelper = DataPassHelper()
    
    func getProductList(paging index: String?, product type: ProductTpye) {
        var params: Parameters = ["": ""]
        if let index = index {
            params = ["paging": index]
        }
        let urlStr = APIString.getProductLisAPI.rawValue + type.rawValue
        AF.request(urlStr, parameters: params).responseJSON { (response) in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(ProductListResultsData.self, from: data)

                    self.dataPassHelper.handler?(resultData)
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

var storageManager = StorageManager.shared

//Todo: 可練習塞 array 進 CoreData
class StorageManager: NSObject {
   
    let persistentContainer: NSPersistentContainer!
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    static let shared = StorageManager()
 
    var shoppingCartList = [NSManagedObject]() {
        didSet {
            self.shoppingCartListCount = shoppingCartList.count
        }
    }
    
    var shoppingCartListCount = 0
    
    func insertShoppingCartProduct(entity: String, orderProduct: OrderProduct) {
        guard let attributeInfo = orderProduct.convertToDict() else { return }
        let object = self.insert(entity: entity, attributeInfo: attributeInfo)
        self.shoppingCartList.append(object)
        self.saveContext()
    }
    
    func selectAll(entity: String) -> [NSManagedObject]? {
        return self.select(entity: entity, predicate: nil, sort: nil, limit: nil)
    }
    
    func deleteShoppingCartProduct(entity: String, index: Int) {
        let object = self.shoppingCartList[index]
        self.context.delete(object)
        self.shoppingCartList.remove(at: index)
        self.saveContext()
    }
    
    func clearShoppingCart() {
        for object in self.shoppingCartList {
            self.context.delete(object)
        }
        self.shoppingCartList = [NSManagedObject]()
        self.saveContext()
    }
    
    func insert(entity: String, attributeInfo: [String: String]) -> NSManagedObject {
        
        let insertObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: context)
        
        for (key, value) in attributeInfo {
            let type = insertObject.entity.attributesByName[key]?.attributeType
            
            if type == .integer16AttributeType
                || type == .integer32AttributeType
                || type == .integer64AttributeType {
                
                insertObject.setValue(Int(value), forKey: key)
            } else if type == .doubleAttributeType
                || type == .floatAttributeType {
                
                insertObject.setValue(Double(value), forKey: key)
            } else if type == .booleanAttributeType {
                
                insertObject.setValue( value == "true" ? true : false, forKey: key)
            } else {
                
                insertObject.setValue(value, forKey: key)
            }
        }
        return insertObject
    }
    
    func select(entity: String,
                predicate: String?,
                sort: [[String: Bool]]?,
                limit: Int?) -> [NSManagedObject]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        if let predicate = predicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        if let inputSorts = sort {
            var usedSorts = [NSSortDescriptor]()
            for inputSort in inputSorts {
                for (key, value) in inputSort {
                    usedSorts.append(NSSortDescriptor(key: key, ascending: value))
                }
            }
            request.sortDescriptors = usedSorts
        }
        
        if let limitNumber = limit {
            request.fetchLimit = limitNumber
        }
        
        do {
            return try context.fetch(request) as? [NSManagedObject]
        } catch {
            fatalError("\(error)")
        }
    }
    
    func update(entity: String, predicate: String?, attributeInfo: [String: String]) {
        if let selectResults = self.select(entity: entity, predicate: predicate, sort: nil, limit: nil) {
            for selectResult in selectResults {
                for (key, value) in attributeInfo {
                    let type = selectResult.entity.attributesByName[key]?.attributeType
                    
                    if type == .integer16AttributeType
                        || type == .integer32AttributeType
                        || type == .integer64AttributeType {
                        
                        selectResult.setValue(Int(value), forKey: key)
                    } else if type == .doubleAttributeType
                        || type == .floatAttributeType {
                        
                        selectResult.setValue(Double(value), forKey: key)
                    } else if type == .booleanAttributeType {
                        
                        selectResult.setValue( value == "true" ? true : false, forKey: key)
                    } else {
                        
                        selectResult.setValue(value, forKey: key)
                    }
                }
            }
        }
    }
    
    func delete(entity: String, predicate: String?) {
        if let selectResults = self.select(entity: entity, predicate: predicate, sort: nil, limit: nil) {
            for selectResult in selectResults {
                context.delete(selectResult)
            }
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
}

class UserFacebookLogin {
    struct DataPassHelper {
        var handler: ((LoginResult) -> Void)?
    }
    
    var dataPassHelper = DataPassHelper()
    
    func postFacebookToken(accessToken: String) {
        
        let params: Parameters = ["provider": "facebook", "access_token": accessToken]
        let headers: HTTPHeaders = ["Content-type": "application/json"]
        let urlStr = APIString.postUserSignin.rawValue
        AF.request(urlStr,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil).responseJSON { (response) in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(LoginResult.self, from: data)
                    self.dataPassHelper.handler?(resultData)
                } catch {
                    print(error)
                }
            }
        }
    }

}

class OrderCheckOut {
    struct DataPassHelper {
        var handler: ((Bool) -> Void)?
    }
    
    var dataPassHelper = DataPassHelper()
    
    func postOrderCheckOut(token: String, orderData: OrderCheckOutInfo) {

        var request = URLRequest(url: URL(string: APIString.postOrderCheckOut.rawValue)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(orderData)

            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }
                
                guard let httpReponse = response as? HTTPURLResponse else {
                    return
                }
                
                let statusCode = httpReponse.statusCode
                
                if statusCode >= 200 && statusCode < 300 {
                    print("Success")
                } else if statusCode >= 400 && statusCode < 500 {
                    print("Error")
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                
                self.dataPassHelper.handler?(true)
            }
            task.resume()
        } catch {
            print(error)
            self.dataPassHelper.handler?(false)
        }
    }
    
}

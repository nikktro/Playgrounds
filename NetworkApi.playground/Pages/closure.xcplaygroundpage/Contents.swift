//: [Previous](@previous)

import Foundation

protocol ShopAPI {

  func fetchWith(completion: ([String]) -> Void)

  func getCountOfProductsAsync(completion: (Int) -> Void)

}

class ShopManager {

  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatistic(completion: @escaping ([String: Int]) -> Void) {
    var shopDict = [String: Int]()

    DispatchQueue.global(qos: .utility).async {
      self.api.fetchWith { names in
        for name in names {
          self.api.getCountOfProductsAsync { shopCount in
            shopDict[name] = shopCount
          }
        }
        completion(shopDict)
      }
    }

  }

}

//: [Next](@next)

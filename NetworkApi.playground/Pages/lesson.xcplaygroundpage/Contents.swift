//: [Previous](@previous)

import UIKit

protocol ShopAPI {

  func fetchNames() -> [String]

  func fetchWith(completion: ([String]) -> Void)

  func getCountOfProducts(name: String) -> Int

  func getCountOfProductsAsync(completion: (Int) -> Void)

}

class ShopManager {

  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatistic1() -> [String: Int] {
    var shopDict = [String: Int]()
    let names = api.fetchNames()

    for name in names {
      let shopCount = api.getCountOfProducts(name: name)
      shopDict[name] = shopCount
    }

    return shopDict
  }


  func makeStatistic2() -> [String: Int] {
    var shopDict = [String: Int]()
    api.fetchWith { names in
      for name in names {
        api.getCountOfProductsAsync { shopCount in
          shopDict[name] = shopCount
        }
      }
    }

    return shopDict
  }
  
  // 1. использовать dispatch group с серийной очередью
  // 2. полностью вынести на второй поток (utility) сделать makeStat возвращаемым через closure
  // 3. async await
}

//: [Next](@next)

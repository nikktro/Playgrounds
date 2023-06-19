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

}

//: [Next](@next)

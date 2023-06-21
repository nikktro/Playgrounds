//: [Previous](@previous)

import Foundation

protocol ShopAPI {

  func fetchWith(completion: @escaping ([String]) -> Void)

  func getCountOfProductsAsync(completion: @escaping(Int) -> Void)

}

class ShopManager {

  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatistic(completion: @escaping ([String: Int]) -> Void) {
    var shopDict = [String: Int]()

    let utilityQueue = DispatchQueue.global(qos: .utility)
    let countOfProductsGroup = DispatchGroup()

    utilityQueue.async {
      self.api.fetchWith { names in

        for name in names {
          countOfProductsGroup.enter()
          self.api.getCountOfProductsAsync { count in
            shopDict[name] = count
            countOfProductsGroup.leave()
          }
        }

        countOfProductsGroup.notify(queue: utilityQueue) {
          completion(shopDict)
        }
      }
    }
  }
}

class Api: ShopAPI {
  func fetchWith(completion: @escaping([String]) -> Void) {
    DispatchQueue.global().async {
      sleep(UInt32.random(in: 1...3))
      completion(["One", "Two", "Three"])
    }
  }

  func getCountOfProductsAsync(completion: @escaping(Int) -> Void) {
    DispatchQueue.global().async {
      let random = Int.random(in: 1...5)
      sleep(UInt32(random))
      completion(random)
    }
  }
}

// instantiation api
let api = Api()
let shopManager = ShopManager(api: api)

// solution closure
shopManager.makeStatistic {
  print($0)
}

//: [Next](@next)

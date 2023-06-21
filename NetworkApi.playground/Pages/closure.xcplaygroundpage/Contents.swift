//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



protocol ShopAPI {

  func fetchWith(completion: @escaping ([String]) -> Void)

  func getCountOfProducts(for name: String, completion: @escaping(Int) -> Void)

}

final class ShopManager {

  private let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatistic(completion: @escaping ([String: Int]) -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    var shopDict = [String: Int]()

    let utilityQueue = DispatchQueue.global(qos: .utility)
    let countOfProductsGroup = DispatchGroup()

    utilityQueue.async {
      self.api.fetchWith { names in

        for name in names {
          countOfProductsGroup.enter()
          self.api.getCountOfProducts(for: name) { count in
            shopDict[name] = count
            countOfProductsGroup.leave()
          }
        }

        countOfProductsGroup.notify(queue: utilityQueue) {
          completion(shopDict)
          print("Fetch took \(CFAbsoluteTimeGetCurrent() - startTime) seconds")
        }
      }
    }
  }
}

final class Api: ShopAPI {
  func fetchWith(completion: @escaping([String]) -> Void) {
    DispatchQueue.global().async {
      let random = Int.random(in: 1...3)
      sleep(UInt32(random))
      completion(["One", "Two", "Three"])
    }
  }

  func getCountOfProducts(for name: String, completion: @escaping(Int) -> Void) {
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

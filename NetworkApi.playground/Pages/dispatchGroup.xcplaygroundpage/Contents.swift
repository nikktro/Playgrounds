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

  func makeStatisticWithGroup() -> [String: Int] {
    var shopDict = [String: Int]()
    let taskGroupFetchNames = DispatchGroup()
    let taskGroupFetchCount = DispatchGroup()

    taskGroupFetchNames.enter()
    api.fetchWith { names in

      for name in names {
        taskGroupFetchCount.enter()
        self.api.getCountOfProducts(for: name) { shopCount in
          shopDict[name] = shopCount
          taskGroupFetchCount.leave()
        }
      }

      taskGroupFetchNames.leave()
    }

    taskGroupFetchNames.wait()
    taskGroupFetchCount.wait()

    return shopDict
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
let startTime = Date()
let result = shopManager.makeStatisticWithGroup()
print(result)
print("Fetch took \(Date().timeIntervalSince(startTime)) seconds")

//: [Next](@next)

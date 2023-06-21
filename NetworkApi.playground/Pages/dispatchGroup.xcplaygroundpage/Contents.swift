//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



protocol ShopAPI {

  func fetchWith(completion: ([String]) -> Void)

  func getCountOfProducts(for name: String, completion: (Int) -> Void)

}

class ShopManager {

  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatisticWithGroup() -> [String: Int] {
    var shopDict = [String: Int]()

    let taskGroup = DispatchGroup()

    taskGroup.enter()
    api.fetchWith { names in
      for name in names {
        api.getCountOfProducts(for: name) { shopCount in
          shopDict[name] = shopCount
        }
      }
      taskGroup.leave()
    }

    taskGroup.wait()

    return shopDict
  }

}

//: [Next](@next)

//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



protocol ShopAPI {

  func fetchWith(completion: @escaping ([String]) -> Void) async

  func getCountOfProductsAsync(completion: (Int) -> Void)

}

class ShopManager {

  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatisticAsync() async -> [String: Int] {
    var shopDict = [String: Int]()

    let taskGroup = DispatchGroup()

    taskGroup.enter()
    await api.fetchWith { names in
      for name in names {
        self.api.getCountOfProductsAsync { shopCount in
          shopDict[name] = shopCount
        }
      }
      taskGroup.leave()
    }

    taskGroup.wait() // TODO: Use a TaskGroup instead

    return shopDict
  }

}

class Api: ShopAPI {
  func fetchWith(completion: @escaping ([String]) -> Void) async {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      completion(["One", "Two", "Three"])
    }
  }

  func getCountOfProductsAsync(completion: (Int) -> Void) { // TODO: make async
      completion(Int.random(in: 0...100))
  }
}


// instantiation api
let api = Api()
let shopManager = ShopManager(api: api)

// solution with deprecated async (is deprecated)
async {
  let result = await shopManager.makeStatisticAsync()
  print(result)
}

// solution with Task
Task {
  let result = await shopManager.makeStatisticAsync()
  print(result)
}

//: [Next](@next)

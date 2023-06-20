//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



protocol ShopAPI {

  func fetchNames() async -> [String]

  func getCountOfProductsAsync() async -> Int

}

class ShopManager {
  let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatisticAsync() async -> [String: Int] {
    var shopDict = [String: Int]()

    let names = await api.fetchNames()
    for name in names {
      let count = await api.getCountOfProductsAsync()
      shopDict[name] = count
    }

    return shopDict
  }
}

class Api: ShopAPI {
  func fetchNames() async -> [String] {
    sleep(1)
    return ["One", "Two", "Three"]
  }

  func getCountOfProductsAsync() async -> Int {
    sleep(1)
    return Int.random(in: 0...100)
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

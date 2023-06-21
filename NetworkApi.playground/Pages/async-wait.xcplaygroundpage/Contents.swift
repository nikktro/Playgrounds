//: [Previous](@previous)

import Foundation
import _Concurrency
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



protocol ShopAPI {

  func fetchShopNames() async -> [String]

  func getCountOfProducts(for name: String) async -> Int

}

final class ShopManager {
  private let api: ShopAPI

  init(api: ShopAPI) {
    self.api = api
  }

  func makeStatisticAsync() async -> [String: Int] {
    var shopDict = [String: Int]()
    var nameIndex = 0

    let names = await api.fetchShopNames()

    return await withTaskGroup(of: Int.self) { group in
      for name in names {
        group.addTask { await self.api.getCountOfProducts(for: name) }
      }

      for await count in group {
        shopDict[names[nameIndex]] = count
        nameIndex += 1
      }

      return shopDict
    }
  }

}

final class Api: ShopAPI {
  func fetchShopNames() async -> [String] {
    let random = Int.random(in: 1...3)
    sleep(UInt32(random))
    return ["One", "Two", "Three"]
  }

  func getCountOfProducts(for name: String) async -> Int {
    let random = Int.random(in: 1...5)
    sleep(UInt32(random))
    return random
  }
}

// instantiation api
private let api = Api()
private let shopManager = ShopManager(api: api)

// solution with Task
Task {
  let startTime = CFAbsoluteTimeGetCurrent()
  let result = await shopManager.makeStatisticAsync()
  print(result)
  print("Fetch took \(CFAbsoluteTimeGetCurrent() - startTime) seconds")
}

//: [Next](@next)

//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Ian on 2021/12/27.
//

import Foundation
import CoreData

class PortfolioDataService {

    // MARK: - Properties

    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"

    @Published var savedEntities: [PortfolioEntity] = []

    // MARK: - Initializer

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print("[ERROR] Loading Core Data: \(error.localizedDescription)")
            }
            self.getPortfolio()
        })
    }

    // MARK: - Methods

    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { ($0.coinID ?? "") == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
}

// MARK: - Private Extension
private extension PortfolioDataService {
    func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let err {
            print("[ERROR] Fetching Portfolio Entities: \(err.localizedDescription)")
        }
    }

    func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChange()
    }

    func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChange()
    }

    func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChange()
    }

    func save(_ completion: (() -> Void)? = nil) {
        do {
            try container.viewContext.save()
        } catch let err {
            print("[ERROR] Saving to Core Data: \(err.localizedDescription)")
        }
    }

    func applyChange() {
        save { [weak self] in self?.getPortfolio() }
    }
}

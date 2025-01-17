//
//  Model.swift
//  Revisadinho
//
//  Created by Hiago Chagas on 14/09/21.
//  swiftlint:disable line_length

import Foundation
import CoreData

public class Model {

    static let shared = Model()

    private init() { }

    private func getMaintenances(viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> [MaintenanceDAO] {
        let maintenances = MaintenanceDAO.fetchAllMaintenances(viewContext: viewContext)
        return maintenances
    }

    public func getMaintenances(byMonth month: Int, andYear year: Int, viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> [MaintenanceDAO] {
        let maintenances = getMaintenances(viewContext: viewContext)
        let filteredMaintenances = maintenances.filter {
            return Calendar.current.component(.month, from: $0.date!) == month && Calendar.current.component(.year, from: $0.date!) == year
        }
        return filteredMaintenances
    }

    public func getMaintenances(byStartDate startDate: Date, toDate finishingDate: Date, viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> [MaintenanceDAO] {
        let maintenances = getMaintenances(viewContext: viewContext)
        let filteredMaintenances = maintenances.filter {
            $0.date ?? Date() >= startDate && $0.date ?? Date() <= finishingDate
        }
        return filteredMaintenances
    }

    public func getMaintenances(byUUID uuid: UUID, viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> MaintenanceDAO? {
        let maintenances = getMaintenances(viewContext: viewContext)
        let filteredMaintenance = maintenances.first { $0.id == uuid }
        return filteredMaintenance
    }

    public func createMaintenance(uuid: UUID = UUID(), date: Date, hodometer: Double, maintenanceItens: [Double], viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> MaintenanceDAO? {
        if let maintenance = NSEntityDescription.insertNewObject(forEntityName: "MaintenanceDAO", into: viewContext) as? MaintenanceDAO {
            maintenance.id = uuid
            maintenance.date = date
            maintenance.hodometer = hodometer
            maintenance.maintenanceItens = maintenanceItens
            saveContext(viewContext: viewContext)
            return maintenance
        }
        return nil
    }

    public func deleteMaintenance(byUUID uuid: UUID, viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> Bool {
        if let maintenance = getMaintenances(byUUID: uuid, viewContext: viewContext) {
            viewContext.delete(maintenance)
            saveContext(viewContext: viewContext)
            return true
        }
        return false
    }

    public func updateMaintenance(byUUID uuid: UUID, date: Date? = nil, hodometer: Double? = nil, maintenanceItens: [Double]? = nil, viewContext: NSManagedObjectContext = DatabaseController.shared.viewContext) -> MaintenanceDAO? {
        if let maintenance = getMaintenances(byUUID: uuid, viewContext: viewContext) {
            if let date = date {
                maintenance.date = date
            }
            if let hodometer = hodometer {
                maintenance.hodometer = hodometer
            }
            if let maintenanceItens = maintenanceItens {
                maintenance.maintenanceItens = maintenanceItens
            }
            saveContext(viewContext: viewContext)
            return maintenance
        }
        return nil
    }

    private func saveContext(viewContext: NSManagedObjectContext) {
        try? viewContext.save()
    }
}

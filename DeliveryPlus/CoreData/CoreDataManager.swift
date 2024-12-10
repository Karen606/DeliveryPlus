//
//  CoreDataManager.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DeliveryPlus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveOrder(orderModel: OrderModel, completion: @escaping (Error?) -> Void) {
            let id = orderModel.id
            let backgroundContext = persistentContainer.newBackgroundContext()
            backgroundContext.perform {
                let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                do {
                    let results = try backgroundContext.fetch(fetchRequest)
                    let order: Order
                    
                    if let existingOrder = results.first {
                        order = existingOrder
                    } else {
                        order = Order(context: backgroundContext)
                        order.id = id
                        order.orderNumber = self.generateNextOrderNumber(context: backgroundContext)
                    }
                    
                    order.recipientsName = orderModel.recipientsName
                    order.address = orderModel.address
                    order.product = orderModel.product
                    order.status = Int32(orderModel.status)
                    order.deliveryDate = orderModel.deliveryDate
                    
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
        
        func fetchOrders(completion: @escaping ([OrderModel], Error?) -> Void) {
            let backgroundContext = persistentContainer.newBackgroundContext()
            backgroundContext.perform {
                let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
                do {
                    let results = try backgroundContext.fetch(fetchRequest)
                    var ordersModel: [OrderModel] = []
                    for result in results {
                        let orderModel = OrderModel(id: result.id ?? UUID(), address: result.address, recipientsName: result.recipientsName, product: result.product, deliveryDate: result.deliveryDate, status: Int(result.status), orderNumber: result.orderNumber)
                        ordersModel.append(orderModel)
                    }
                    DispatchQueue.main.async {
                        completion(ordersModel, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
            }
        }
        
        private func generateNextOrderNumber(context: NSManagedObjectContext) -> String {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "orderNumber", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            
            do {
                if let lastOrder = try context.fetch(fetchRequest).first, let lastOrderNumber = lastOrder.orderNumber {
                    let numericPart = lastOrderNumber.dropFirst()  // Remove "#" prefix
                    if let lastNumber = Int(numericPart) {
                        let nextNumber = lastNumber + 1
                        return String(format: "#%04d", nextNumber)
                    }
                }
            } catch {
                print("Failed to fetch last order number: \(error)")
            }
            return "#0001"
        }
    
//    func removeProduct(by id: UUID, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let product = results.first {
//                    backgroundContext.delete(product)
//                    try backgroundContext.save()
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"]))
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func saveEmployee(employeeModel: EmployeeModel, completion: @escaping (Error?) -> Void) {
//        let id = employeeModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let employee: Employee
//                
//                if let existingEmployee = results.first {
//                    employee = existingEmployee
//                } else {
//                    employee = Employee(context: backgroundContext)
//                    employee.id = id
//                }
//                
//                employee.name = employeeModel.name
//                employee.position = Int32(employeeModel.position ?? 1)
//                employee.startOfShift = employeeModel.startOfShift
//                employee.endOfShift = employeeModel.endOfShift
//                employee.datesOfShift = employeeModel.datesOfShift
//                
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchEmployees(completion: @escaping ([EmployeeModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var employeesModel: [EmployeeModel] = []
//                for result in results {
//                    let employeeModel = EmployeeModel(id: result.id ?? UUID(), name: result.name, position: Int(result.position), startOfShift: result.startOfShift, endOfShift: result.endOfShift, datesOfShift: result.datesOfShift)
//                    employeesModel.append(employeeModel)
//                }
//                DispatchQueue.main.async {
//                    completion(employeesModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
//    func saveEvent(eventModel: EventModel, completion: @escaping (Error?) -> Void) {
//        let id = eventModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let event: Event
//                
//                if let existingEvent = results.first {
//                    event = existingEvent
//                } else {
//                    event = Event(context: backgroundContext)
//                    event.id = id
//                }
//                
//                event.name = eventModel.name
//                event.numberGuests = Int64(eventModel.numberGuests ?? 0)
//                event.date = eventModel.date
//                event.startTime = eventModel.startTime
//                event.endTime = eventModel.endTime
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchEvents(completion: @escaping ([EventModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var eventsModel: [EventModel] = []
//                for result in results {
//                    let eventModel = EventModel(id: result.id ?? UUID(), name: result.name, numberGuests: Int(result.numberGuests), date: result.date, startTime: result.startTime, endTime: result.endTime)
//                    eventsModel.append(eventModel)
//                }
//                DispatchQueue.main.async {
//                    completion(eventsModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
}

import UIKit
import Foundation

// Basic program that calculates a statement of a customer's charges at a car rental store.
//
// A customer can have multiple "Rental"s and a "Rental" has one "Car"
// As an ASCII class diagram:
//          Customer 1 ----> * Rental
//          Rental   * ----> 1 Car
//
// The charges depend on how long the car is rented and the type of the car (economy, muscle or supercar)
//
// The program also calculates frequent renter points.
//
//
// Refactor this class how you would see fit.
//
// The actual code is not that important, as much as its structure. You can even use "magic" functions (e.g. foo.sort()) if you want

enum CarType {
    case economy
    case supercar
    case muscle
}

struct Car {
    let title: String
    let priceCode: CarType
}

struct Rental {
    let car: Car
    let daysRented: Int
}

final class Customer {
    let name: String
    private var rentals: [Rental]
    
    init(name: String,
         rentals: [Rental] = []) {
        self.name = name
        self.rentals = rentals
    }
    
    func addRental(_ rental: Rental) {
        rentals.append(rental)
    }
    
    func billingStatement() -> String {
        var totalAmount: Double = 0
        var frequentRenterPoints = 0
        var result = "Rental Record for \(name)\n"
                
        for rental in rentals {
            let thisAmount = amount(for: rental)
            frequentRenterPoints += points(for: rental)
            result += "\t\(rental.car.title)\t\(thisAmount)\n"
            totalAmount += thisAmount
        }
        
        result += "Final rental payment owed \(totalAmount)\n"
        result += "You received an additional \(frequentRenterPoints) frequent customer points"
        return result
    }
    
    private func amount(for rental: Rental) -> Double {
        switch rental.car.priceCode {
        case .economy:
            let baseRate = 80.0
            return baseRate + (rental.daysRented > 2 ? Double(rental.daysRented - 2) * 30.0 : 0)
        case .supercar:
            return Double(rental.daysRented) * 200.0
        case .muscle:
            let baseRate = 200.0
            return baseRate + (rental.daysRented > 3 ? Double(rental.daysRented - 3) * 50.0 : 0)
        }
    }
    
    private func points(for rental: Rental) -> Int {
        var points = 1
        if rental.car.priceCode == .supercar && rental.daysRented > 1 {
            points += 1
        }
        return points
    }
}


let rental1 = Rental(car: Car(title: "Mustang", priceCode: .muscle), daysRented: 5)
let rental2 = Rental(car: Car(title: "Lambo", priceCode: .supercar), daysRented: 20)
let customer = Customer(name: "Liviu")
customer.addRental(rental1)
customer.addRental(rental2)


print(customer.billingStatement())

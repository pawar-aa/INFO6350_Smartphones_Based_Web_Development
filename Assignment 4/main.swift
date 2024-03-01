//Author: Aashay Pawar
//NUID: 002134382
//Email: pawar.aa@northeastern.edu

import Foundation

// SWIFT STRUCTURES:
print("----------SWIFT STRUCTURES:----------\n")
struct Book {
    var title: String
    var author: String
    var pages: Int
    var publicationYear: Int
    
    func displayInfo() -> String {
        return """
        Title: \(title)
        Author: \(author)
        Pages: \(pages)
        Publication Year: \(publicationYear)
        """
    }
}

let books = [
    Book(title: "Hire Me!", author: "Aashay", pages: 20, publicationYear: 2012),
    Book(title: "Smartphones Based Web Development", author: "Ahmed Rabah", pages: 120, publicationYear: 2024),
    Book(title: "A Hustler At Northeastern", author: "Husky", pages: 1234, publicationYear: 1898)
]

for book in books {
    print(book.displayInfo() + "\n")
}

// ------------------------------------------------------------------------------------------------------------

// SWIFT CLASS:
print("\n----------SWIFT CLASS:----------\n")
class Shape {
    func area() -> Double {
        fatalError("Subclasses must override area()")
    }
    
    func perimeter() -> Double {
        fatalError("Subclasses must override perimeter()")
    }
}

class Rectangle: Shape {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    override func area() -> Double {
        return width * height
    }
    
    override func perimeter() -> Double {
        return 2 * (width + height)
    }
}

class Circle: Shape {
    var radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    override func area() -> Double {
        return Double.pi * radius * radius
    }
    
    override func perimeter() -> Double {
        return 2 * Double.pi * radius
    }
}

let rectangle = Rectangle(width: 3, height: 4)
let circle = Circle(radius: 5)

func printDetails(shape: Shape) {
    print("Area: \(shape.area()), Perimeter: \(shape.perimeter())")
}

print("Rectangle:")
printDetails(shape: rectangle)

print("\nCircle:")
printDetails(shape: circle)

// ------------------------------------------------------------------------------------------------------------

// SWIFT PROTOCOLS:
print("\n\n----------SWIFT PROTOCOLS:----------\n")
protocol Vehicle {
    func drive()
}

struct Car: Vehicle {
    func drive() {
        print("I am a car")
    }
}

struct Bike: Vehicle {
    func drive() {
        print("I am a bike")
    }
}

let car = Car()
let bike = Bike()

car.drive()
bike.drive()

protocol ShapeProtocol {
    var name: String { get }
    func area() -> Double
    func perimeter() -> Double
}

class Square: ShapeProtocol {
    var name: String {
        return "Square"
    }
    
    var side: Double
    
    init(side: Double) {
        self.side = side
    }
    
    func area() -> Double {
        return side * side
    }
    
    func perimeter() -> Double {
        return 4 * side
    }
}

class CircleClass: ShapeProtocol {
    var name: String {
        return "Circle"
    }
    
    var radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func area() -> Double {
        return Double.pi * radius * radius
    }
    
    func perimeter() -> Double {
        return 2 * Double.pi * radius
    }
}

let square = Square(side: 4)
let circleClass = CircleClass(radius: 3)

print("\nSquare:")
print("Name: \(square.name)")
print("Area: \(square.area())")
print("Perimeter: \(square.perimeter())")

print("\nCircle:")
print("Name: \(circleClass.name)")
print("Area: \(circleClass.area())")
print("Perimeter: \(circleClass.perimeter())")

// ------------------------------------------------------------------------------------------------------------

// SWIFT EXTENSIONS:
print("\n\n----------SWIFT EXTENSIONS:----------\n")
extension Int {
    func cube() -> Int {
        return self * self * self
    }
}

print(3.cube())

extension String {
    func toInt() -> Int? {
        return Int(self)
    }
}

print("123".toInt() ?? 0) // Output: 123

extension Array where Element: Comparable {
    func minMax() -> (min: Element, max: Element)? {
        guard let min = self.min(), let max = self.max() else {
            return nil
        }
        return (min, max)
    }
}

print([3, 1, 5, 2, 4].minMax() ?? (0, 0))

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }
}

print(Date().formatted())

// ------------------------------------------------------------------------------------------------------------

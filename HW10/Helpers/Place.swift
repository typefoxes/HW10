import CoreLocation

struct Place {
    var name: String
    var imageName: String?
    var color: String
    let latitude:Double
    let longitude: Double
}

extension Place: CustomStringConvertible {
    var description: String {
        "location name: \(name); la: \(latitude); lo: \(longitude)"
    }
}

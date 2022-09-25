import UIKit

class PlacesViewController: UIViewController, PlacesDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var places: [Place] = [
        Place(name: "Tower bridge", imageName: "bridge", color: "#e66a4e", latitude: 51.505364, longitude: -0.075432),
        Place(name: "London eye",                        color: "#6fb087", latitude: 51.503312, longitude: -0.119556),
        Place(name: "The Tower of London",               color: "#65a7c5", latitude: 51.508070, longitude: -0.076016),
        Place(name: "Buckingham Palace",                 color: "#eb7f2c", latitude: 51.501274, longitude: -0.142257),
        Place(name: "Westminster Abbey",                 color: "#c6caca", latitude: 51.499210, longitude: -0.127321)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places[0].imageName = "bridge"
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    @IBAction func showOnMapButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowOnMap", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOnMap" {
            let placesToShow: [Place]
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                placesToShow = [places[indexPath.row]]
            } else {
                placesToShow = places
            }
            let tabbar = segue.destination as! UITabBarController
            if let viewControllers = tabbar.viewControllers?.compactMap({$0 as? PlacesDataSource}) {
                viewControllers.forEach({
                    $0.places = placesToShow
                })
            }
        }
    }
    
}

extension PlacesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        cell.detailTextLabel?.text = "(\(places[indexPath.row].latitude), \(places[indexPath.row].longitude))"
        return cell
    }
}

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowOnMap", sender: tableView.cellForRow(at: indexPath))
    }
}

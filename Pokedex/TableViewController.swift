import UIKit
import PokemonAPI

class TableViewController: UITableViewController {

    private static let tableViewCellReuseIdentifier = "weeeeeee"
    var kantoPokedex = 1...151
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Title", comment: "navigation bar title")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            TableViewCell.self, forCellReuseIdentifier: TableViewController.tableViewCellReuseIdentifier
        )
        

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewController.tableViewCellReuseIdentifier,
            for: indexPath
        ) as? TableViewCell
        else { return UITableViewCell() }


        cell.nameLabel.text = NSLocalizedString("pokemon-name-\(indexPath.row + 1)" , comment: "Pokemon Name")
        
        return cell
    }
     
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        goToPokemonDetailsViewController(pokemonID: indexPath.row + 1)
    }
    
    func goToPokemonDetailsViewController(pokemonID: Int) {
        let detailsViewController = PokemonDetailsViewController()
        detailsViewController.pokemonID = pokemonID
        detailsViewController.title = NSLocalizedString("pokemon-name-\(pokemonID)", comment: "Pokemon Name")

        navigationController?.pushViewController(detailsViewController, animated: true)
    }
      
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kantoPokedex.count
    }

}


import UIKit

class HeroesTableViewController: UITableViewController {
    var name: String?
    var heroes: [Hero] = []
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    var loadingHeroes = false
    var currentPage = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Buscando herois. Aguarde..."
        loadHeroes()
        
        func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        func loadHeroes() {
            loadingHeroes = true
            MarvelAPI.loadHeros(name: name, page: currentPage) { (info) in
                if let info = info {
                    self.heroes += info.data.results
                    self.total = info.data.total
                    print("Total:", self.total, "já incluídos:", self.heroes.count)
                    DispatchQueue.main.async {
                        self.loadingHeroes = false
                        self.label.text = "Não foram encontrados heróis com o nome \(self.name!)"
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableView.backgroundView = heroes.count == 0 ? label : nil
            return heroes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeroTableViewCell
            
            let hero = heroes[indexPath.row]
            cell.prepareCell(with: hero)
            return cell
        }
    }
}

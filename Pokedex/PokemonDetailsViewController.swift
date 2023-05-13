import Foundation
import UIKit
import PokemonAPI



class PokemonDetailsViewController: UIViewController {
    
    var pokemonID: Int?
    
    
    private func getImage(for pokemon: PKMPokemon)  {
        guard let imageURLString = pokemon.sprites?.frontDefault,
              let imageURL = URL(string: imageURLString)
        else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data,
                  let image = UIImage (data: data)
        else { return }
            
            DispatchQueue.main.async {
                self.pokemonImageView.image = image
            }
        }.resume ()
    }
    
    
    private func pokemonTypeLabel(pokemonType: String) -> UILabel {
        
        let label = UILabel()
        
        let localizedString = NSLocalizedString("\(pokemonType)-display-text", comment: "Pokemon Type")
        let preferredLanguage = NSLocale.preferredLanguages[0]
        print(preferredLanguage)
        var widthFactor = 15
        if ["en","en-US"].contains(preferredLanguage) { widthFactor = 11 }
        if ["ja","ja-US"].contains(preferredLanguage) { widthFactor = 20 }

        let labelWidth = CGFloat(widthFactor) * CGFloat(localizedString.count)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.backgroundColor = UIColor(named: pokemonType)
        label.text = localizedString
        label.textColor = UIColor.white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.widthAnchor.constraint(
            equalToConstant: labelWidth
        ).isActive = true

        return label
    }
    
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 210).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        return imageView
    }()
    
    
    private let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = label.font.withSize(40)
        return label
    }()
    

    private let typesRow: UIStackView = {
        let row = UIStackView()
        row.axis = .horizontal
        row.translatesAutoresizingMaskIntoConstraints = false
        row.spacing = 10
        return row
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        PokemonAPI().pokemonService.fetchPokemon(pokemonID ?? 1) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    print(pokemon.types?[0].type?.name ?? "")
                    print("type count: \(pokemon.types?.count ?? 0)")
                    for pokemonType in pokemon.types! {
                        self.typesRow.addArrangedSubview(self.pokemonTypeLabel(pokemonType: pokemonType.type?.name ?? ""))
                    }
                    self.getImage(for: pokemon)
                    self.pokemonNameLabel.text = NSLocalizedString("pokemon-name-\(self.pokemonID ?? 0)", comment: "String")
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let alert = UIAlertController(title: "An error occurred", message: "Failed to load Pokemon. Please check your internet connection and try again.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                }
            }
        }


        view.addSubview(pokemonNameLabel)
        view.addSubview(pokemonImageView)
        view.addSubview(typesRow)
        
        let constraints = [
            pokemonNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 10),
            typesRow.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor),
            typesRow.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
      
    }
}

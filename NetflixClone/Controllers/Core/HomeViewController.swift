//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Chingiz on 19.02.24.
//

import UIKit

enum Sections: Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private var randomTrendingMovie: Title?
    private var heroHeaderView: HeroHeaderUIView?
    
    
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureNavbar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        configureHeroHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                guard let selectedTitle = titles.randomElement() else {return}
                //self?.randomTrendingMovie = selectedTitle
                self?.heroHeaderView?.configure(with: TitleViewModel(titleName: selectedTitle.original_title!, posterURL: selectedTitle.poster_path!))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func configureNavbar() {
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        let imageLogo = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        let image = UIImage(named: "netflixLogo")
        imageLogo.image = image?.withRenderingMode(.alwaysOriginal)
        containerView.addSubview(imageLogo)
        let logoBarButtonItem = UIBarButtonItem(customView: containerView)
        logoBarButtonItem.width = 20
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.Popular.rawValue:
                APICaller.shared.getPopularMovies { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(String(describing: error))
                    }
                }
            
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffSet
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

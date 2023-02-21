//
//  MainViewModel.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//
import Foundation
import UIKit

final class PublicListViewModel {
    
    let cellModel = Observable<[PublicOwnCellModel]>([])
    
    weak var viewController: UIViewController?
    
    let photoService = PhotoService()
    
    var gists = [Gist]()
    
    private var page = 1
    
    private let networkService = NetworkService()
    
    //MARK: - Methods
    
    func getGists() {
        networkService.getGists { [weak self] result in
            switch result {
            case .success(let gistArray):
                guard let self = self else { return }
                self.gists = gistArray
                DispatchQueue.main.async {
                    self.cellModel.value = self.viewModels()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGistForRefreshController() {
        
        networkService.getGists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gistsJSON):
                if gistsJSON.first?.createdAt != self.gists.first?.createdAt && gistsJSON.first?.owner.login != self.gists.first?.owner.login {
                    self.gists.insert(contentsOf: gistsJSON, at: 0)
                    DispatchQueue.main.async {
                        self.cellModel.value = self.viewModels()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGistForPrefetching() {
        page += 1
        networkService.getGistsWithTime(page: page) { [weak self] gistsJSON in
            guard let self = self else { return }
            gistsJSON.forEach { gistJSON in
                if self.gists.contains(where: { $0.id == gistJSON.id }) {
                    print(true)
                } else {
                    //print(gistJSON)
                    self.gists.append(gistJSON)
                    DispatchQueue.main.async {
                        self.cellModel.value = self.viewModels()
                    }
                    
                }
            }
        }
    }
    
    func didSelectGist(_ gistViewModel: PublicOwnCellModel) {
        guard let gist = self.gist(with: gistViewModel) else { return }
        let detailGistViewController = DetailsGistViewController()
        let detailViewModel = DetailViewModel(gist: gist, viewController: detailGistViewController)
        detailGistViewController.viewModel = detailViewModel
        
        self.viewController?.navigationController?.pushViewController(detailGistViewController, animated: true)
    }
    
    private func viewModels() -> [PublicOwnCellModel] {
            return self.gists.compactMap { gist -> PublicOwnCellModel in
//                guard let image = photoService.photo(byUrl: gist.owner.avatarUrl)
//                else {
//                    return MainCellModel(url: "", userName: "", avatarURL: UIImage(systemName: "person")!, createdAt: "", fileName: "")
//                }
                return PublicOwnCellModel(url: gist.url,
                                     userName: gist.owner.login,
                                     avatarURL: photoService.photo(byUrl: gist.owner.avatarUrl) ?? UIImage(),
                                     createdAt: gist.createdAt,
                                     fileName: gist.files.values.first?.filename ?? "")
            }
    }
    
    private func gist(with viewModel: PublicOwnCellModel) -> Gist? {
        return self.gists.first { viewModel.url == $0.url }
    }
}


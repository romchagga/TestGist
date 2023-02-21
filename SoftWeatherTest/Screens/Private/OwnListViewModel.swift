//
//  OwnListViewModel.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import Foundation
import UIKit

final class OwnListViewModel {
    
    let cellModel = Observable<[PublicOwnCellModel]>([])
    
    weak var viewController: UIViewController?
    
    let photoService = PhotoService()
    
    var gists = [Gist]()
    
    private var page = 1
    
    private let networkService = NetworkService()
    
    //MARK: - Methods
    
    func getGistsByUser() {
        networkService.getGistsByUser(user: "AutoTransform") { [weak self] result in
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
    
    func didSelectGist(_ gistViewModel: PublicOwnCellModel) {
        guard let gist = self.gist(with: gistViewModel) else { return }
        let detailGistViewController = DetailsGistViewController()
        let detailViewModel = DetailViewModel(gist: gist, viewController: detailGistViewController)
        detailGistViewController.viewModel = detailViewModel
        
        self.viewController?.navigationController?.pushViewController(detailGistViewController, animated: true)
    }
    
    private func viewModels() -> [PublicOwnCellModel] {
            return self.gists.compactMap { gist -> PublicOwnCellModel in
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


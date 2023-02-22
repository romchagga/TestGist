//
//  PhotoService.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit

class PhotoService {
    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    lazy var session = URLSession(configuration: configuration)
    
    let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        return config
    }()
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectroy = FileManager.default.urls(
                                                for: .cachesDirectory,
                                                in: .userDomainMask).first else { return pathName}
        let url = cachesDirectroy.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    func photo(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        return image
    }
    
    func photo(byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(byUrl: url)
        }
        return image
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }
    
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
    
        guard let urlSession = URL(string: "\(url)") else { return }
        let task = self.session.dataTask(with: urlSession, completionHandler: { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                }
            guard
                error == nil,
                let data = data
            else { return }
            
            do {
               guard let image = UIImage(data: data) else { return }
                self.saveImageToCache(url: url, image: image)
                    DispatchQueue.main.async {
                        self.images[url] = image
                            }
                        }
                    })
            task.resume()
            }
    
    private func loadPhoto(byUrl url: String) {
    
        guard let urlSession = URL(string: "\(url)") else { return }
        let task = self.session.dataTask(with: urlSession, completionHandler: { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                }
            guard
                error == nil,
                let data = data
            else { return }
            
            do {
               guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.images[url] = image
                    }
                self.saveImageToCache(url: url, image: image)
                }
                    })
            task.resume()
            }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

extension PhotoService {
    
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}

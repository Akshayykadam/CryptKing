//
//  CoinImageService.swift
//  CryptKing
//
//  Created by Akshay Kadam on 03/04/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Getting image from filemanager")
        } else{
            downloadCoinImage()
            print("Image is downloaded from URL")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image!) else {
            return
        }
        
        imageSubscription = NetworkingManager.downloadImage(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handelComplition, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self, let downloadedImage = returnedImage
                else {
                    return
                }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, Imagename: self.imageName, folderName: self.folderName)
            })
    }
}

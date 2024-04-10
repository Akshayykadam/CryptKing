//
//  LocalFileManager.swift
//  CryptKing
//
//  Created by Akshay Kadam on 04/04/24.
//

import Foundation
import SwiftUI

class LocalFileManager{
    
    static let instance = LocalFileManager()
    private init(){}
    
    func saveImage(image: UIImage, Imagename: String, folderName:String){
        
        createFolderIfNotExists(folderName: folderName)
        
        guard let data = image.pngData(),
        let url = getURLForImage(Imagename: Imagename, folderName: folderName)
        else {return}
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard 
            let url = getURLForImage(Imagename: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNotExists(folderName: String){
        guard
            let url = getURLForFolder(folderName: folderName)
        else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating folder \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else{
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(Imagename: String, folderName: String) -> URL? {
        guard
            let folderURL = getURLForFolder(folderName: folderName)
        else{
            return nil
        }
        
        return folderURL.appendingPathComponent(Imagename + ".png")
    }
}

//
//  ProfileDetailVC.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 21/01/2024.
//

import UIKit
import Vision

class ProfileDetailVC: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pickImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickImageBtnPressed(_ sender: Any) {
        
        showImagePickerOptions()
        
    }
}
extension ProfileDetailVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        print(newImage.size)
        self.profileImage.image = newImage
        
        guard let cgImage = profileImage.image?.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Vision provides its text-recognition capabilities through VNRecognizeTextRequest, an image-based request type that finds and extracts text in images.
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }
            
            let text = observations.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: ", ")
            
            print(text) // text we get from image
        }
        
        // just add the Language code
        request.recognitionLanguages = ["English"]
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing text recognition: \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }

}

extension ProfileDetailVC {
    
    func showImagePickerOptions(){
            
            let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
                
                guard let self = self else {
                    return
                }
                let cameraImagePicker = self.imagePicker (sourceType: .camera)
                cameraImagePicker.delegate = self
                self.present (cameraImagePicker, animated: true) {
                }
            }
            let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
                guard let self = self else {
                    return
                }
                let libraryImagePicker = self.imagePicker (sourceType: .photoLibrary)
                libraryImagePicker.delegate = self
                self.present (libraryImagePicker, animated: true) {
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(cameraAction)
            alertVC.addAction(libraryAction)
            alertVC.addAction(cancelAction)
            self.present (alertVC, animated: true, completion: nil)
            
        }
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
}

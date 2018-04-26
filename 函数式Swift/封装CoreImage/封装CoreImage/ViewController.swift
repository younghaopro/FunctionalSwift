//
//  ViewController.swift
//  封装CoreImage
//
//  Created by yanghao on 2018/4/26.
//  Copyright © 2018年 yanghao. All rights reserved.
//

import UIKit
import CoreImage


typealias Filter = (CIImage) -> CIImage

infix operator >>>

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image))}
}

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://via.placeholder.com/500x500")!
        let image = CIImage(contentsOf: url)!
        let radius = 5.0
        let color = UIColor.red.withAlphaComponent(0.2)
        let blurredImage = blur(radius: radius)(image)
        let overlaidImage = overlay(color: color)(blurredImage)
        let blurAndOverlay2 = blur(radius: radius) >>> overlay(color: color)
        let result = blurAndOverlay2(image)
        imageView.image = UIImage(ciImage: result)
        
        let x = add3(2)(3)
    
        print(x)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func blur(radius: Double) -> Filter {
        return { image in
            let parameters: [String : Any] = [
                kCIInputRadiusKey: radius,
                kCIInputImageKey: image
            ]
            guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else { fatalError()}
            return outputImage
        }
    }
    
    func generate(color: UIColor) -> Filter {
        return { _ in
            let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
            guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
                else { fatalError() }
            guard let outputImage = filter.outputImage
                else { fatalError() }
            return outputImage
        }
    }
    
    func compositeSourceOver(overlay: CIImage) -> Filter {
        return { image in
            let parameters = [
                kCIInputBackgroundImageKey: image,
                kCIInputImageKey: overlay
            ]
            guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters)
                else { fatalError() }
            guard let outputImage = filter.outputImage
                else { fatalError() }
            return outputImage.cropped(to: image.extent)
        }
    }
    
    func overlay(color: UIColor) -> Filter {
        return { image in
            let overlay = self.generate(color: color)(image).cropped(to: image.extent)
            return self.compositeSourceOver(overlay: overlay)(image)
        }
    }
    
    func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
        return { image in
            filter2(filter1(image))
        }
    }
    
}

//科里化
extension ViewController {
    
    func add(_ x: Int, y: Int) -> Int {
        return x + y
    }
    
    func add1(_ x: Int) -> ((Int) -> Int) {
        return { y in
            return x + y
        }
    }
    
    func add3(_ x: Int) -> (Int) -> Int{ //箭头向右结合 (right-associative)
        return { y in
            return x + y
        }
    }
}


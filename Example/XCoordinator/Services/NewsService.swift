//
//  NewsService.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import RxSwift

struct News {
    var title: String
    var subtitle: String
    var image: UIImage
    var content: String
}

protocol NewsService {
    func mostRecentNews() -> (title: String, articles: [News])
}

class MockNewsService: NewsService {
    let mockNews: [News] = [
        News(title: "Example article 0", subtitle: "Stefan", image: UIImage.from(color: .black, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 1", subtitle: "Malte", image: UIImage.from(color: .blue, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 2", subtitle: "Julian", image: UIImage.from(color: .green, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 3", subtitle: "Niko", image: UIImage.from(color: .yellow, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 4", subtitle: "Paul", image: UIImage.from(color: .orange, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 5", subtitle: "Patrick", image: UIImage.from(color: .red, size: CGSize(width: 44, height: 44)), content: loremIpsum),
        News(title: "Example article 6", subtitle: "Sebastian", image: UIImage.from(color: .white, size: CGSize(width: 44, height: 44)), content: loremIpsum)
    ]

    func mostRecentNews() -> (title: String, articles: [News]) {
        return (title: "QuickBird Studios Blog", articles: mockNews)
    }
}

extension UIImage {
    static func from(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

let loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus iaculis, augue ac consectetur volutpat, dui est malesuada tellus, et elementum odio urna quis odio. Mauris mollis at libero in elementum. Mauris enim dui, tincidunt id blandit vitae, condimentum a tellus. Donec ut diam in nisl interdum ultrices. Vivamus id magna nisi. Duis molestie libero velit, vel consequat mi viverra pellentesque. Nulla at tellus eget risus fringilla ornare id a quam. Pellentesque arcu neque, interdum nec enim eu, tincidunt volutpat mauris. Vivamus ultricies tortor at lacus vehicula, vitae laoreet tellus tincidunt. Etiam sollicitudin nisl scelerisque odio malesuada consectetur. Nunc non tempor felis. Sed dolor ipsum, scelerisque vitae dolor in, porttitor facilisis lorem. Nam id dolor sagittis, fermentum nulla eu, ornare neque.

Integer a dignissim nulla. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies velit ipsum, vel varius lorem luctus nec. Fusce egestas pretium magna, in convallis turpis varius in. Phasellus fringilla magna tincidunt, tempor nulla in, ullamcorper enim. Proin pellentesque mi congue ante tempor, eget consectetur nunc eleifend. Cras posuere dui dui, sit amet sodales sapien aliquam eu. Morbi non neque quam. Vivamus et maximus nisl. Donec quis lectus nunc. Sed eget nulla quis enim gravida dapibus. Sed eu nisl et erat dictum rutrum at vitae neque. Quisque vel nunc viverra, malesuada nulla ut, mollis dui. Aliquam feugiat quam at magna dapibus ultrices. Vestibulum viverra orci et tellus vehicula, vel congue neque ornare.

Suspendisse potenti. Ut sed felis consequat, pharetra tellus sed, placerat dui. In aliquet nunc eu semper suscipit. In eros odio, ornare et blandit non, volutpat lobortis ex. Ut condimentum enim sit amet blandit tincidunt. Phasellus et elit dui. Vivamus condimentum id lorem a tincidunt. Donec semper turpis vel condimentum ullamcorper. Vivamus vulputate, tellus id facilisis iaculis, dui diam congue diam, sit amet fringilla orci diam in ex. Donec elit enim, consequat id sodales sed, blandit id justo. In hac habitasse platea dictumst. Donec justo lectus, sagittis quis iaculis vel, tempor non elit. Cras tellus ipsum, vulputate quis nisl ut, lobortis venenatis orci.

Ut vitae ex eget quam accumsan laoreet sit amet a ligula. Quisque eu nisi nec leo aliquam faucibus id commodo tortor. Aliquam lobortis felis in ipsum placerat, aliquet condimentum tortor malesuada. In vitae enim ut orci imperdiet tempor. Vivamus nec nisi ut quam tempus volutpat a vitae eros. Etiam interdum facilisis rhoncus. Vestibulum tempus pulvinar velit, nec luctus dolor faucibus vel. Sed ullamcorper maximus odio, non mattis orci eleifend efficitur.

Sed bibendum, mi sed euismod gravida, nulla elit aliquam augue, eget fermentum ligula urna eu lorem. Ut sit amet sem diam. Sed ac blandit tellus, ut rhoncus orci. Nulla non dui at nisl interdum venenatis non eget tellus. Pellentesque congue felis ut posuere mollis. Cras sit amet rutrum neque. Morbi id porttitor metus.
"""

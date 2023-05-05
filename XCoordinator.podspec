Pod::Spec.new do |spec|
    spec.name         = 'XCoordinator'
    spec.version      = '3.0.0'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/quickbirdstudios/XCoordinator'
    spec.authors      = { 'Stefan Kofler' => 'stefan.kofler@quickbirdstudios.com', 'Paul Kraft' => 'pauljohannes.kraft@quickbirdstudios.com' }
    spec.summary      = 'Navigation framework based on coordinator pattern.'
    spec.source       = { :git => 'https://github.com/quickbirdstudios/XCoordinator.git', :tag => spec.version }
    spec.module_name = 'XCoordinator'
    spec.swift_version = '5.6'
    spec.ios.deployment_target = '11.0'
    spec.tvos.deployment_target = '11.0'
    spec.source_files = 'Sources/XCoordinator/*.swift'
    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |ss|
        ss.source_files = 'Sources/XCoordinator/*.swift'
        ss.framework  = 'UIKit'
    end

    spec.subspec 'RxSwift' do |ss|
        ss.dependency 'XCoordinator/Core'
        ss.dependency 'RxSwift', '~> 6.5'
        ss.source_files = 'Sources/XCoordinatorRx/*.swift'
    end

    spec.subspec 'Combine' do |ss|
        ss.dependency 'XCoordinator/Core'
        ss.source_files = 'Sources/XCoordinatorCombine/*.swift'
    end
end

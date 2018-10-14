Pod::Spec.new do |spec|
  spec.name         = 'rx-coordinator'
  spec.version      = '0.6.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/quickbirdstudios/RxCoordinator'
  spec.authors      = { 'Stefan Kofler' => 'stefan.kofler@quickbirdstudios.com' }
  spec.summary      = 'Navigation framework based on coordinator pattern.'
  spec.source       = { :git => 'https://github.com/quickbirdstudios/RxCoordinator.git', :tag => spec.version }
  spec.module_name = 'RxCoordinator'
  spec.swift_version = '4.2'
  spec.ios.deployment_target = '9.0'
  spec.tvos.deployment_target = '9.0'
  spec.source_files = 'RxCoordinator/Sources/*.swift'
  spec.framework  = 'Foundation'
  spec.framework  = 'UIKit'
  spec.dependency 'RxSwift', '~> 4.3'
  spec.dependency 'RxCocoa', '~> 4.3'
end

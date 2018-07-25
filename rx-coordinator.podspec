Pod::Spec.new do |spec|
  spec.name         = 'rx-coordinator'
  spec.version      = '0.7.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/quickbirdstudios/RxCoordinator'
  spec.authors      = { 'Stefan Kofler' => 'stefan.kofler@quickbirdstudios.com' }
  spec.summary      = 'Navigation framework based on coordinator pattern.'
  spec.source       = { :git => 'https://github.com/quickbirdstudios/RxCoordinator.git', :tag => spec.version }
  spec.module_name = 'RxCoordinator'
  spec.swift_version = '4.1'
  spec.ios.deployment_target = '9.0'
  spec.tvos.deployment_target = '9.0'
  spec.source_files = 'RxCoordinator/Sources/*.swift'
  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |ss|
      ss.source_files = 'RxCoordinator/Sources/*.swift'
      ss.framework  = 'Foundation'
      ss.framework  = 'UIKit'
  end

  spec.subspec 'RxSwift' do |ss|
    ss.dependency 'rx-coordinator/Core'
    ss.dependency 'RxSwift', '~> 4.0'
    ss.source_files = 'RxCoordinator/Sources/RxSwift/*.swift'
  end
end

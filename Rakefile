require 'bundler'
require 'socket'

Bundler.setup
Bundler.require

 CONFIGS               = {
                        :Debug    => 'Provisioning/Resilience.mobileprovision',
                        :Release  => '????.mobileprovision'
                      }
TESTFLIGHT_API_TOKEN  = ''
TESTFLIGHT_TEAM_TOKEN = ''
MAIN_TARGET                = Xcode.workspace(:Resilience).project(:Resilience).target(:Resilience)
KIWI_TARGET                = Xcode.workspace(:Resilience).project(:Resilience).target(:KiwiUnitTest)
PODS_TARGET                = Xcode.workspace(:Resilience).project(:Pods).target(:Pods)
PODS_KIWI_TARGET           = Xcode.workspace(:Resilience).project(:Pods).target('Pods-KiwiUnitTest')

#
# BEGIN RAKEFILE
#

task :ci => ['adhoc:testflight', 'release:package']

desc "Setup Resilience application"
task :setup do
  sh "cd Resilience; rm -rf Pods; pod setup; pod install"
end

CONFIGS.keys.each do |config_name|
  puts config_name
  namespace config_name.downcase do

    config = MAIN_TARGET.config(config_name)
    kiwi_builder = KIWI_TARGET.config(config_name).builder
    main_builder = config.builder
    pods_builder = PODS_TARGET.config(config_name).builder
    pods_kiwi_builder = PODS_KIWI_TARGET.config(config_name).builder
    main_builder.profile   = CONFIGS[config_name]
    main_builder.identity  = 'iPhone Developer'

    desc "Clean the #{config_name} config"
    task :clean do
      pods_builder.clean
      pods_kiwi_builder.clean
      main_builder.clean
    end

    desc "Build the #{config_name} config"
    task :build => [:clean] do
      config.info_plist do |info|
        info.version = ENV['BUILD_NUMBER']||"#{Socket.gethostname}-SNAPSHOT"
        info.save
      end
      sh "cd Resilience; pod install"
      pods_builder.build
      main_builder.build
    end

    desc "Test the #{config_name} config"
    task :test do
      pods_kiwi_builder.test # this is only here to generate a simulator version of the library file
      pods_builder.test # this is only here to generate a simulator version of the library file
      kiwi_builder.test
    end

    desc "Package (.ipa & .dSYM.zip) the #{config_name} config"
    task :package => [:build] do
      main_builder.package
    end

    unless config_name==:Release
      desc "Upload the #{config_name} config to testflight"
      task :testflight  => [:package] do
        response = main_builder.testflight TESTFLIGHT_API_TOKEN, TESTFLIGHT_TEAM_TOKEN do |tf|
          tf.notify = true
          tf.lists  << "Internal"
          tf.notes  = `git log -n 1`
        end
      end
    end

  end
end

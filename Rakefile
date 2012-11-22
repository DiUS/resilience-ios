require 'bundler'
require 'socket'

Bundler.setup
Bundler.require

 CONFIGS               = {
                        :Debug    => 'Provisioning/Hood_AdHoc.mobileprovision',
                        :Release  => 'Provisioning/Hood_AppStore.mobileprovision'
                      }
TESTFLIGHT_API_TOKEN  = ''
TESTFLIGHT_TEAM_TOKEN = ''
MAIN_TARGET                = Xcode.workspace(:Resilience).project(:Resilience).target(:Resilience)
PODS_TARGET                = Xcode.workspace(:Resilience).project(:Pods).target(:Pods)
# KEYCHAIN_PATH         = 'Provisioning/Hood.keychain'
# KEYCHAIN_PASSWORD     = 'hoodapp'

#
# BEGIN RAKEFILE
#

task :ci => ['adhoc:testflight', 'release:package']

CONFIGS.keys.each do |config_name|
  puts config_name
  namespace config_name.downcase do
    config = MAIN_TARGET.config(config_name)

    # keychain = Xcode::Keychain.new KEYCHAIN_PATH
    # keychain.unlock KEYCHAIN_PASSWORD

    pods_builder = PODS_TARGET.config(config_name).builder
    main_builder = config.builder
    # main_builder.profile   = CONFIGS[config_name]
    # main_builder.identity  = 'iPhone Distribution: A Cretu-Barbul'
    # main_builder.keychain  = keychain

    desc "Clean the #{config_name} config"
    task :clean do
      pods_builder.clean
      main_builder.clean
    end

    desc "Build the #{config_name} config"
    task :build => [:clean] do
      config.info_plist do |info|
        info.version = ENV['BUILD_NUMBER']||"#{Socket.gethostname}-SNAPSHOT"
        info.save
      end
      pods_builder.build
      main_builder.build
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

require 'bundler'
require 'socket'

Bundler.setup
Bundler.require

 CONFIGS               = {
                        :Debug    => 'Provisioning/Resilience.mobileprovision',
                        :Release  => '????.mobileprovision'
                      }
TESTFLIGHT_API_TOKEN  = ENV['API_TOKEN']
TESTFLIGHT_TEAM_TOKEN = ENV['TEAM_TOKEN']

def main_target
  Xcode.workspace(:Resilience).project(:Resilience).target(:Resilience)
end
def kiwi_target
  Xcode.workspace(:Resilience).project(:Resilience).target(:KiwiUnitTest)
end
def pods_target
  Xcode.workspace(:Resilience).project(:Pods).target(:Pods)
end
def pods_kiwi_target
  Xcode.workspace(:Resilience).project(:Pods).target('Pods-KiwiUnitTest')
end

#
# BEGIN RAKEFILE
#

task :ci => ['adhoc:testflight', 'release:package']

desc "Setup project dependencies"
task :setup do
  sh 'cd Resilience; pod setup; pod install'
end

desc "Update project dependencies"
task :update_dependencies do
  sh 'cd Resilience; pod install'
end

CONFIGS.keys.each do |config_name|
  puts config_name
  namespace config_name.downcase do

    task :__load_workspace do
      @config = main_target.config(config_name)
      @kiwi_builder = kiwi_target.config(config_name).builder
      @main_builder = @config.builder
      @pods_builder = pods_target.config(config_name).builder
      @pods_kiwi_builder = pods_kiwi_target.config(config_name).builder
      @main_builder.profile   = CONFIGS[config_name]
      @main_builder.identity  = 'iPhone Developer'
      cert_password = ENV['CERT_PASSWORD']
      unless cert_password.empty?
        keychain = Xcode::Keychain.temp
        keychain.import 'Provisioning/dist.cer', ""
        keychain.import 'Provisioning/apple.cer', ""
        keychain.import 'Provisioning/dist.p12', cert_password
        @main_builder.keychain = keychain
        @main_builder.identity = keychain.identities.first
      end
    end

    desc "Clean the #{config_name} config"
    task :clean => :__load_workspace do
      @pods_builder.clean
      @pods_kiwi_builder.clean
      @main_builder.clean
    end

    desc "Build the #{config_name} config"
    task :build => [:clean, :update_dependencies, :__load_workspace] do
      @config.info_plist do |info|
        info.version = ENV['TRAVIS_BUILD_NUMBER']||"#{Socket.gethostname}-SNAPSHOT"
        info.save
      end
      @pods_builder.build
      @main_builder.build
    end

    desc "Test the #{config_name} config"
    task :test => [:update_dependencies, :__load_workspace] do
      @pods_kiwi_builder.test # this is only here to generate a simulator version of the library file
      @pods_builder.test # this is only here to generate a simulator version of the library file
      @kiwi_builder.test
    end

    desc "Package (.ipa & .dSYM.zip) the #{config_name} config"
    task :package => [:build, :__load_workspace] do
      @main_builder.package
    end

    unless config_name==:Release
      desc "Upload the #{config_name} config to testflight"
      task :testflight  => [:package, :__load_workspace] do
        response = @main_builder.testflight TESTFLIGHT_API_TOKEN, TESTFLIGHT_TEAM_TOKEN do |tf|
          tf.notify = true
          tf.lists  << "Internal"
          tf.notes  = `git log -n 1`
        end
      end
    end
  end
end

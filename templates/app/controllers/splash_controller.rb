class SplashController < ApplicationController

  def index
    
    @tracker_gems = Hash[%w( honeybadger bugsnag errorapp_notifier exceptiontrap rollbar
                            runtimeerror_notifier sentry-raven airbrake ).map{|x| [x,gem_available?(x)]}]

    puts @tracker_gems.to_yaml
  end

  def signup
  end


  private
  
    def gem_available?(name)
       Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
       false
    rescue
       Gem.available?(name)
    end

end

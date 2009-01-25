require 'ezcrypto'

class MasterCryptoProvider

  CONFIG = YAML.load_file(RAILS_ROOT + '/config/crypto.yml')[ENV['RAILS_ENV']].symbolize_keys
  
  class << self
    def encrypt(field)
      key.encrypt field
    end
    
    def decrypt(field)
      key.decrypt field
    end
    
    def key
      EzCrypto::Key.with_password CONFIG[:master_key], CONFIG[:salt]
    end
  end
end
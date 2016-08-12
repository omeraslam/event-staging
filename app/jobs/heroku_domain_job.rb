require 'platform-api'

class HerokuDomainJob < ActiveJob::Base
  queue_as :default

  def perform(domain, action)
    # Do something later
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])

    begin
        case action
        when "add"
            heroku.domain.create("eventcreate-v1", "hostname" => domain)
        when "remove"
            heroku.domain.delete("eventcreate-v1", domain)
        end

    rescue Heroku::API::Errors::RequestFailed => e
        Rails.logger.error "[Heroku Domain Worker] ERROR: #{e}"
    end

  end
end

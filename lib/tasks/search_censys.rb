require 'censys'

module Intrigue
class SearchCensysTask < BaseTask

  def metadata
    {
      :name => "search_censys",
      :pretty_name => "Search Censys.io",
      :authors => ["jcran"],
      :description => "This task hits the Censys API and finds matches",
      :references => [],
      :allowed_types => ["DnsRecord", "IpAddress", "String"],
      :example_entities => [{"type" => "String", "attributes" => {"name" => "intrigue.io"}}],
      :allowed_options => [],
      :created_types => ["IpAddress", "SslCertificate"]
    }
  end

  ## Default method, subclasses must override this
  def run
    super

    begin

      # Make sure the key is set
      uid = _get_global_config "censys_uid"
      secret = _get_global_config "censys_secret"
      entity_name = _get_entity_attribute "name"

      unless uid && secret
        @task_result.logger.log_error "No credentials?"
        return
      end

      # Attach to the censys service & search
      censys = Censys::Api.new(uid,secret)

      ## Grab IPv4 Results
      ["ipv4"].each do |search_type|
        response = censys.search(entity_name,search_type)
        response["results"].each do |r|
          @task_result.logger.log "Got result: #{r}"
          _create_entity "IpAddress", "name" => "#{r["ip"]}", "additional" => r
        end
      end

      # TODO -Should we expect any details when searching type "websites"

      ["certificates"].each do |search_type|
        response = censys.search(entity_name,search_type)
        response["results"].each do |r|
          @task_result.logger.log "Got result: #{r}"
          _create_entity "SslCertificate", "name" => r["parsed.subject_dn"], "additional" => r
        end
      end


    rescue RuntimeError => e
      @task_result.logger.log_error "Runtime error: #{e}"
    end

  end # end run()

end # end Class
end

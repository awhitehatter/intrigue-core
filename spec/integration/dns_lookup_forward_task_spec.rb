require_relative '../spec_helper'

describe "Intrigue v1.0 Tasks" do
  describe "DnsLookupForwardTask" do

    ###
    ### dns_lookup_forward
    ###

    it "runs a default dns_lookup_forward task and returns the correct result" do

      entity = {
        "type" => "DnsRecord",
        "attributes" => {
          "name" => "intrigue.io"
        }
      }

      # Returns a ruby hash of the task_run
      @api = IntrigueApi.new
      result = @api.start("dns_lookup_forward", entity)

      # Check the result
      expect(result["task_name"]).to match "dns_lookup_forward"
      expect(result["entity_id"]["type"]).to match "DnsRecord"
      expect(result["entity_ids"].first["type"]).to match "IpAddress"
      expect(result["entity_ids"].first["attributes"]["name"]).to match /192.0.78.*/
    end

  end
end

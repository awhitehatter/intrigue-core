module Intrigue
  module Model
    class Logger
      include DataMapper::Resource

      property :id, Serial
      property :full_log, Text, :length => 5000000, :default =>""

      def log(message)
        _log "[ ] #{@name}: " << message
      end

      def log_debug(message)
        _log "[D] #{@name}: " << message
      end

      def log_good(message)
        _log "[+] #{@name}: " << message
      end

      def log_error(message)
        _log "[-] #{@name}: " << message
      end

    private

      def _log(message)

        # Write to DB
        attribute_set(:full_log, "#{@full_log}\n#{message}")
        #@full_log = "" unless @full_log
        #@full_log << "#{@full_log}\n#{message}"

        # Write to STDOUT
        #puts message

        #Write to file
        #if @write_file
        #  @streamfile.puts message
        #  @streamfile.flush
        #end

      end
    end

end
end
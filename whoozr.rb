require 'trollop'
require 'whois'
load 'domain_list.rb'

opts = Trollop::options do
  opt :tlds,
    "Top Level Domains, comma separated (default: me,ag,org,us)",
    :type => :string,
    :default => "me,ag,org,us"
  opt :concat,
    "Add the listed TLDs to the end of the word before checking.
    If false or not specified, look for TLDs included at the end of the word"
  opt :file,
    "Input file for word list (use stdin if not specified)",
    :type => :string,
    :required => true
  banner "look for words with TLDs at the end, see if the domain is available"
end

Trollop::die :file, "must exist" unless File.exist?(opts[:file])

potentials = DomainList.new(
  :words => File.read(opts[:file]).split,
  :tlds => opts[:tlds],
  :concat => opts[:concat]
)

c = Whois::Client.new(timeout: 20)

potentials.domains.each do |dom|
  attempts = 0
  done = false
  while !done and attempts < 3 do
    begin
      attempts += 1
      puts dom + " is available" if c.lookup(dom).available?
      done = true
    rescue Whois::ConnectionError
      #puts "ConnectionError, retrying"
      retry
    rescue Whois::ResponseIsThrottled
      #puts "ResponseIsThrottle, retrying"
      retry
    rescue Timeout::Error
      #puts "ResponseIsThrottle, retrying"
      retry
    end
  end
end


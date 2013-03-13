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
    :type => :string
  banner "look for words with TLDs at the end, see if the domain is available"
end

Trollop::die :file, "must exist" unless File.exist?(opts[:file])

potentials = DomainList.new(
  :words => File.read(opts[:file]).split,
  :tlds => opts[:tlds],
  :concat => opts[:concat]
)

c = Whois::Client.new

potentials.domains.each do |dom|
  puts dom + " is available" if c.query(dom).available?
end


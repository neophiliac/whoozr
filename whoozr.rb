require 'trollop'
require 'whois'

opts = Trollop::options do
  opt :tlds,
    "Top Level Domains, comma separated (default: me,ag,org,us)",
    :type => :string,
    :default => "me,ag,org,us"
  opt :file,
    "Input file for word list (use stdin if not specified)",
    :type => :string
  banner "look for words with TLDs at the end, see if the domain is available"
end

Trollop::die :file, "must exist" unless File.exist?(opts[:file])

tld_regex = "(" + opts[:tlds].split(',').join('$|') + "$)"

c = Whois::Client.new

words = File.read(opts[:file]).split

words.each do |dom|
  check = String.new(dom)
  if !(i = check.index(/#{tld_regex}/)).nil? then
    check = check.insert(i, '.')
    puts check + " is available" if c.query(check).available?
  end
end

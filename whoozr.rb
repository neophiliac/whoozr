require 'trollop'
require 'whois'

class DomainList
  attr_reader :words, :tlds, :concat, :domains
  def initialize(args)
    @words  = args[:words]
    @tlds   = args[:tlds]
    @domains = []
    args[:concat] ? add_tlds : find_tlds
    p @domains
  end

  def add_tlds
    tld_list = @tlds.split(',')
    @words.each do |word|
      base = String.new(word)
      tld_list.each do |tld|
        @domains << base + '.' + tld
        if base[-1,1] == 's' # check non-plural word also?
          @domains << base[0,base.size-1] + '.' + tld
        end
      end
    end
  end

  def find_tlds
    tld_regex = "(" + @tlds.split(',').join('$|') + "$)"
    @words.each do |word|
      check = String.new(word)
      if !(i = check.index(/#{tld_regex}/)).nil? then
        @domains << check.insert(i, '.')
      end
    end
  end

end

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


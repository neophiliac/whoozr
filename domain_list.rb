class DomainList
#  include Enumerable

  attr_reader :words, :tlds, :concat, :domains
  def initialize(args)
    @words  = args[:words]
    @tlds   = args[:tlds] || "me,ag,org,us"
    @concat = args[:concat] || false
    @domains = []
    @concat ? add_tlds : find_tlds
  end

  def each(&block)
    @domains.each do |member|
      block.nil? ? member : block.call(member)
    end
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



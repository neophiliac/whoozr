require 'rubygems'
require 'whois'

c = Whois::Client.new

ARGV.each do |dom|
  check = String.new(dom)
  if !(i = check.index(/me$/)).nil? then 
    check = check.insert(i, '.') 
  end
  if !(i = check.index(/ag$/)).nil? then 
    check = check.insert(i, '.') 
  end
  if !(i = check.index(/org$/)).nil? then 
    check = check.insert(i, '.') 
  end
  if !(i = check.index(/us$/)).nil? then 
    check = check.insert(i, '.') 
  end
  if check.index('.') && c.query(check).available? then
    puts check + " is available"
  end
end

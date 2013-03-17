require 'rubygems'
require 'rspec'
load 'domain_list.rb'

describe DomainList do
  context "with default params" do
    context "and one non-matching word of input" do
      subject(:domainlist) { DomainList.new(words: ['word']) }

      it "returns nothing from #each" do
        expect(domainlist.empty?).to be_true
      end
    end

    context "and one matching word of input" do
      subject(:domainlist) { DomainList.new(words: ['nonexistent939485me']) }

      it "returns one domain from #each" do
        domainlist.each do |d|
          expect(d).to eq("nonexistent939485.me")
        end
      end
    end

    context "and multiple words of input" do
      subject(:domainlist) { DomainList.new(
        words: ['nonexistent939485me','gaseousbag','argle']) }

      it "returns one domain from #each" do
        expect(domainlist.each {|x| x}).to eq(["nonexistent939485.me", "gaseousb.ag"])
      end
    end
  end

  context "with concat: true" do
    context "for a single word" do
      subject(:domainlist) { DomainList.new(words: ['argle'], concat: true) }

      it "returns multiple domains from #each" do
        expect(domainlist.each {|x| x}).to eq(["argle.me", "argle.ag", "argle.org", "argle.us"])
      end
    end

    context "for multiple words" do
      subject(:domainlist) { DomainList.new(words: ['argle',"bargle"],
                                            concat: true,
                                            tlds: "ag,com") }

      it "returns multiple domains from #each" do
        expect(domainlist.each {|x| x}).to eq(["argle.ag", "argle.com", "bargle.ag", "bargle.com"])
      end
    end
  end
end

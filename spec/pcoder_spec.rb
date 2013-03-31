# coding: utf-8
$LOAD_PATH << File.expand_path("../../", __FILE__)
require 'rspec'
require 'lib/pcoder'
require 'spec/tmp/account.rb'

module Pcoder
  describe Atcoder do
    let(:atcoder) { Atcoder.new() }

    describe "#submit" do
      it "コードが提出されること" do
        pending
      end
    end

    describe "#language" do
      context "with \"c\"" do
        it { atcoder.send(:language, "c").should eq "C" }
      end

      context "with \"cc\"" do
        it { atcoder.send(:language, "cc").should eq "C++" }
      end

      context "with \"cpp\"" do
        it { atcoder.send(:language, "cpp").should eq "C++" }
      end

      context "with \"d\"" do
        it { atcoder.send(:language, "d").should eq "D" }
      end

      context "with \"java\"" do
        it { atcoder.send(:language, "java").should eq "Java" }
      end

      context "with \"php\"" do
        it { atcoder.send(:language, "php").should eq "PHP" }
      end

      context "with \"py\"" do
        it { atcoder.send(:language, "py").should eq "Python" }
      end

      context "with \"pl\"" do
        it { atcoder.send(:language, "pl").should eq "Perl" }
      end

      context "with \"rb\"" do
        it { atcoder.send(:language, "rb").should eq "Ruby" }
      end

      context "with \"hs\"" do
        it { atcoder.send(:language, "hs").should eq "Haskell" }
      end

      context "with \"p\"" do
        it { atcoder.send(:language, "p").should eq "Pascal" }
      end

      context "with \"pp\"" do
        it { atcoder.send(:language, "pp").should eq "Pascal" }
      end

      context "with \"pas\"" do
        it { atcoder.send(:language, "pas").should eq "Pascal" }
      end

      context "with \"js\"" do
        it { atcoder.send(:language, "js").should eq "JavaScript" }
      end

      context "with \"\"" do
        it { atcoder.send(:language, "").should be_nil }
      end
    end
  end
end

# coding: utf-8
$LOAD_PATH << File.expand_path("../../", __FILE__)
require 'rspec'
require 'lib/pcoder'

module Pcoder
  describe Atcoder do
    let(:atcoder) { Atcoder.new() }

    describe "#submit" do
      it "コードが提出されること" do
        pending
      end
    end
  end
end

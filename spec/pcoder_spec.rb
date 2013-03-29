# coding: utf-8
$LOAD_PATH << File.expand_path("../../", __FILE__)
require 'rspec'
require 'lib/pcoder'

module Pcoder
  describe Atcoder do
    let(:atcoder) { Atcoder.new() }

    describe "#login" do
      it "ログインに失敗したらfalseを返すこと" do
        pending
      end

      it "ログインに成功したらtrueを返すこと" do
        pending
      end
    end

    describe "#post_code" do
      it "コードが提出されること" do
        pending
      end
    end
  end
end

$LOAD_PATH << File.expand_path("../../lib", __FILE__)
require 'rspec'
require 'pcoder'

module Pcoder
  describe Atcoder do
    let(:atcoder) { Atcoder.new() }

    describe "#account" do
      it "ユーザ名とパスワードが保存されること" do
        atcoder.account("", "")
      end
    end

    describe "#get_user" do
      it "ユーザ名を出力すること" do
        atcoder.get_user("")
      end
    end

    describe "#login" do
      it "ユーザ名かパスワードがない場合はエラーを投げること" do
      end

      it "ログインに失敗したらfalseを返すこと" do
      end

      it "ログインに成功したらtrueを返すこと" do
      end
    end

    describe "#post_code" do
      it "コードが提出されること" do
      end
    end
  end
end

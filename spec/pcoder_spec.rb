# coding: utf-8
$LOAD_PATH << File.expand_path("../../", __FILE__)
require 'rspec'
require 'lib/pcoder'

module Pcoder
  describe Atcoder do
    let(:atcoder) { Atcoder.new() }

    describe "#account" do
      it "ユーザ名とパスワードが保存されること" do
        user, password = nil
        atcoder.account("user", "password", "spec_account.conf")
        File::open("conf/spec_account.conf") { |line|
          user = line[0]
          password = line[1]
        }
        user.should eq "user"
        password.should eq "password"
      end
    end

    describe "#get_user" do
      it "ユーザ名を出力すること" do
        pending
      end
    end

    describe "#login" do
      it "ユーザ名かパスワードがない場合はエラーを投げること" do
        pending
      end

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

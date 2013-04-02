# coding: utf-8
require 'spec_helper'
module Pcoder
  SPEC_HOST = "arc012.contest.atcoder.jp"

  describe "VERSION" do
    it 'should have a version number' do
      VERSION.should_not be_nil
    end
  end

  describe Atcoder do
    let(:atcoder) { Atcoder.new }

    describe "#process" do
      context "with user, pass, path, mock_model" do
        it "call Atcoder#submit with code" do
          path = File.expand_path("../tmp/practice_1.rb", __FILE__)
          receiver = double("atcoder")
          receiver.should_receive(:submit).with(kind_of(Mechanize), "207", "9", "# Method check.\n")
          atcoder.process(ATCODER_USER, ATCODER_PASS, path, receiver)
        end
      end
    end

    describe "#login" do
      context "with not_user, not_pass" do
        it { proc { atcoder.send(:login, 'foo', 'bar', SPEC_HOST)}.should raise_error(LoginError) }
      end

      context "with user, pass" do
        it { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST).class.should eq Mechanize }
      end
    end

    describe "#to_task_postion" do
      context "with \"A\"" do
        it { atcoder.send(:to_task_postion, "A").should eq 1 }
      end

      context "with \"B\"" do
        it { atcoder.send(:to_task_postion, "B").should eq 2 }
      end

      context "with \"a\"" do
        it { atcoder.send(:to_task_postion, "a").should eq 1 }
      end

      context "with \"1\"" do
        it { atcoder.send(:to_task_postion, "1").should be_nil }
      end
    end

    describe "#get_task_id" do
      let(:agent) { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST) }

      context "with agent, \"1\"" do
        it { atcoder.send(:get_task_id, agent, "1").should eq "440" }
      end

      context "with agent, \"2\"" do
        it { atcoder.send(:get_task_id, agent, "2").should eq "441" }
      end
    end

    describe "#language" do
      context "with \"c\"" do
        it { atcoder.send(:language, "c").should eq "1" }
      end

      context "with \"cc\"" do
        it { atcoder.send(:language, "cc").should eq "2" }
      end

      context "with \"cpp\"" do
        it { atcoder.send(:language, "cpp").should eq "2" }
      end

      context "with \"java\"" do
        it { atcoder.send(:language, "java").should eq "3" }
      end

      context "with \"php\"" do
        it { atcoder.send(:language, "php").should eq "5" }
      end

      context "with \"d\"" do
        it { atcoder.send(:language, "d").should eq "6" }
      end

      context "with \"py\"" do
        it { atcoder.send(:language, "py").should eq "7" }
      end

      context "with \"pl\"" do
        it { atcoder.send(:language, "pl").should eq "8" }
      end

      context "with \"rb\"" do
        it { atcoder.send(:language, "rb").should eq "9" }
      end

      context "with \"hs\"" do
        it { atcoder.send(:language, "hs").should eq "11" }
      end

      context "with \"p\"" do
        it { atcoder.send(:language, "p").should eq "12" }
      end

      context "with \"pp\"" do
        it { atcoder.send(:language, "pp").should eq "12" }
      end

      context "with \"pas\"" do
        it { atcoder.send(:language, "pas").should eq "12" }
      end

      context "with \"js\"" do
        it { atcoder.send(:language, "js").should eq "15" }
      end

      context "with \"vb\"" do
        it { atcoder.send(:language, "vb").should eq "16" }
      end

      context "with \"txt\"" do
        it { atcoder.send(:language, "txt").should eq "17" }
      end

      context "with \"text\"" do
        it { atcoder.send(:language, "text").should eq "17" }
      end

      context "with \"\"" do
        it { atcoder.send(:language, "").should be_nil }
      end
    end

    describe "#submit" do
      let(:agent) { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST) }

      context "with nil" do
        it { proc {atcoder.send(:submit, agent, nil, nil, nil)}.should raise_error(InputFormError) }
      end

      context "with source code is empty" do
        it { proc {atcoder.send(:submit, agent, "440", "1", "")}.should raise_error(InputFormError) }
      end
    end
  end
end

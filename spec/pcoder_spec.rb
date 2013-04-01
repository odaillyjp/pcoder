# coding: utf-8
$LOAD_PATH << File.expand_path("../../", __FILE__)
require 'rspec'
require 'lib/pcoder'
require 'spec/tmp/account.rb'

module Pcoder
  SPEC_HOST = "arc012.contest.atcoder.jp"

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
        it { atcoder.send(:login, 'foo', 'bar', SPEC_HOST).should be_nil }
      end

      context "with user, pass" do
        it { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST).class.should eq Mechanize }
      end
    end

    describe "#to_task_number" do
      context "with \"A\"" do
        it { atcoder.send(:to_task_number, "A").should eq "1" }
      end

      context "with \"B\"" do
        it { atcoder.send(:to_task_number, "B").should eq "2" }
      end

      context "with \"a\"" do
        it { atcoder.send(:to_task_number, "a").should eq "1" }
      end

      context "with \"1\"" do
        it { atcoder.send(:to_task_number, "1").should eq "" }
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

    describe "#language_value" do
      context "with \"C\"" do
        it { atcoder.send(:language_value, "C").should eq "1" }
      end

      context "with \"C++\"" do
        it { atcoder.send(:language_value, "C++").should eq "2" }
      end

      context "with \"Java\"" do
        it { atcoder.send(:language_value, "Java").should eq "3" }
      end

      context "with \"PHP\"" do
        it { atcoder.send(:language_value, "PHP").should eq "5" }
      end

      context "with \"D\"" do
        it { atcoder.send(:language_value, "D").should eq "6" }
      end

      context "with \"Python\"" do
        it { atcoder.send(:language_value, "Python").should eq "7" }
      end

      context "with \"Perl\"" do
        it { atcoder.send(:language_value, "Perl").should eq "8" }
      end

      context "with \"Ruby\"" do
        it { atcoder.send(:language_value, "Ruby").should eq "9" }
      end

      context "with \"haskell\"" do
        it { atcoder.send(:language_value, "Haskell").should eq "11" }
      end

      context "with \"Pascal\"" do
        it { atcoder.send(:language_value, "Pascal").should eq "12" }
      end

      context "with \"JavaScript\"" do
        it { atcoder.send(:language_value, "JavaScript").should eq "15" }
      end

      context "with \"Visual Basic\"" do
        it { atcoder.send(:language_value, "Visual Basic").should eq "16" }
      end

      context "with \"Text\"" do
        it { atcoder.send(:language_value, "Text").should eq "17" }
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

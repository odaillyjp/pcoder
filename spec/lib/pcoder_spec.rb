# coding: utf-8
require 'spec_helper'

module Pcoder
  SPEC_HOST = 'arc012.contest.atcoder.jp'
  SPEC_FILE = '../../support/practice_1.rb'

  describe SourceCode do
    let(:path) { File.expand_path(SPEC_FILE, __FILE__) }
    let(:source) { SourceCode.new(path) }

    describe '#initialize' do
      context 'with "#{SPEC_FILE}"' do
        it { source.basename.should eq 'practice_1.rb' }
        it { source.language_id.should eq '9' }
        it { source.task.should eq '1' }
        it { source.body.should eq "# Method check.\n"  }
      end
    end

    describe '#parse_task_option' do
      context 'with "arc012_1"' do
        it do
          source.send(:parse_task_option, 'arc012_1')
          source.task.should eq '1'
        end
      end

      context 'with "arc012_2"' do
        it do
          source.send(:parse_task_option, 'arc012_2')
          source.task.should eq '2'
        end
      end
    end

    describe '#correspond_to_language_id' do
      context 'with ".c"' do
        it { source.send(:correspond_to_language_id, '.c').should eq '1' }
      end

      context 'with ".cc"' do
        it { source.send(:correspond_to_language_id, '.cc').should eq '2' }
      end

      context 'with ".cpp"' do
        it { source.send(:correspond_to_language_id, '.cpp').should eq '2' }
      end

      context 'with ".java"' do
        it { source.send(:correspond_to_language_id, '.java').should eq '3' }
      end

      context 'with ".php"' do
        it { source.send(:correspond_to_language_id, '.php').should eq '5' }
      end

      context 'with ".d"' do
        it { source.send(:correspond_to_language_id, '.d').should eq '6' }
      end

      context 'with ".py"' do
        it { source.send(:correspond_to_language_id, '.py').should eq '7' }
      end

      context 'with ".pl"' do
        it { source.send(:correspond_to_language_id, '.pl').should eq '8' }
      end

      context 'with ".rb"' do
        it { source.send(:correspond_to_language_id, '.rb').should eq '9' }
      end

      context 'with ".hs"' do
        it { source.send(:correspond_to_language_id, '.hs').should eq '11' }
      end

      context 'with ".p"' do
        it { source.send(:correspond_to_language_id, '.p').should eq '12' }
      end

      context 'with ".pp"' do
        it { source.send(:correspond_to_language_id, '.pp').should eq '12' }
      end

      context 'with ".pas"' do
        it { source.send(:correspond_to_language_id, '.pas').should eq '12' }
      end

      context 'with ".js"' do
        it { source.send(:correspond_to_language_id, '.js').should eq '15' }
      end

      context 'with ".vb"' do
        it { source.send(:correspond_to_language_id, '.vb').should eq '16' }
      end

      context 'with ".txt"' do
        it { source.send(:correspond_to_language_id, '.txt').should eq '17' }
      end

      context 'with ".text"' do
        it { source.send(:correspond_to_language_id, '.text').should eq '17' }
      end

      context 'with ""' do
        it { source.send(:correspond_to_language_id, '').should be_nil }
      end
    end
  end

  describe Atcoder do
    let(:atcoder) { Atcoder.new }

    describe '#login' do
      context 'with not_user, not_pass' do
        it { proc { atcoder.send(:login, 'foo', 'bar', SPEC_HOST) }.should raise_error(LoginError) }
      end

      context 'with user, pass' do
        it { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST).class.should be_true }
      end
    end

    describe '#get_task_id' do
      before { atcoder.send(:login, ATCODER_USER, ATCODER_PASS, SPEC_HOST) }

      context 'with agent, "1"' do
        it { atcoder.send(:get_task_id, '1').should eq '440' }
      end

      context 'with agent, "2"' do
        it { atcoder.send(:get_task_id, '2').should eq '441' }
      end
    end
  end

  describe Console do
    let(:console) { Console.new }

    describe '#contest_host' do
      context 'with "practice_1.rb"'do
        it do
          console.send(:contest_host, 'practice_1.rb').should eq 'practice.contest.atcoder.jp'
        end
      end
    end
  end
end

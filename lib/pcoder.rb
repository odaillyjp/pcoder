require 'mechanize'

module Pcoder
  ATCODER_HOST = "contest.atcoder.jp"

  class Atcoder
    def process(user, pass, path, receiver = self)
      file = path.split("/").last
      sub_domain, task, extension = file.split(/[_.]/)
      sub_domain = ARGV[1] if ARGV[1]
      task = to_task_number(ARGV[2]) if ARGV[2]
      host = "#{sub_domain}.#{ATCODER_HOST}"
      agent = login(user, pass, host)
      raise LoginError if agent.nil?
      task_id = get_task_id(agent, task)
      language_value = language(extension)
      source_code = File.open(path).read
      receiver.submit(agent, task_id, language_value, source_code)
      puts "Successfully uploaded." if receiver == self
    end

    protected

    def submit(agent, task_id, language_value, source_code)
      raise InputFormError if task_id.nil? || language_value.nil? || source_code.nil?
      agent.get("http://#{agent.page.uri.host}/submit")
      agent.page.form_with do |f|
        f.field_with(:name => "task_id").value = task_id
        f.field_with(:name => "language_id_#{task_id}").value = language_value
        f.field_with(:name => "source_code").value = source_code
      end.click_button
      raise InputFormError if agent.page.uri.path == "/submit"
    end

    private

    def option_parse
      opt = OptionParser.new
      opt.on("-s SubDomain")
      opt.on("-t Task")
      opt.parse!(ARGV)
    end

    def to_task_number(str)
      ("@".."Z").to_a.index(str.upcase).to_s
    end

    def login(user, pass, host)
      agent = Mechanize.new
      agent.get("http://#{host}/login")
      before_uri = agent.page.uri
      agent.page.form_with do |f|
        f.field_with(:name => "name").value = user
        f.field_with(:name => "password").value = pass
      end.click_button
      return nil if agent.page.uri == before_uri
      agent
    end

    def get_task_id(agent, task)
      agent.get("http://#{agent.page.uri.host}/submit")
      selecter = "//select[@id=\"submit-task-selector\"]/option[#{task}]"
      agent.page.at(selecter)['value']
    end

    def language(extension)
      case extension
      # C
      when "c" then "1"
      # C++
      when "cc", "cpp" then "2"
      # Java
      when "java" then "3"
      # PHP
      when "php" then "5"
      # D
      when "d" then "6"
      # Python
      when "py" then "7"
      # Perl
      when "pl" then "8"
      # Ruby
      when "rb" then "9"
      # Haskell
      when "hs" then "11"
      # Pascal
      when "p", "pp", "pas" then "12"
      # HavaScript
      when "js" then "15"
      # Visual Basic
      when "vb" then "16"
      # Text
      when "txt", "text" then "17"
      else nil
      end
    end
  end

  class LoginError < StandardError; end
  class InputFormError < StandardError; end
end

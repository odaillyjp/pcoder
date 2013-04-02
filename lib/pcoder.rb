require 'pcoder/version'
require 'mechanize'
require 'optparse'

module Pcoder
  ATCODER_HOST = "contest.atcoder.jp"

  class Atcoder
    def initialize
      @opts = {}
      option_parse
    end

    def process(user, pass, path, this = self)
      file = path.split("/").last
      sub_domain, task_pos, extension = file.split(/[_.]/)
      sub_domain = @opts[:sub] if @opts[:sub]
      host = "#{sub_domain}.#{ATCODER_HOST}"
      agent = login(user, pass, host)
      task_pos = to_task_postion(@opts[:task]) if @opts[:task]
      task_id = get_task_id(agent, task_pos)
      language_value = language(extension)
      source_code = File.open(path).read
      puts "Successfully uploaded." if this.submit(agent, task_id, language_value, source_code)
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
      true
    end

    private

    def option_parse
      opt = OptionParser.new
      opt.on("-s SubDomain") {|v| @opts[:sub] = v }
      opt.on("-t Task") {|v| @opts[:task] = v }
      opt.on("-p Proxy") {|v| @opts[:proxy] = v }
    end

    def to_task_postion(str)
      ("@".."Z").to_a.index(str.upcase)
    end

    def login(user, pass, host)
      agent = Mechanize.new
      agent = set_agent_proxy(agent) if @opts[:proxy]
      agent.get("http://#{host}/login")
      before_uri = agent.page.uri
      agent.page.form_with do |f|
        f.field_with(:name => "name").value = user
        f.field_with(:name => "password").value = pass
      end.click_button
      if agent.page.uri == before_uri
        mes = "The username or password you entered is incorrect."
        raise LoginError.exception(mes)
      end
      agent
    end

    def set_agent_proxy(agent)
      host, port = @opts[:proxy].split(":")
      agent.set_proxy(host, port)
      agent
    end

    def get_task_id(agent, pos)
      agent.get("http://#{agent.page.uri.host}/submit")
      selecter = "//select[@id=\"submit-task-selector\"]/option[#{pos}]"
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

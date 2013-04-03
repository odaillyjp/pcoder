require 'mechanize'
require 'optparse'
require 'highline'

module Pcoder
  ATCODER_HOST = "contest.atcoder.jp"

  class Atcoder
    def initialize
      @opts = {}
      parse_options
    end

    def process(user = nil, pass = nil, path = nil, this = self)
      user = enter_username if user.nil?
      pass = enter_password if pass.nil?
      path = ARGV[0] if path.nil?
      file = File.basename(path)
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

    def exit_with_not_file
      puts "Please specify a file and try again."
      exit
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

    def parse_options
      opt = OptionParser.new
      opt.banner = "#{File.basename($0)} [file...]"
      opt.on("-s SubDomain", "Set Atcoder contest site sub domain.") {|v| @opts[:sub] = v }
      opt.on("-t Task", "Set task alphabet.") {|v| @opts[:task] = v }
      opt.on("--proxy Proxy", "Set proxy host. Example: \"proxy.example.com:8080\"") {|v| @opts[:proxy] = v }
      opt.on("-h", "--help", "Display Help.") do
        puts opt.help
        exit
      end
    end

    def enter_username
      HighLine.new.ask("USERNAME: ")
    end

    def enter_password
      HighLine.new.ask("PASSWORD: ") { |q| q.echo = "*" }
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

    def to_task_postion(str)
      ("@".."Z").to_a.index(str.upcase)
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

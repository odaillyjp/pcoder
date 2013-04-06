require 'mechanize'
require 'optparse'
require 'highline'

module Pcoder
  ATCODER_HOST = "contest.atcoder.jp"

  class SourceCode
    attr_reader :basename, :language_id, :task, :body

    def initialize(path)
      @basename = File.basename(path)
      extname = File.extname(path)
      @language_id = to_language_id(extname)
      @task = @basename.split(/[_.]/)[1]
      @body = File.open(path).read
    end

    def set_task_option(str)
      @task = ("@".."Z").to_a.index(str.upcase)
    end

    private

    def to_language_id(extname)
      case extname
      # C
      when ".c" then "1"
      # C++
      when ".cc", ".cpp" then "2"
      # Java
      when ".java" then "3"
      # PHP
      when ".php" then "5"
      # D
      when ".d" then "6"
      # Python
      when ".py" then "7"
      # Perl
      when ".pl" then "8"
      # Ruby
      when ".rb" then "9"
      # Haskell
      when ".hs" then "11"
      # Pascal
      when ".p", ".pp", ".pas" then "12"
      # HavaScript
      when ".js" then "15"
      # Visual Basic
      when ".vb" then "16"
      # Text
      when ".txt", ".text" then "17"
      else nil
      end
    end
  end

  class Atcoder
    def initialize
      @agent = Mechanize.new
    end

    def login(user, pass, host)
      @agent.get("http://#{host}/login")
      before_uri = @agent.page.uri
      @agent.page.form_with do |f|
        f.field_with(:name => "name").value = user
        f.field_with(:name => "password").value = pass
      end.click_button
      if @agent.page.uri == before_uri
        mes = "The username or password you entered is incorrect."
        raise LoginError.exception(mes)
      end
      true
    end

    def submit(source)
      @agent.get("http://#{@agent.page.uri.host}/submit")
      task_id = get_task_id(source.task)
      @agent.page.form_with do |f|
        f.field_with(:name => "task_id").value = task_id
        f.field_with(:name => "language_id_#{task_id}").value = source.language_id
        f.field_with(:name => "source_code").value = source.body
      end.click_button
      if @agent.page.uri.path == "/submit"
        mes = "Please check file name or body and try again"
        raise InputFormError.exception(mes)
      end
      true
    end

    def set_proxy(proxy)
      host, port = proxy.split(":")
      @agent.set_proxy(host, port)
    end

    def get_task_id(pos)
      @agent.get("http://#{@agent.page.uri.host}/submit")
      selecter = "//select[@id=\"submit-task-selector\"]/option[#{pos}]"
      @agent.page.at(selecter)['value']
    end
  end

  class Processor
    def initialize
      @opts = {}
    end

    def run(path = ARGV[0], this = self, atcoder = Atcoder.new, source = nil)
      exit_with_message("Please specify a file and try agein.") if path.nil?
      user = this.enter_username
      pass = this.enter_password
      source ||= SourceCode.new(path)
      host = contest_host(source.basename)
      atcoder.login(user, pass, host)
      atcoder.set_proxy(@opts[:proxy]) if @opts[:proxy]
      source.set_task_option(@opts[:task]) if @opts[:task]
      puts "Successfully uploaded." if atcoder.submit(source)
    end

    def parse_options
      opt = OptionParser.new
      opt.banner = "#{File.basename($0)} [file...]"
      opt.on("-s SubDomain", "Set Atcoder contest site sub domain.") {|v| @opts[:sub] = v }
      opt.on("-t Task", "Set task alphabet.") {|v| @opts[:task] = v }
      opt.on("--proxy Proxy", "Set proxy host. Example: \[ --proxy proxy.example.com:8080 \]") {|v| @opts[:proxy] = v }
      opt.on("-h", "--help", "Display Help.") do
        puts opt.help
        exit
      end
      opt.parse!(ARGV)
    end

    protected

    def exit_with_message(mes)
      puts mes
      exit
    end

    def enter_username
      HighLine.new.ask("Username: ")
    end

    def enter_password
      HighLine.new.ask("Password: ") { |q| q.echo = "*" }
    end

    def contest_host(basename)
      sub_domain = @opts[:sub] || basename.split("_").first
      "#{sub_domain}.#{ATCODER_HOST}"
    end
  end

  class LoginError < StandardError; end
  class InputFormError < StandardError; end
end

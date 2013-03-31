require 'mechanize'

module Pcoder
  ATCODER_CONTEST_HOST = "contest.atcoder.jp"

  class Atcoder
    def submit(user, pass, file)
      contest, assignment, extension = file.split(/[_.]/)
      host = "#{contest}.#{ATCODER_CONTEST_HOST}"
      agent = login(user, pass, host)
      raise "LoginError" if agent.nil?
      task_id = get_task_id(agent, assignment)
      language_name = language(extension)
      language_value = language_value(language_name)
      raise "InputFormError" if task_id.nil? || language_value.nil?
      agent.page.form_with do |f|
        f.field_with(:name => "task_id").value = task_id
        f.field_with(:name => "language_id_#{task_id}").value = language_value
      end.click_button
    end

    private

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

    def get_task_id(agent, assignment)
      agent.get("http://#{agent.page.uri.host}/submit")
      selecter = "//select[@id=\"submit-task-selector\"]/option[#{assignment}]"
      agent.page.at(selecter)['value']
    end

    def language(extension)
      case extension
      when "c" then "C"
      when "cc", "cpp" then "C++"
      when "d" then "D"
      when "java" then "Java"
      when "php" then "PHP"
      when "py" then "Python"
      when "pl" then "Perl"
      when "rb" then "Ruby"
      when "hs" then "Haskell"
      when "p", "pp", "pas" then "Pascal"
      when "js" then "JavaScript"
      else nil
      end
    end

    def language_value(language_name)
      language_value = {
        "1" => "C",
        "2" => "C++",
        "3" => "Java",
        "5" => "PHP",
        "6" => "D",
        "7" => "Python",
        "8" => "Perl",
        "9" => "Ruby",
        "11" => "Haskell",
        "12" => "Pascal",
        "15" => "JavaScript"
      }
      language_value.key(language_name)
    end
  end
end

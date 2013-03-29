require 'mechanize'

module Pcoder
  ATCODER_URI = "contest.atcoder.jp"

  class Atcoder
    def submit(user, pass, file)
      contest, assignment, extension = file.split(/[_.]/)
      uri = "http://#{contest}.#{ATCODER_URI}"
      agent = login(user, pass, uri)
      raise "LoginError" if agent.nil?
      agent.get("#{uri}/submit")
      agent.page.form_with do |f|
        f.field_with(:name => "name").value = user
        f.field_with(:name => "password").value = pass
      end.click_button
    end

    def login(user, pass, uri)
      agent = Mechanize.new
      agent.get("#{uri}/login")
      before_uri = agent.page.uri
      agent.page.form_with do |f|
        f.field_with(:name => "name").value = user
        f.field_with(:name => "password").value = pass
      end.click_button
      return nil if agent.page.uri == before_uri
      agent
    end
  end
end

Pcoder::Atcoder.new.submit("user","pass","arc012.rb")

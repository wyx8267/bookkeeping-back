class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: '369264448@qq.com', subject: 'Ruby Rails Mail Test')
  end
end

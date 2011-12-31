class SampleMailer < ActionMailer::Base
  default :from => "Crystallography Service <ncrystal@ncl.ac.uk>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sample.sample_receipt.subject
  #
  def sample_receipt(sample)
    @sample = sample
    @greeting = "Hi"
    mail(:to => "#{sample.user.firstname} #{sample.user.lastname} <#{sample.user.email}>", :subject => "Crystallography Service: Analysis Request Acknowledgement")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sample.sample_update.subject
  #
  def sample_update(sample)
    @greeting = "Hi"

    mail(:to => "#{sample.user.firstname} #{sample.user.lastname} <#{sample.user.email}>", :subject => "Crystallography Service: Sample Status Update Notification")
  end
end

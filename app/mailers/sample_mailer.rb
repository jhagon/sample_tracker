class SampleMailer < ActionMailer::Base
  CRYS_EMAIL = "xray.cryst@ncl.ac.uk"
  LOCAL_ADMIN_EMAIL = "crysadmin@milkyway.ncl.ac.uk"
  default :from => "Crystallography Service <#{CRYS_EMAIL}>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sample.sample_update.subject
  #

  def sample_receipt(sample)

  # First, create cc list. This will be all group leaders.
  #

  group_leaders = User.where("group_id = ?", sample.user.group_id).where(:leader => true)

  # if sample user is a group leader, remove him from cc list.

  group_leaders = group_leaders.where("id <> ?", sample.user.id)

  # now create cc list from group leader emails.
  # need to produce a simple array of emails for the argument to cc.
  # do this with map (also known as collect):

  cclist = group_leaders.map {|x| x.email}

    @sample = sample
    @greeting = "Hello"
    mail(:to => "#{sample.user.firstname} #{sample.user.lastname} <#{sample.user.email}>", :cc => cclist, :subject => "Crystallography Service: New Sample Submission Acknowledgement")
  end

  def sample_request(sample)

    @sample = sample
    @greeting = "Hello"
    mail(:to => "Crystallography Service <#{CRYS_EMAIL}>", 
         :from => "#{LOCAL_ADMIN_EMAIL}",
         :subject => "#{sample.user.firstname} #{sample.user.lastname}: New Sample Submission Request")
  end


  def sample_update(sample, old_flag)

  # First, create cc list. This will be all group leaders.
  # 
    
  group_leaders = User.where("group_id = ?", sample.user.group_id).where(:leader => true)

  # if sample user is a group leader, remove him from cc list.

  group_leaders = group_leaders.where("id <> ?", sample.user.id)

  # now create cc list from group leader emails.
  # need to produce a simple array of emails for the argument to cc.
  # do this with map (also known as collect):

  cclist = group_leaders.map {|x| x.email}

    @sample = sample
    @old_flag = old_flag
    @greeting = "Hello"

    mail(:to => "#{sample.user.firstname} #{sample.user.lastname} <#{sample.user.email}>", :cc => cclist, :subject => "Crystallography Service: Sample Status Update Notification")
  end

end

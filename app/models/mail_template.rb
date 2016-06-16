class MailTemplate < ActiveRecord::Base
  before_destroy :unauthorized_destroy
  before_create :unauthorized_create

  def delete
    raise Exception, "You are not authorized to delete this record"
  end

  def self.delete_all
    raise Exception, "You are not authorized to delete all record"
  end

  def unauthorized_destroy
    raise Exception, "You are not authorized to destroy this record"
  end

  def unauthorized_create
    raise Exception, "You are not authorized to create new record"
  end

end

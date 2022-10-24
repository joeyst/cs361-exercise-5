# Exercise 5 

class LaunchDiscussionWorkflow

  def initialize(discussion, host, participants)
    @discussion = discussion
    @host = host
    @participants = participants
  end

  def initialize_with_string(discussion, host, participants_email_string)
    Self.new(discussion, host, get_users(participants_email_string))
  end

  # Expects @participants array to be filled with User objects
  def run
    return if participants.empty?
    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        discussion.save!
        create_discussion_roles!
        @successful = true
      end
    end
  end
  
  private: 
  def get_list_of_emails(str)
    str.split("\n")
  end

  def get_unique_emails(str)
    get_list_of_emails(str).uniq
  end

  def get_users(str)
    return if str.blank? 
    get_unique_emails(str).map { |email| User.create(email: email.downcase, password: Devise.friendly_token) } 
  end 
end


discussion = Discussion.new(title: "fake", ...)
host = User.find(42)
participants = "fake1@example.com\nfake2@example.com\nfake3@example.com"

workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.run
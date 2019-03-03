class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #attr_accessible :email, :password, :remember_me, :role_id
  has_many :authentications, :dependent => :delete_all
  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.image = auth['info']['image']
    self.email = auth['extra']['raw_info']['email']
    self.username = auth['info']['name']
    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])

  end

  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

  def active_for_authentication?
                 # puts current_user.id

          puts self.id
          puts self.role_id
               if (self.role_id==3)
                 @bool = false
                 puts @bool

               else
                 @bool = true
                 puts @bool
               end
            super && @bool
  end

  def inactive_message
    "Sorry, this account has been deactivated. Contact the admins."
  end



  include TheRoleUserModel

end

# Data Template:
# users:
#   user1: 
#     ssh_authorized_keys: 
#       - key1
#       - key2
#     groups:
#       - group1
#       - group2
#       - group3
#     ensure: present
#     other_users_config...
#    user2:
#    ...

define "users::create", :users do

  @users.collect do |username,user_data|

    authorized_keys = user_data.delete('ssh_authorized_keys')

    user username, user_data

    unless authorized_keys.nil?

      ssh_authorized_key_params = {
          :user => username,
          :type => 'rsa',
          :require => "User[" << username << "]"
      }
      if authorized_keys.kind_of?(String)
        res_name = username + "_" + authorized_keys
        ssh_authorized_key_params[:key] = authorized_keys
        ssh_authorized_key res_name, ssh_authorized_key_params
      else
        authorized_keys.each do |authorized_key|
          res_name = username + "_" + authorized_key
          ssh_authorized_key_params[:key] = authorized_key
          ssh_authorized_key res_name, ssh_authorized_key_params
        end
      end
    end
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many_attached :photos
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user1_meetings, :class_name => 'Meeting', :foreign_key => 'user1_id'
  has_many :user2_meetings, :class_name => 'Meeting', :foreign_key => 'user2_id'
  has_many :availabilities
  has_many :lapins
  has_many :liked_users, :class_name => 'Like', :foreign_key => 'liked_user_id'
  has_many :unliked_users, :class_name => 'Unlike', :foreign_key => 'unliked_user_id'
  validates :email, :name, :description, :age, :height, :sex, :sexual_orientation, presence: true

  def afterworks_dispos
    avails = self.availabilities.pluck(:days, :afterwork).delete_if { |arr| arr.last == false }
    avails.map do |arr|
      arr[1] = "afterwork"
      arr
    end
  end

  def diners_dispos
    avails = self.availabilities.pluck(:days, :diner_time).delete_if { |arr| arr.last == false }
    avails.map do |arr|
      arr[1] = "diner_time"
      arr
    end
  end

  def my_dispos
    afterworks_dispos + diners_dispos
  end

  def first_matching_dispo_with(other_user)
    matching_dispos_with(other_user).compact.first
  end

  def matching_dispos_with(other_user)
    my_dispos.map do |dispo|
      dispo if other_user.my_dispos.include?(dispo)
    end
  end

  def interesting_users
    cu_id = self.id
    cu_user = User.find(cu_id)
    list_users = User.all
    wanted_users =[]
    case cu_user.sex
    when "Homme"
      if cu_user.sexual_orientation == "hetero"
        list_users.each do |user|
          if user.sex == "Femme" && user.sexual_orientation == ("hetero"||"bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "homo"
        list_users.each do |user|
          if user.sex == "Homme" && user.sexual_orientation == ("homo"||"bi")
            wanted_users << user
          end
        end
      else
        list_users.each do |user|
          if (user.sex == "Femme" && user.sexual_orientation == ("hetero"||"bi")) || (user.sex =="Homme" && user.sexual_orientation == ("homo"||"bi"))
            wanted_users << user
          end
        end
      end
    when "Femme"
      if cu_user.sexual_orientation == "hetero"
        list_users.each do |user|
          if user.sex == "Homme" && user.sexual_orientation == ("hetero"||"bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "homo"
        list_users.each do |user|
          if user.sex == "Femme" && user.sexual_orientation == ("homo"||"bi")
            wanted_users << user
          end
        end
      else
        list_users.each do |user|
          if (user.sex == "Femme" && user.sexual_orientation == ("homo"||"bi")) || (user.sex =="Homme" && user.sexual_orientation == ("hetero"||"bi"))
            wanted_users << user
          end
        end
      end
    end
    wanted_users
  end

  def seen_users
    cu_id = self.id
    cu_user = User.find(cu_id)
    list_users = interesting_users
    wanted_users = []
    seen = false
    list_users.each do |user|
      user.liked_users.each do |like|
        seen = true if like.user_id == cu_id
      end
      user.unliked_users.each do |unlike|
        seen = true if unlike.user_id == cu_id
      end
      wanted_users << user if seen == false
    end
    wanted_users
  end

end

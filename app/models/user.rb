class User < ApplicationRecord
  DAYS = ["lundi", "mardi",  "mercredi", "jeudi", "vendredi", "samedi", "dimanche"]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  geocoded_by :position
  after_validation :geocode, if: :will_save_change_to_position?
  has_many_attached :photos
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user1_meetings, :class_name => 'Meeting', :foreign_key => 'user1_id'
  has_many :user2_meetings, :class_name => 'Meeting', :foreign_key => 'user2_id'
  has_many :availabilities
  has_many :lapins

  has_many :likes
  has_many :liked_users, through: :likes, class_name: 'User'
  has_many :unlikes
  has_many :unliked_users, through: :unlikes, class_name: 'User'
  # has_many :liked_users, :class_name => 'Like', :foreign_key => 'liked_user_id', dependent: :destroy
  # has_many :unliked_users, :class_name => 'Unlike', :foreign_key => 'unliked_user_id', dependent: :destroy_all


  validates :email, :name, :description, :age, :height, :sex, :sexual_orientation, presence: true
  after_create :create_user_weeks_availabilities
  accepts_nested_attributes_for :availabilities
  has_many :feedbacks

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
    list_users = User.all.where.not(id: cu_user.id)
    wanted_users =[]
    case cu_user.sex
    when "Homme"
      if cu_user.sexual_orientation == "hetero"
        list_users.each do |user|
          if user.sex == "Femme" && (user.sexual_orientation == "homo" || user.sexual_orientation == "bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "homo"
        list_users.each do |user|
          if user.sex == "Homme" && (user.sexual_orientation == "homo" || user.sexual_orientation == "bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "bi"
        list_users.each do |user|
          if (user.sex == "Femme" && (user.sexual_orientation == "hetero" || user.sexual_orientation == "bi")) || (user.sex =="Homme" && (user.sexual_orientation == "homo" || user.sexual_orientation == "bi"))
            wanted_users << user
          end
        end
      end
    when "Femme"
      if cu_user.sexual_orientation == "hetero"
        list_users.each do |user|
          if user.sex == "Homme" && (user.sexual_orientation == "hetero" || user.sexual_orientation == "bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "homo"
        list_users.each do |user|
          if user.sex == "Femme" && (user.sexual_orientation == "homo" || user.sexual_orientation == "bi")
            wanted_users << user
          end
        end
      elsif cu_user.sexual_orientation == "bi"
        list_users.each do |user|
        if (user.sex == "Femme" && (user.sexual_orientation == "homo" || user.sexual_orientation == "bi")) || (user.sex == "Homme" && (user.sexual_orientation == "hetero" || user.sexual_orientation == "bi"))
          wanted_users << user
        end
        end
      end
    end
    wanted_users
  end

  def seen_users
    users = interesting_users - self.liked_users
    users - self.unliked_users


    # cu_id = self.id
    # cu_user = User.find(cu_id)
    # list_users = interesting_users
    # wanted_users = []
    # list_users.each do |user|
    #   seen = false
    #   user.liked_users.each do |user|
    #     seen = true if user.id == cu_id
    #   end
    #   user.unliked_users.each do |unlike|
    #     seen = true if unlike.user_id == cu_id
    #   end
    #   wanted_users << user if seen == false
    # end
    # wanted_users
  end

  def create_user_weeks_availabilities
    DAYS.each do |day|
      availability = Availability.new(
        user: self,
        days: day,
        afterwork: true,
        diner_time: true)
      availability.save!
    end
  end
end

class User < ApplicationRecord
    validates :email,{uniqueness: true}
    validates :email, {presence: true}
    validates :name, {presence: true}
    validates :password, {presence: true}

    def posts
        return Post.where(user_id: self.id)
    end

    has_many :messages
end

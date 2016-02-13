class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

#유저는 여러 글과 댓글을 쓸 수 있다.
  has_many :posts
  has_many :comments
  
end

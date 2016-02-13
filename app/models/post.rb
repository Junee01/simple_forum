class Post < ActiveRecord::Base
#글은 좋아요 투표가 가능하다.
	acts_as_votable
#글은 유저에게 속해있고, 여러 댓글을 가질 수 있다.
	belongs_to :user
	has_many :comments
end

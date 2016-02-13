class Comment < ActiveRecord::Base
#댓글은 유저와 글에 속해있다.
  belongs_to :user
  belongs_to :post
end

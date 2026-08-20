class PostTagsController < ApplicationController
  def destroy
    post_tag = PostTag.friendly.find(params[:id])
    post = post_tag.post

    post_tag.destroy

    redirect_to edit_post_path(post)
  end
end
class WelcomeController < ApplicationController
  caches_action :index
  def index
    @posts = Post.order("created_at DESC").limit(5)
  end
end

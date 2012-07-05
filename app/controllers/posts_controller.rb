# -*- coding: utf-8 -*-
class PostsController < ApplicationController
  before_filter :login_required, only: [:edit, :destroy, :update, :new, :create]
  
  caches_action :index, :raw, :show
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1/raw
  def raw
    @post = Post.find(params[:id])
    render text: @post.body, :content_type => 'text/plain'
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    #TODO:前後の記事へのポインタ
    all=Post.all
    index=all.rindex(@post)
    if index!=0 
      @prev_id=all[index-1].id
      @prev_title=all[index-1].title
    end
    if index+1 != all.count 
      @next_id=all[index+1].id 
      @next_title=all[index+1].title
    end

    @enabled_article_js =  cookies[:enabled_article_js]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    delete_caches
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    delete_caches
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    delete_caches
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
    delete_caches
  end

  def toggle_js
    # TODO: cache機能に合うように
    e = ""
    if cookies[:enabled_article_js]
      cookies.delete :enabled_article_js
      e = "無効"
    else
      cookies[:enabled_article_js] = {
        value: "true",
        expires: 120.days.from_now,
      }
      e = "有効"
    end
    flash[:notice] = "記事中のJavaScriptを#{e}にしました"
    redirect_to :back
  end
  
  def delete_caches()
    expire_action action: :index
    expire_action action: :raw
    expire_action action: :show
    expire_action controller: :welcome ,action: :index
  end

end

class ListsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :check_item]
  before_action :correct_user, only: [:edit, :update]

  def show
    @list = List.find(params[:id])
    @list_user = nil
    if logged_in?
      @list_user = current_user.list_users.find_by(list: @list)
    end
  end

  def index
    #TODO make recent
    @lists = List.paginate(page: params[:page])
  end

  def popular
    #TODO
    @lists = List.paginate(page: params[:page])
  end

  def new
    @list = List.new
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      flash[:success] = 'List created'
      redirect_to @list
    else
      render 'new'
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.update_attributes(list_params.merge(updated_at: Time.now))
      flash[:success] = 'List edited'
      redirect_to list_path(@list)
    else
      flash[:error] = @list.errors
      redirect_to edit_list_path(@list)
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to lists_path
  end

  def check_item
    list_item = ListItem.find(params[:id])
    user_check = UserCheck.find_or_create_by(user: current_user, list_item: list_item)
    user_check.completed = !user_check.completed
    if user_check.save
      current_user.check_completion(list_item.list)
      redirect_back(fallback_location: list_item.list)
    else
      flash[:error] = user_check.errors
      redirect_back(fallback_location: list_item.list)
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :description, list_items_attributes: [:id , :title, :description, :_destroy])
  end

  def correct_user
    @list ||= List.find(params[:id])
    redirect_to(lists_path) unless current_user?(@list.user)
  end
end

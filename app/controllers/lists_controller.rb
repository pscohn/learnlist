class ListsController < ApplicationController
  def show
    @list = List.find(params[:id])
  end

  def index
    @lists = List.all
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
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
    if @list.update_attributes(list_params)
      flash[:success] = 'List edited'
      redirect_to edit_list_path(@list)
    else
      flash[:error] = 'Some error'
      redirect_to :edit
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :description, list_items_attributes: [:id , :title, :description])
  end
end

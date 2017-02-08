class ListItemsController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    @list_item = @list.list_items.create(list_item_params)
    if @list_item.save
      flash[:success] = 'Item created'
      redirect_to @list_item.list
    else
      flash[:error] = 'Error'
      redirect_to @list_item.list
    end
  end

  def update
    @list_item = ListItem.find(params[:id])
    if @list_item.update(list_item_params)
      flash[:success] = 'List item edited'
      redirect_to edit_list_path(@list_item.list)
    else
      flash[:error] = 'Some error'
      redirect_to :edit
    end
  end

  private

  def list_item_params
    params.require(:list_item).permit(:title, :description)
  end
end

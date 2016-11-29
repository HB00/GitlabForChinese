class Admin::BroadcastMessagesController < Admin::ApplicationController
  before_action :finder, only: [:edit, :update, :destroy]

  def index
    @broadcast_messages = BroadcastMessage.reorder("ends_at DESC").page(params[:page])
    @broadcast_message  = BroadcastMessage.new
  end

  def edit
  end

  def create
    @broadcast_message = BroadcastMessage.new(broadcast_message_params)

    if @broadcast_message.save
      redirect_to admin_broadcast_messages_path, notice: '广播信息创建成功。'
    else
      render :index
    end
  end

  def update
    if @broadcast_message.update(broadcast_message_params)
      redirect_to admin_broadcast_messages_path, notice: '广播信息更新成功。'
    else
      render :edit
    end
  end

  def destroy
    @broadcast_message.destroy

    respond_to do |format|
      format.html { redirect_back_or_default(default: { action: 'index' }) }
      format.js { head :ok }
    end
  end

  def preview
    @broadcast_message = BroadcastMessage.new(broadcast_message_params)
  end

  protected

  def finder
    @broadcast_message = BroadcastMessage.find(params[:id])
  end

  def broadcast_message_params
    params.require(:broadcast_message).permit(%i(
      color
      ends_at
      font
      message
      starts_at
    ))
  end
end

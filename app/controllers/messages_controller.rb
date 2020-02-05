class MessagesController < ApplicationController
  def create
    message = Message.new(message_param)
    conversation = Conversation.find(message_param[:conversation])
    if message.save
      #serialized_data = ActiveModelSerializers::Adapter::Json.new(
      #    MessageSerializer.new(message)
      #).serializable_hash
      MessagesChannel.broadcast_to conversation, message
    end
  end

  private

  def message_param
    params.permit(
        :text, :conversation_id

    )
  end
end
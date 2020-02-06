class ConversationsController < ApplicationController
  def index
    conversations = Conversation.all
    render json: conversations
      #json_response_raw conversations, :ok
  end
  def create
    conversation = Conversation.new(conversation_params)
    if conversation.save
      #serialized_data = ActiveModelSerializers::Adapter::Json.new(
      #    ConversationSerializer.new(conversation)
      #).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', conversation
      head :ok
    end
  end

  private

  def conversation_params
    params.permit(:title)
  end
end

class ConversationSerializer < ActiveModel::Serializer
  has_many :messages, serializer: MessageSerializer
  attributes :id, :title
end

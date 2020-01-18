# this is used for custom Json response

module Response
  def json_response(message, is_success, data, status)
    render json: {
        message: message,
        is_success: is_success,
        data: data,
        status: status
    }
  end

  def json_response_raw(data, status)
    render json: {
        data: data,
        status: status
    }
  end

  def json_err_response(error, status)
    render json: {
        error: error,
        is_success: false,
        status: status
    }
  end
end
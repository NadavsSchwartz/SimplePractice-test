class GetAppointments
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = get_all_past_appointments(@initial_scope, params[:past])
    get_all_appointments_paginated(scoped, params[:page], params[:length])
  end

  private def get_all_past_appointments(scoped, past)
    # if past param exists but not valid, return error
    if past && !%w[0 1].include?(past)
      { error: 'past must be 0 or 1' }
    # if past param exists and is valid, return all appointments based on past param
    elsif past && %w[0 1].include?(past)
      scoped.where("start_time #{past == '0' ? '>' : '<'} ?", Time.now)
    else
      # if past param does not exist, return all appointments
      scoped
    end
  end

  private def get_all_appointments_paginated(scoped, page = nil, length = nil)
    # if only one of page or length params exists, return error
    return { error: 'page and length must be present together' } if page.nil? ^ length.nil?

    # if both page and length params exist but are not integers bigger than 0, return error
    return { error: 'page and length must be integers bigger than 0' } if page && page.to_i <= 0 || length && length.to_i <= 0

    # if both page and length params exist and are valid, return paginated appointments
    return scoped.limit(length).offset((page.to_i - 1) * length.to_i) if page && length

    # if neither page or length params exist, return all appointments
    scoped
  end
end

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
    return { error: 'past must be 0 or 1' } if past && !%w[0 1].include?(past)

    scoped.where("start_time #{past == '0' ? '<' : '>'} ?", Time.now)
  end

  private def get_all_appointments_paginated(scoped, page = nil, length = nil)
    # if only one of page or length is present, return errrorr
    return { error: 'page and length must be present together' } if page.nil? ^ length.nil?

    # validate that page and length both exists and are integers
    return { error: 'page and length must be integers' } if page && length && (page.to_i.to_s != page || length.to_i.to_s != length)

    # if page and length are both present, return paginated results
    scoped.limit(length).offset(page.to_i * length.to_i)
  end
end

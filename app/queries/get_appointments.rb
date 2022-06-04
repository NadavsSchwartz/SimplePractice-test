
class GetAppointments
    attr_accessor :initial_scope

    def initialize(initial_scope)
 
      @initial_scope = initial_scope
    end

  def call(params)
    scoped = get_all_past_appointments(@initial_scope, params[:past]) 
    scoped = get_all_appointments_paginated(scoped, params[:page], params[:length])
    scoped
  end
 
  private def get_all_past_appointments(scoped, past)
    if past && !['0', '1'].include?(past)
        return { error: 'past must be 0 or 1' }
    end
    scoped.where("start_time #{past == '0' ? '<' : '>'} ?", Time.now) 
  end

    private def get_all_appointments_paginated(scoped, page = nil, length = nil)
     
        if page.nil? ^ length.nil?
            return { error: 'page and length must be present together' }
            end
        
        if page && length
            if page.to_i.to_s != page || length.to_i.to_s != length
                return { error: 'page and length must be integers' }
            end
        end
        
        scoped.limit(length).offset((page.to_i) * length.to_i) 
    end
end
class UserInteractionAggregated

  class UserInteractionAggregatedRow
    attr_accessor :user_id, :user_name, :start_time, :end_time, :count

    def initialize(user_interaction_obj)
      @user_id    = user_interaction_obj.user_id
      @user_name  = user_interaction_obj.user.name
      @start_time = user_interaction_obj.created_at
      @end_time   = user_interaction_obj.created_at
      @count = 1
    end

    def update_start_time(new_start_time)
      @start_time = new_start_time
      @count += 1
    end
  end


  def initialize(session_duration=5.minutes)
    @array = Array.new
    @session_duration = session_duration
  end

  def aggregate(selection_array) # array must be ordered by created_at (most recent first)
    while selection_array.any?
      add selection_array.shift
    end
  end

  def each(&block)
    @array.each &block
  end

  def size
    @array.size
  end

  private
    def add(user_interaction_obj)
      if @array.any? && @array.last.user_id==user_interaction_obj.user_id && @array.last.start_time-@session_duration<user_interaction_obj.created_at
        @array.last.update_start_time(user_interaction_obj.created_at)
      else
        @array << UserInteractionAggregatedRow.new(user_interaction_obj)
      end
    end
end

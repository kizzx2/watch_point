require 'pry'

require 'watch_point/version'

module WatchPoint
  @watch_list = []
  @last_binding = nil

  @interactive_thread = nil
  @sleeping_threads = []

  class << self
    def watch(obj)
      if @watch_list.any? { |obj1, _| obj1.object_id == obj.object_id }
        raise ArgumentError, "Already watching object ##{obj.object_id}"
      end

      @watch_list << [obj, obj.hash]
      @last_binding ||= binding
    end

    def unwatch(obj)
      @watch_list.delete_if do |obj1, _|
        obj.object_id == obj1.object_id
      end
    end

    def enable
      set_trace_func(proc do |event, _, _, _, b, _|
        if @interactive_thread && Thread.current != @interactive_thread
          @sleeping_threads << Thread.current
          Thread.stop
        end

        next if event != 'line'

        @watch_list.each do |obj, hash0|
          if obj.hash != hash0
            self.unwatch(obj)

            @interactive_thread = Thread.current
            # puts "Object #{obj} changed!"
            @last_binding.pry

            @interactive_thread = nil
            @sleeping_threads.each(&:wakeup)
            @sleeping_threads = []

            self.watch(obj)

            break
          end
        end

        @last_binding = b
      end)
    end

    def disable
      set_trace_func(nil)
    end
  end
end

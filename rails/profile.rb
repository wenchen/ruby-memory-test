require 'memory_profiler'

ENV['RAILS_ENV'] = "development";
MemoryProfiler.report do
    # 初始化 Rails application
    require './config/environment'

    # 對 Rails 做任何想做的事情
    User.first
end.pretty_print(to_file: 'memory_report.log')
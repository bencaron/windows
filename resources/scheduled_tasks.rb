#
# Author:: Benoit Caron (<benoit@patentemoi.ca>)
# Cookbook Name:: windows
# Provider:: scheduled_tasks
#
# Copyright:: 2012
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


#def initialize(name,run_context=nil)
#  super
#  @action = :create
#end
#

actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
#optional
attribute :task_name, :kind_of => [ String ]

#required (/w defaults)
attribute :command, :kind_of => [ String ]

attribute :frequency, :kind_of => [ String ], :equal_to => %w(minute hourly daily weekly monthly)
# Run every X units
attribute :every, :kind_of => [ Integer ], :default => 1

# things that depends on :frequency = weekly
attribute :day ,  :kind_of => [ String ], :default => "all", :regex => /(all|mon|tue|wed|thu|fri|sat|sun)|\d{1,2}/
# things that depends on :frequency = monthly 
attribute :month, :kind_of => [ String ], :default => "all", :equal_to => %w(all jan fev mar apr may jun jul aug sep oct nov dec)


# start date / time ; optionnal, if not set, assume NOW
attribute :start_time,  :kind_of => [ String ], :default => "now", :regex => /(now|\d\d:\d\d)/
# WARNING: the format for the date changes from locales to locales!
# Englis version is MM/DD/YYYY ; French Canada is YYYY/MM/DD
attribute :start_date,  :kind_of => [ String ], :default => "now"

# Max duration for this command to run. For details, see 
#/du Duration 
attribute :max_duration,  :kind_of => [ String ], :default => "forever", :regex =>  /forever|\d{1,4}:\d\d/
# Max duration for this command to run, kill after that time
attribute :kill_after  ,  :kind_of => [ String ], :default => "forever", :regex =>  /forever|\d{1,4}:\d\d/


# Carefull: setting this force us to play a stupid game of create-dump-mods-load because schedtask.exe lack an option
# to specify a workig directory...
#attribute :working_directory , :kind_of => [ String ], :default => "none", :equal_to => "DO NOT USE NOT TESTED"


# User credentials
attribute :user, :kind_of => [ String ]
attribute :password, :kind_of => [ String ]

#
# Author:: Benoit Caron (<benoit@patentemoi.ca>)
# Cookbook Name:: windows
# Provider:: windows_path
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
#
# Details on how schedtask.exe works can be found here:
# http://technet.microsoft.com/en-us/library/cc772785(v=ws.10).aspx#BKMK_hours

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :create do 

  #FIXME: there is no attempt at being idempotent whatsoever



#schtasks /create /sc hourly /mo 5 /sd 03/01/2002 /tn "My App" /tr c:\apps\myapp.exe
#    /F
#Specifies to create the task and suppress warnings if the specified task already exists.

#    create_cmd = %Q(schtasks /create /sc #{@new_resource.frequency} /mo #{@new_resource.recurrence} 
#             /tn "#{@new_resource.name}" /tr "#{@new_resource.command}"
#             /u #{@new_resource.user} /p "#{@new_resource.password}" /F ).gsub( /\n/, " ")

#    create_cmd = %Q(schtasks /create /sc #{@new_resource.frequency} /mo #{@new_resource.recurrence} 
#             /tn "#{@new_resource.name}" /tr "#{@new_resource.command}"
#             /ru #{@new_resource.user} /p "#{@new_resource.password}" /F ).gsub( /\n/, " ")


# Known good :P
#    create_cmd = %Q(schtasks /create /sc #{@new_resource.frequency} /mo #{@new_resource.recurrence} 
#             /tn "#{@new_resource.name}" /tr "#{@new_resource.command}"
#             /ru #{@new_resource.user} /F ).gsub( /\n/, " ")


  
    create_cmd = %Q(schtasks /create /sc #{@new_resource.frequency} /mo #{@new_resource.every} 
             /tn "#{@new_resource.name}" /tr "#{@new_resource.command}"
             /ru #{@new_resource.user} /F ).gsub( /\n/, " ")


    # Set day/month
    unless @new_resource.day == "all"
      create_cmd  << " /d #{@new_resource.day} "
    end

    unless @new_resource.month == "all"
      create_cmd  << " /m #{@new_resource.month} "
    end
    # Specify start time/date
    unless @new_resource.start_time == "now"
      create_cmd  << " /st #{@new_resource.start_time} "
    end
    unless @new_resource.start_date == "now"
      create_cmd  << " /sd #{@new_resource.start_date} "
    end
    
    # Maxduration
    unless @new_resource.max_duration == "forever"
      create_cmd  << " /du #{@new_resource.max_duration} "
    end
    unless @new_resource.kill_after == "forever"
      create_cmd  << " /k /du #{@new_resource.kill_after} "
    end

    Chef::Log.info("Creating scheduled task #{@new_resource.name} every #{@new_resource.every } #{@new_resource.frequency} ")
    Chef::Log.debug("cmd=\n#{create_cmd}")
    shell_out!(create_cmd)

    # UNTESTED!
    #    unless @new_resource.working_directory == "none"
    #      dump_path = Chef::Config[:file_cache_path] + "/tmp-sched-task-dump.xml"
    #      dump_cmd = "schedtask /query /xml /tn #{@new_resource.name} > #{dump_path}"
    #
    #      shell_out!(dump_cmd)
    #
    #      insert_working_directory(@new_resource.working_directory, dump_path)
    #
    #      reload_cmd =  "schedtask /create /tn #{@new_resource.name} /xml #{dump_path} /F"
    #      shell_out!(reload_cmd)
    #    end
end



action :delete do

#schtasks /delete /tn {TaskName | *} [/f] [/s Computer [/u [Domain\]User [/p Password]]]
#/u [Domain\]User
#Runs this command with the permissions of the specified user account. By default, the command runs with the permissions of the current user of the local computer.
#The specified user account must be a member of the Administrators group on the remote computer. The /u and /p parameters are valid only when you use /s.
#/f
#Suppresses the confirmation message. The task is deleted without warning.

#    delete_cmd= %Q(schtasks /delete /f /tn "#{@new_resource.name}" /tr "#{@new_resource.command}"
#             /u #{@new_resource.user} /p "#{@new_resource.password}" /F ).gsub( /\n/, " ")
    delete_cmd= %Q(schtasks /delete /f /tn "#{@new_resource.name}" )

    Chef::Log.info("Deleting scheduled task #{@new_resource.name}")
    shell_out!(delete_cmd)
end

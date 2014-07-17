

node['keboola-connection']['workers'].each do | queueName, count |

	$i = 1
    $num = count.to_i

    while $i <= $num  do
       execute "start worker N=#{$i} QUEUE=#{queueName}" do
         command "start connection.queue-receive N=#{$i} QUEUE=#{queueName}"
         not_if "status connection.queue-receive N=#{$i} QUEUE=#{queueName}"
       end
       $i +=1
    end

end
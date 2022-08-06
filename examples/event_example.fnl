
ns main

import evenz
import stdtime

my-publisher = proc(es)
	publish = get(es 'publish')
	_ = call(stdtime.sleep 1)

	_ = call(publish list('this' 'is' 'event'))
	_ = call(stdtime.sleep 2)
	_ = call(publish list('this' 'is' 'event' 'too'))
	_ = call(stdtime.sleep 2)
	'none'
end

my-listener = proc(es myname wait-time)
	my-handler = proc(event)
		print(sprintf('%s: Received: %v' myname event))
	end

	my-matcher = func(event)
		in(event 'is')
	end

	listener = call(get(es 'new-listener') my-matcher my-handler)
	listen = get(listener 'listen')
	cancel = get(listener 'cancel')

	# create fiber which cancels event listening after waiting time
	_ = spawn(call(proc()
		_ = call(stdtime.sleep wait-time)
		call(cancel)
	end))

	print(myname ': quit listening: ' call(listen))
end

main = proc()
	# create event service object
	es = call(evenz.new-evenz)

	# create publisher fiber
	_ = spawn(call(my-publisher es))

	# create some listner fibers
	_ = spawn(call(my-listener es 'listener-1' 2))
	_ = spawn(call(my-listener es 'listener-2' 100))

	call(stdtime.sleep 4)
end

endns


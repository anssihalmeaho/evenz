# evenz
Event library for FunL

**evenz** provides event sending and receiving services for [FunL](https://github.com/anssihalmeaho/funl) programming language.
It implements event service for concurrent fibers inside one process.
Events can be any FunL values.

## new-evenz
Creates new event service object.

Format:

```
call(evenz.new-evenz) -> event service object
```

## event service object
Client creates new event service object which is used for creating new listener objects and for publishing events.

Event service object is **map** which contains:

| Key | Value |
| --- | ----- |
| 'new-listener' | listener object factory method (procedure) |
| 'publish' | publish method (procedure) |


### publish method
Publishes event.

Format:

```
call(publish <event:value>) -> bool
```

Return value is **true** if event was successfully sent, **false** otherwise.

### listener object factory method
Creates new listener object for given matcher and event-handler procedures.
Matcher function defines "event subscription".

Format:

```
call(new-listener <matcher:func> <handler:proc>) -> listener object
```

Format of matcher function is:

```
func(<event:value>) -> bool
```

If matcher returns **true** then event-handler is called, otherwise not.

Format of event-handler procedure is:

```
proc(<event:value>) -> return value does not matter
```


## listener object

Listener object is **map** which contains:

| Key | Value |
| --- | ----- |
| 'listen' | procedure which starts event listening (blocks caller) |
| 'cancel' | procedure which stops event listening |

### listen method
Starts event listening. Blocks client fiber to procedure call unless
listening is stopped (or other failure).

Return value is string which explains reason for returning from call.

Format:

```
call(listen) -> <explanation:string>
```

### cancel method
Stops listening. Causes return from listen call for listening fiber.

Format:

```
call(cancel) -> bool
```

Return value is **true** if stopping was initiated, **false** if not.
(in practise should be always **true**)

## Example

Example code can be found in [/examples](https://github.com/anssihalmeaho/evenz/blob/main/examples/event_example.fnl).

When running that with **funla** interpreter it should output something like:

```
funla examples/event_example.fnl

listener-2: Received: list('this', 'is', 'event')
listener-1: Received: list('this', 'is', 'event')
listener-1: quit listening: listening cancelled
listener-2: Received: list('this', 'is', 'event', 'too')
true
```


## ToDo
Items for further development are:

* distributed event service (between many processes)

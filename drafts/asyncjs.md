# asynchronous javascript

## Talk about complicated...

So here are some notes on various strategies pertaining to the use of
asynchronous javascript.

There is a well thought out chapter in [eloquent javascript](https://eloquentjavascript.net/code/#11.1)
on the topic that goes into some detail. Asynchronous code is hairy no matter what way you look
at it. The first example below `locateScalpel` is defined as an async function,
it's rolling out and infinite loop to iterate through nodes on a network.
The second function `locateScalpel2` avoids explicit use of async declaration

Both blocks have positive attributes that we'd like to use for our own
approach. The first block uses `async` and `await` keywords, which also means
that it avoids having to chain together callbacks with lots of dots...because
who needs dots, right? The second somehow made more sense to me initially because 
I'm learning scheme. It avoids explicit use of async declaration and makes use of 
javascript closures.

```
// example from eloquent javascript chpt. 11
// (relies on predefined function anyStorage)
async function locateScalpel(nest) {
  let current = nest.name;
  for (;;) {
    let next = await anyStorage(nest, current, "scalpel");
    if (next == current) return current;
    current = next;
  }
}


function locateScalpel2(nest) {
  function loop(current) {
    return anyStorage(nest, current, "scalpel").then(next => {
      if (next === current) return current;
      else return loop(next);
    });
  }
  return loop(nest.name);
}
```


Whatever way we go, we arrive at a commond call to `anyStorage`.


### Beginning of call stack list
```
anyStorage
```

If we further trace `anyStorage`, we see that the function contains two conditional
branches, depending on the values passed in as arguments the call stack list
will continue to grow as follows:

### call stack list (branch1):

This branch is chosen if the source is equal to the name of the nest (node) currently
being audited. Basically it means that we've found what we're looking for, so the
contents of the readStorage call becomes the result that is passed to the
`Promise`'s `resolve` method.

```
anyStorage - storage
anyStorage - storage - Promise
anyStorage - storage - Promise - readStorage
anyStorage - storage - Promise - readStorage - resolve

```

### class stack list (branch2):

The second branch is executed if the source and nest name differ. In this case,
the current nest (node) is set as the origin of the request for a route and the
source is set as the target. The request function explicity seeks a route
to the node pointed to by source.

```
anyStorage - routeRequest
anyStorage - routeRequest - request
anyStorage - routeRequest - request - Promise
anyStorage - routeRequest - request - Promise - attempt
anyStorage - routeRequest - request - Promise - attempt - send
anyStorage - routeRequest - request - Promise - attempt - send - reject | resolve
```

It's necessary to dig in to Marin Haverbeke's code in order to undestand
exactly what's going on. There's more complexity to the example he is showing
here, particularly in and around the model of network that he is constructing.
I highly recommend reading his book, it encourages the reader to dig in to core 
concepts and practices at work in javascript. 

## A simple use case

Okay, so the whole reason why I started looking into asynchronous javascript in
the first place was because I have to design a couple of simple web clients at
work. A typical situtaion is that I want to handle some authentication, and
then go on to make some requests to an API while passing the token in the
request headers. Just to get a handle on exactly what is going on when we
perform such requests, I used this fairly standardized function to query a
dummy endpoint that is set up on my local machine. This is pretty much all
there is to it for the time beeing, but see the code on [github](https://github.com/adammccartney/adapi-client) 
if you want to play around with it yourself.

```
async function fetchToken () {
    try {
        const response = await fetch("http://127.0.0.1:9001/tok.json");
        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }
        const json = await response.json();
        console.log(json[0].GITLAB_API_TOKEN);
    }
    catch (error) {
        console.error(`Could not retrieve token: ${error}`);
    }
}

fetchToken();
```


### Resources

When it comes to the bricks and mortar stuff of javascript, I find the
[mdn](https://developer.mozilla.org/en-US/docs/Web/JavaScript) pretty great.
In particalar, they have a nice series on [asynchronous javascript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous)


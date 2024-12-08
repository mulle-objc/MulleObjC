# TAO Strategy

These tests show a value being passed from

* caller to thread: `forward`
* thread to caller: `backward` (using NSInvocation)
* transfering ownership back and forth: `backandforth` using


Ownership transfer backwards can not be done with detached threads.
